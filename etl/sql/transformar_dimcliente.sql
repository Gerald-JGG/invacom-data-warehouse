-- Spark SQL para el nodo SQL Query de AWS Glue Studio.
-- Entrada: Customer.csv; alias configurado en el nodo: myDataSource.
-- No ejecutar en MySQL Workbench: myDataSource existe dentro del job Glue.
-- ClienteKey se omite para que MySQL la genere con AUTO_INCREMENT.
SELECT
    CAST(CustomerId AS INT) AS CustomerId,
    TRIM(CONCAT_WS(' ', TRIM(FirstName), TRIM(LastName))) AS NombreCompleto,
    TRIM(Country) AS Pais,
    COALESCE(NULLIF(TRIM(State), ''), 'Sin dato') AS Estado,
    TRIM(City) AS Ciudad
FROM myDataSource
