import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue import DynamicFrame

def sparkSqlQuery(glueContext, query, mapping, transformation_ctx) -> DynamicFrame:
    for alias, frame in mapping.items():
        frame.toDF().createOrReplaceTempView(alias)
    result = spark.sql(query)
    return DynamicFrame.fromDF(result, glueContext, transformation_ctx)
args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Script generated for node Customer CSV
CustomerCSV_node1794287919504 = glueContext.create_dynamic_frame.from_options(format_options={"quoteChar": "\"", "withHeader": True, "separator": ",", "optimizePerformance": False}, connection_type="s3", format="csv", connection_options={"paths": ["s3://invacom-chinook-2026/raw/Customer.csv"]}, transformation_ctx="CustomerCSV_node1794287919504")

# Script generated for node Transformar clientes
SqlQuery139 = '''
SELECT
    CAST(CustomerId AS INT) AS CustomerId,
    TRIM(CONCAT_WS(' ', TRIM(FirstName), TRIM(LastName))) AS NombreCompleto,
    TRIM(Country) AS Pais,
    COALESCE(NULLIF(TRIM(State), ''), 'Sin dato') AS Estado,
    TRIM(City) AS Ciudad
FROM myDataSource
'''
Transformarclientes_node1794288038673 = sparkSqlQuery(glueContext, query = SqlQuery139, mapping = {"myDataSource":CustomerCSV_node1794287919504}, transformation_ctx = "Transformarclientes_node1794288038673")

# Script generated for node MySQL
MySQL_node1794286010395 = glueContext.write_dynamic_frame.from_catalog(frame=Transformarclientes_node1794288038673, database="invacom_catalog", table_name="invacom_dw_dimcliente", transformation_ctx="MySQL_node1794286010395")

job.commit()