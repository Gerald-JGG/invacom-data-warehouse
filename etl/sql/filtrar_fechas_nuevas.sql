-- Spark SQL, nodo visual Filtrar fechas nuevas.
-- origen: SQL Query calendario; existentes: JDBC invacom_dw.DimFecha.
SELECT DISTINCT
    o.FechaKey, o.Fecha, o.Anio, o.Trimestre, o.Mes, o.Dia
FROM origen o
LEFT ANTI JOIN existentes e ON o.FechaKey = e.FechaKey
