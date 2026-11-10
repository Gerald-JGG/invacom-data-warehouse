-- Solo lectura. Ejecutar en MySQL Workbench despues del job de clientes.
USE `invacom_dw`;

-- Esperado para la instantanea recibida: 59 / 59 / 59.
SELECT
    COUNT(*) AS Clientes,
    COUNT(DISTINCT CustomerId) AS IDsUnicos,
    COUNT(DISTINCT ClienteKey) AS ClavesUnicas
FROM DimCliente;

-- Esperado: 29.
SELECT COUNT(*) AS EstadosSinDato
FROM DimCliente
WHERE Estado = 'Sin dato';

-- Revisar nombres, caracteres internacionales y claves generadas.
SELECT *
FROM DimCliente
ORDER BY CustomerId
LIMIT 10;
