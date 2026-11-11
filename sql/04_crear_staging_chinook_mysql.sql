-- Recepcion de los 11 CSV de Chinook en tablas staging.
-- Ejecutar en MySQL Workbench sobre la instancia existente.
-- NO carga los archivos: las inserciones se realizan despues con AWS Glue.
-- NO modifica DimCliente, DimFecha, DimCancion ni FactVenta.
-- IF NOT EXISTS no migra ni comprueba una tabla previa del mismo nombre.
-- Sin FK en staging para permitir cargar los archivos en cualquier orden.
-- Las PK detectan duplicados; este script no implementa recargas/upserts.
USE `invacom_dw`;
SET NAMES utf8mb4;

-- Artist.csv: 275 filas de fuente, sin encabezado.
CREATE TABLE IF NOT EXISTS `StgArtist` (
    `ArtistId` INT NOT NULL,
    `Name` VARCHAR(300) NULL,
    PRIMARY KEY (`ArtistId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Album.csv: 347 filas de fuente, sin encabezado.
CREATE TABLE IF NOT EXISTS `StgAlbum` (
    `AlbumId` INT NOT NULL,
    `Title` VARCHAR(300) NULL,
    `ArtistId` INT NULL,
    PRIMARY KEY (`AlbumId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- MediaType.csv: 5 filas de fuente, sin encabezado.
CREATE TABLE IF NOT EXISTS `StgMediaType` (
    `MediaTypeId` INT NOT NULL,
    `Name` VARCHAR(300) NULL,
    PRIMARY KEY (`MediaTypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Genre.csv: 25 filas de fuente, sin encabezado.
CREATE TABLE IF NOT EXISTS `StgGenre` (
    `GenreId` INT NOT NULL,
    `Name` VARCHAR(300) NULL,
    PRIMARY KEY (`GenreId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Track.csv: 3503 filas de fuente, sin encabezado.
CREATE TABLE IF NOT EXISTS `StgTrack` (
    `TrackId` INT NOT NULL,
    `Name` VARCHAR(300) NULL,
    `AlbumId` INT NULL,
    `MediaTypeId` INT NULL,
    `GenreId` INT NULL,
    `Composer` VARCHAR(1000) NULL,
    `Milliseconds` INT NULL,
    `Bytes` BIGINT NULL,
    `UnitPrice` DECIMAL(12,2) NULL,
    PRIMARY KEY (`TrackId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Employee.csv: 8 filas de fuente, sin encabezado.
CREATE TABLE IF NOT EXISTS `StgEmployee` (
    `EmployeeId` INT NOT NULL,
    `LastName` VARCHAR(100) NULL,
    `FirstName` VARCHAR(100) NULL,
    `Title` VARCHAR(300) NULL,
    `ReportsTo` INT NULL,
    `BirthDate` DATETIME NULL,
    `HireDate` DATETIME NULL,
    `Address` VARCHAR(200) NULL,
    `City` VARCHAR(100) NULL,
    `State` VARCHAR(100) NULL,
    `Country` VARCHAR(100) NULL,
    `PostalCode` VARCHAR(30) NULL,
    `Phone` VARCHAR(60) NULL,
    `Fax` VARCHAR(60) NULL,
    `Email` VARCHAR(200) NULL,
    PRIMARY KEY (`EmployeeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Customer.csv: 59 filas de fuente, sin encabezado.
CREATE TABLE IF NOT EXISTS `StgCustomer` (
    `CustomerId` INT NOT NULL,
    `FirstName` VARCHAR(100) NULL,
    `LastName` VARCHAR(100) NULL,
    `Company` VARCHAR(200) NULL,
    `Address` VARCHAR(200) NULL,
    `City` VARCHAR(100) NULL,
    `State` VARCHAR(100) NULL,
    `Country` VARCHAR(100) NULL,
    `PostalCode` VARCHAR(30) NULL,
    `Phone` VARCHAR(60) NULL,
    `Fax` VARCHAR(60) NULL,
    `Email` VARCHAR(200) NULL,
    `SupportRepId` INT NULL,
    PRIMARY KEY (`CustomerId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Invoice.csv: 412 filas de fuente, sin encabezado.
CREATE TABLE IF NOT EXISTS `StgInvoice` (
    `InvoiceId` INT NOT NULL,
    `CustomerId` INT NULL,
    `InvoiceDate` DATETIME NULL,
    `BillingAddress` VARCHAR(200) NULL,
    `BillingCity` VARCHAR(100) NULL,
    `BillingState` VARCHAR(100) NULL,
    `BillingCountry` VARCHAR(100) NULL,
    `BillingPostalCode` VARCHAR(30) NULL,
    `Total` DECIMAL(12,2) NULL,
    PRIMARY KEY (`InvoiceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- InvoiceLine.csv: 2240 filas de fuente, sin encabezado.
CREATE TABLE IF NOT EXISTS `StgInvoiceLine` (
    `InvoiceLineId` INT NOT NULL,
    `InvoiceId` INT NULL,
    `TrackId` INT NULL,
    `UnitPrice` DECIMAL(12,2) NULL,
    `Quantity` INT NULL,
    PRIMARY KEY (`InvoiceLineId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Playlist.csv: 18 filas de fuente, sin encabezado.
CREATE TABLE IF NOT EXISTS `StgPlaylist` (
    `PlaylistId` INT NOT NULL,
    `Name` VARCHAR(300) NULL,
    PRIMARY KEY (`PlaylistId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PlaylistTrack.csv: 8715 filas de fuente, sin encabezado.
CREATE TABLE IF NOT EXISTS `StgPlaylistTrack` (
    `PlaylistId` INT NOT NULL,
    `TrackId` INT NOT NULL,
    PRIMARY KEY (`PlaylistId`, `TrackId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Verificar las 11 tablas creadas (solo estructura).
SELECT TABLE_NAME
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME IN ('StgArtist', 'StgAlbum', 'StgMediaType', 'StgGenre', 'StgTrack', 'StgEmployee', 'StgCustomer', 'StgInvoice', 'StgInvoiceLine', 'StgPlaylist', 'StgPlaylistTrack')
ORDER BY TABLE_NAME;
