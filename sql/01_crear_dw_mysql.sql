-- Proyecto 1: Data Warehouse de ventas de Chinook.
-- Destino: Amazon RDS for MySQL 8.4; base invacom_dw ya creada.
-- Ejecutar completo desde MySQL Workbench, en la conexion Invacom DW.
-- Crea estructura; no carga datos ni elimina tablas existentes.
-- IF NOT EXISTS no modifica ni valida una tabla que ya exista.

USE `invacom_dw`;
SET NAMES utf8mb4;

-- Dimensiones: cargar antes que FactVenta.
CREATE TABLE IF NOT EXISTS `DimFecha` (
    `FechaKey` INT NOT NULL COMMENT 'Clave calendario AAAAMMDD',
    `Fecha` DATE NOT NULL,
    `Anio` SMALLINT NOT NULL,
    `Trimestre` TINYINT NOT NULL,
    `Mes` TINYINT NOT NULL,
    `Dia` TINYINT NOT NULL,
    PRIMARY KEY (`FechaKey`),
    CONSTRAINT `uq_dimfecha_fecha` UNIQUE (`Fecha`),
    CONSTRAINT `ck_dimfecha_calendario` CHECK (
        `FechaKey` = YEAR(`Fecha`) * 10000 + MONTH(`Fecha`) * 100 + DAYOFMONTH(`Fecha`)
        AND `Anio` = YEAR(`Fecha`)
        AND `Trimestre` = QUARTER(`Fecha`)
        AND `Mes` = MONTH(`Fecha`)
        AND `Dia` = DAYOFMONTH(`Fecha`)
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `DimCliente` (
    `ClienteKey` INT NOT NULL AUTO_INCREMENT,
    `CustomerId` INT NOT NULL COMMENT 'Clave natural de Customer; conservar en las recargas',
    `NombreCompleto` VARCHAR(200) NOT NULL,
    `Pais` VARCHAR(100) NOT NULL COMMENT 'Customer.Country, no pais de facturacion',
    `Estado` VARCHAR(100) NOT NULL DEFAULT 'Sin dato',
    `Ciudad` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`ClienteKey`),
    CONSTRAINT `uq_dimcliente_customerid` UNIQUE (`CustomerId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `DimCancion` (
    `CancionKey` INT NOT NULL AUTO_INCREMENT,
    `TrackId` INT NOT NULL COMMENT 'Clave natural de Track; conservar en las recargas',
    `NombreCancion` VARCHAR(300) NOT NULL,
    `Album` VARCHAR(300) NOT NULL,
    `Artista` VARCHAR(200) NOT NULL,
    `Genero` VARCHAR(100) NOT NULL,
    `TipoMedio` VARCHAR(100) NOT NULL,
    `DuracionMs` INT NOT NULL,
    PRIMARY KEY (`CancionKey`),
    CONSTRAINT `uq_dimcancion_trackid` UNIQUE (`TrackId`),
    CONSTRAINT `ck_dimcancion_duracion` CHECK (`DuracionMs` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Una fila por InvoiceLineId; el ID evita insertar dos veces el mismo detalle.
-- ImporteVenta lo calcula Glue: Quantity * InvoiceLine.UnitPrice.
-- No usar Track.UnitPrice ni repetir Invoice.Total como importe del detalle.
CREATE TABLE IF NOT EXISTS `FactVenta` (
    `InvoiceLineId` INT NOT NULL COMMENT 'ID del detalle original; dimension degenerada',
    `InvoiceId` INT NOT NULL COMMENT 'ID de factura; dimension degenerada',
    `FechaKey` INT NOT NULL,
    `ClienteKey` INT NOT NULL,
    `CancionKey` INT NOT NULL,
    `Cantidad` INT NOT NULL,
    `PrecioUnitario` DECIMAL(12,2) NOT NULL,
    `ImporteVenta` DECIMAL(14,2) NOT NULL,
    PRIMARY KEY (`InvoiceLineId`),
    KEY `ix_factventa_invoiceid` (`InvoiceId`),
    KEY `ix_factventa_fechakey` (`FechaKey`),
    KEY `ix_factventa_clientekey` (`ClienteKey`),
    KEY `ix_factventa_cancionkey` (`CancionKey`),
    CONSTRAINT `fk_factventa_fecha` FOREIGN KEY (`FechaKey`)
        REFERENCES `DimFecha` (`FechaKey`),
    CONSTRAINT `fk_factventa_cliente` FOREIGN KEY (`ClienteKey`)
        REFERENCES `DimCliente` (`ClienteKey`),
    CONSTRAINT `fk_factventa_cancion` FOREIGN KEY (`CancionKey`)
        REFERENCES `DimCancion` (`CancionKey`),
    CONSTRAINT `ck_factventa_cantidad` CHECK (`Cantidad` > 0),
    CONSTRAINT `ck_factventa_precio` CHECK (`PrecioUnitario` >= 0),
    CONSTRAINT `ck_factventa_importe` CHECK (
        `ImporteVenta` = ROUND(`Cantidad` * `PrecioUnitario`, 2)
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Deben aparecer las cuatro tablas. No implica que ya tengan datos.
SHOW TABLES;
