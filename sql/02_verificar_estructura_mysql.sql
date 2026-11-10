-- Consultas de solo lectura. Ejecutar despues de 01_crear_dw_mysql.sql.
USE `invacom_dw`;

SELECT VERSION() AS VersionMySQL, DATABASE() AS BaseActual;

-- Esperado: cuatro tablas de este modelo con ENGINE = InnoDB.
SELECT TABLE_NAME, ENGINE, TABLE_COLLATION
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME IN ('DimFecha', 'DimCliente', 'DimCancion', 'FactVenta')
ORDER BY TABLE_NAME;

-- Revisar nombres, tipos, nulabilidad y AUTO_INCREMENT de las claves sustitutas.
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_KEY, EXTRA
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME IN ('DimFecha', 'DimCliente', 'DimCancion', 'FactVenta')
ORDER BY TABLE_NAME, ORDINAL_POSITION;

-- Esperado: cuatro claves primarias, tres UNIQUE y tres FOREIGN KEY.
-- Los CHECK deben mostrar ENFORCED = YES.
SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE, ENFORCED
FROM information_schema.TABLE_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA = DATABASE()
  AND TABLE_NAME IN ('DimFecha', 'DimCliente', 'DimCancion', 'FactVenta')
ORDER BY TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME;

-- Esperado: tres relaciones desde FactVenta a las dimensiones.
SELECT TABLE_NAME, COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'FactVenta'
  AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY COLUMN_NAME;

-- Esperado inmediatamente despues de crear el modelo: cero en las cuatro.
-- Tras cargar datos, estos conteos cambiaran; no volver a exigir cero.
SELECT 'DimFecha' AS Tabla, COUNT(*) AS Filas FROM `DimFecha`
UNION ALL
SELECT 'DimCliente', COUNT(*) FROM `DimCliente`
UNION ALL
SELECT 'DimCancion', COUNT(*) FROM `DimCancion`
UNION ALL
SELECT 'FactVenta', COUNT(*) FROM `FactVenta`;
