-- Prueba de recarga: ejecutar ANTES y DESPUES en la MISMA sesion de Workbench.
-- Solo crea una tabla temporal de comprobacion. No cambia tablas del DW.
USE invacom_dw;

-- ANTES: ejecutar una vez, antes de la primera recarga.
CREATE TEMPORARY TABLE ClientesAntesRecarga AS
SELECT CustomerId, ClienteKey FROM DimCliente;

SELECT COUNT(*) AS ClientesAntes FROM ClientesAntesRecarga;

-- DESPUES: ejecutar este bloque despues de CADA una de las dos recargas.
SELECT COUNT(*) AS Clientes,
       COUNT(DISTINCT CustomerId) AS IDsUnicos,
       COUNT(DISTINCT ClienteKey) AS ClavesUnicas,
       SUM(Estado = 'Sin dato') AS EstadosSinDato
FROM DimCliente;

SELECT COUNT(*) AS ClientesAnterioresEliminadosOConClaveDistinta
FROM ClientesAntesRecarga a
LEFT JOIN DimCliente c ON c.CustomerId = a.CustomerId
WHERE c.CustomerId IS NULL OR c.ClienteKey <> a.ClienteKey;

SELECT COUNT(*) AS VentasSinCliente
FROM FactVenta v
LEFT JOIN DimCliente c ON c.ClienteKey = v.ClienteKey
WHERE c.ClienteKey IS NULL;

SELECT COUNT(*) AS LineasVenta, SUM(ImporteVenta) AS ImporteTotal
FROM FactVenta;
-- Sin cambios de origen: 59/59/59/29; 0 claves cambiadas; 0 ventas sin cliente.
-- Ventas previamente comprobadas: 2240 lineas y 2328.60 de importe.
