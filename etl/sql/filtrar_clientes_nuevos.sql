-- Spark SQL, nodo visual Filtrar clientes nuevos.
-- origen: Transformar clientes; existentes: JDBC invacom_dw.DimCliente.
-- Solo inserciones nuevas; no actualiza los atributos de clientes existentes.
SELECT DISTINCT
    o.CustomerId, o.NombreCompleto, o.Pais, o.Estado, o.Ciudad
FROM origen o
LEFT ANTI JOIN existentes e ON o.CustomerId = e.CustomerId
