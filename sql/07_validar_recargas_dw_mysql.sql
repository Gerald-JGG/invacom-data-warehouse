-- MySQL Workbench: controles despues de repetir los cuatro ETL visuales.
-- Consultas de solo lectura. No ejecutar este archivo como Spark SQL.
SELECT COUNT(*) AS Clientes,
       COUNT(DISTINCT CustomerId) AS IDsUnicos,
       COUNT(DISTINCT ClienteKey) AS ClavesUnicas,
       SUM(Estado = 'Sin dato') AS EstadosSinDato
FROM invacom_dw.DimCliente;
-- Esperado para la fuente actual: 59 | 59 | 59 | 29.

SELECT COUNT(*) AS Canciones,
       COUNT(DISTINCT TrackId) AS TracksUnicos,
       COUNT(DISTINCT CancionKey) AS ClavesUnicas
FROM invacom_dw.DimCancion;
-- Esperado: 3503 | 3503 | 3503.

SELECT COUNT(*) AS Fechas,
       COUNT(DISTINCT FechaKey) AS ClavesUnicas,
       MIN(Fecha) AS PrimeraFecha,
       MAX(Fecha) AS UltimaFecha
FROM invacom_dw.DimFecha;
-- Esperado: 1817 | 1817 | 2009-01-01 | 2013-12-22.

SELECT COUNT(*) AS LineasVenta,
       COUNT(DISTINCT InvoiceLineId) AS LineasUnicas,
       COUNT(DISTINCT InvoiceId) AS Facturas,
       SUM(Cantidad) AS Unidades,
       SUM(ImporteVenta) AS ImporteTotal
FROM invacom_dw.FactVenta;
-- Esperado: 2240 | 2240 | 412 | 2240 | 2328.60.

-- Control adicional preparado: todavia no consta un resultado aportado por el equipo.
SELECT COUNT(*) AS VentasSinDimension
FROM invacom_dw.FactVenta v
LEFT JOIN invacom_dw.DimCliente c ON c.ClienteKey = v.ClienteKey
LEFT JOIN invacom_dw.DimCancion t ON t.CancionKey = v.CancionKey
LEFT JOIN invacom_dw.DimFecha f ON f.FechaKey = v.FechaKey
WHERE c.ClienteKey IS NULL OR t.CancionKey IS NULL OR f.FechaKey IS NULL;
-- Esperado: 0.
