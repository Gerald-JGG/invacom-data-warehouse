"""Recarga de DimCliente por CustomerId; ejecutar como job Spark de AWS Glue.

Version candidata: requiere comprobar dos ejecuciones en AWS antes de sustituir
el job visual original. No elimina clientes ni modifica sus ClienteKey.
"""

import sys

SOURCE = "s3://invacom-chinook-2026/raw/Customer.csv"
CONNECTION = "invacom-mysql-connection"
MAX_ROWS = 10000  # Limite deliberado: este procedimiento es para Chinook pequeno.
FIELDS = ("NombreCompleto", "Pais", "Estado", "Ciudad")
UPSERT = """
INSERT INTO invacom_dw.DimCliente
    (CustomerId, NombreCompleto, Pais, Estado, Ciudad)
VALUES (?, ?, ?, ?, ?) AS entrada
ON DUPLICATE KEY UPDATE
    NombreCompleto = entrada.NombreCompleto,
    Pais = entrada.Pais,
    Estado = entrada.Estado,
    Ciudad = entrada.Ciudad
"""


def validate_rows(rows):
    """Deduplica filas iguales; rechaza conflictos de ID y datos incompatibles."""
    if not rows or len(rows) > MAX_ROWS:
        raise ValueError("Origen vacio o superior al limite permitido; no se carga.")
    customers = {}
    for row in rows:
        customer_id = row["CustomerId"]
        if type(customer_id) is not int or not 0 < customer_id <= 2147483647:
            raise ValueError("CustomerId debe ser un entero positivo de MySQL INT.")
        attributes = tuple(row[field] for field in FIELDS)
        for field, value, size in zip(FIELDS, attributes, (200, 100, 100, 100)):
            if not isinstance(value, str) or not value.strip() or len(value) > size:
                raise ValueError("Atributo vacio o demasiado largo: " + field)
        if customer_id in customers and customers[customer_id] != attributes:
            raise ValueError("CustomerId repetido con atributos diferentes; revisar CSV.")
        customers[customer_id] = attributes
    return [(key,) + customers[key] for key in sorted(customers)]


def write_transaction(connection, rows):
    """Una transaccion MySQL para todo el lote, con sentencias parametrizadas."""
    statement = None
    connection.setAutoCommit(False)
    try:
        statement = connection.prepareStatement(UPSERT)
        statement.setQueryTimeout(60)
        for row in rows:
            statement.setInt(1, row[0])
            for index, value in enumerate(row[1:], start=2):
                statement.setString(index, value)
            statement.executeUpdate()
        connection.commit()
    except Exception:
        connection.rollback()
        raise
    finally:
        if statement is not None:
            statement.close()


def main():
    # Imports dentro de main permiten probar la validacion sin instalar Glue.
    from awsglue.context import GlueContext
    from awsglue.job import Job
    from awsglue.utils import getResolvedOptions
    from pyspark.context import SparkContext

    args = getResolvedOptions(sys.argv, ["JOB_NAME"])
    context = GlueContext(SparkContext.getOrCreate())
    spark = context.spark_session
    job = Job(context)
    job.init(args["JOB_NAME"], args)

    source = context.create_dynamic_frame.from_options(
        connection_type="s3", format="csv",
        format_options={"withHeader": True, "separator": ",", "quoteChar": '"'},
        connection_options={"paths": [SOURCE]},
        transformation_ctx="CustomerCSV",
    )
    source.toDF().createOrReplaceTempView("clientes_csv")
    transformed = spark.sql("""
        SELECT
            CAST(CustomerId AS INT) AS CustomerId,
            TRIM(CONCAT_WS(' ', TRIM(FirstName), TRIM(LastName))) AS NombreCompleto,
            TRIM(Country) AS Pais,
            COALESCE(NULLIF(TRIM(State), ''), 'Sin dato') AS Estado,
            TRIM(City) AS Ciudad
        FROM clientes_csv
    """)
    rows = validate_rows([
        row.asDict() for row in transformed.limit(MAX_ROWS + 1).collect()
    ])

    # Reutiliza credenciales de Glue; nunca imprimir este diccionario.
    config = context.extract_jdbc_conf(connection_name=CONNECTION)
    if not all(config.get(key) for key in ("fullUrl", "user", "password")):
        raise RuntimeError("La conexion Glue no devuelve URL y credenciales JDBC completas.")
    if not config["fullUrl"].startswith("jdbc:mysql://"):
        raise RuntimeError("Se requiere una conexion JDBC MySQL.")
    if config.get("customJDBCCert"):
        raise RuntimeError("Adaptar el certificado JDBC personalizado antes de cargar.")

    jvm = spark.sparkContext._jvm
    properties = jvm.java.util.Properties()
    properties.setProperty("user", config["user"])
    properties.setProperty("password", config["password"])
    properties.setProperty("sslMode", "REQUIRED")
    properties.setProperty("connectTimeout", "10000")
    properties.setProperty("socketTimeout", "120000")
    properties.setProperty("characterEncoding", "UTF-8")
    # Driver incluido en Glue para MySQL; evita instalar librerias por Internet.
    driver = jvm.com.mysql.cj.jdbc.Driver()
    connection = driver.connect(config["fullUrl"], properties)
    if connection is None:
        raise RuntimeError("El driver MySQL no acepta la URL JDBC configurada.")
    try:
        write_transaction(connection, rows)
    finally:
        connection.close()
    print("DimCliente: lote confirmado de {} clientes unicos.".format(len(rows)))
    job.commit()


if __name__ == "__main__":
    main()
