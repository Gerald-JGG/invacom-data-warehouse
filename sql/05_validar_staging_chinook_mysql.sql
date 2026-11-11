-- Solo lectura. Ejecutar despues de las cargas de Glue.
USE `invacom_dw`;

SELECT 'Artist.csv' AS Archivo, 'StgArtist' AS Tabla, 275 AS Esperadas, COUNT(*) AS Cargadas, CASE WHEN COUNT(*) = 275 THEN 'COINCIDE' ELSE 'REVISAR' END AS Resultado FROM `StgArtist`
UNION ALL
SELECT 'Album.csv' AS Archivo, 'StgAlbum' AS Tabla, 347 AS Esperadas, COUNT(*) AS Cargadas, CASE WHEN COUNT(*) = 347 THEN 'COINCIDE' ELSE 'REVISAR' END AS Resultado FROM `StgAlbum`
UNION ALL
SELECT 'MediaType.csv' AS Archivo, 'StgMediaType' AS Tabla, 5 AS Esperadas, COUNT(*) AS Cargadas, CASE WHEN COUNT(*) = 5 THEN 'COINCIDE' ELSE 'REVISAR' END AS Resultado FROM `StgMediaType`
UNION ALL
SELECT 'Genre.csv' AS Archivo, 'StgGenre' AS Tabla, 25 AS Esperadas, COUNT(*) AS Cargadas, CASE WHEN COUNT(*) = 25 THEN 'COINCIDE' ELSE 'REVISAR' END AS Resultado FROM `StgGenre`
UNION ALL
SELECT 'Track.csv' AS Archivo, 'StgTrack' AS Tabla, 3503 AS Esperadas, COUNT(*) AS Cargadas, CASE WHEN COUNT(*) = 3503 THEN 'COINCIDE' ELSE 'REVISAR' END AS Resultado FROM `StgTrack`
UNION ALL
SELECT 'Employee.csv' AS Archivo, 'StgEmployee' AS Tabla, 8 AS Esperadas, COUNT(*) AS Cargadas, CASE WHEN COUNT(*) = 8 THEN 'COINCIDE' ELSE 'REVISAR' END AS Resultado FROM `StgEmployee`
UNION ALL
SELECT 'Customer.csv' AS Archivo, 'StgCustomer' AS Tabla, 59 AS Esperadas, COUNT(*) AS Cargadas, CASE WHEN COUNT(*) = 59 THEN 'COINCIDE' ELSE 'REVISAR' END AS Resultado FROM `StgCustomer`
UNION ALL
SELECT 'Invoice.csv' AS Archivo, 'StgInvoice' AS Tabla, 412 AS Esperadas, COUNT(*) AS Cargadas, CASE WHEN COUNT(*) = 412 THEN 'COINCIDE' ELSE 'REVISAR' END AS Resultado FROM `StgInvoice`
UNION ALL
SELECT 'InvoiceLine.csv' AS Archivo, 'StgInvoiceLine' AS Tabla, 2240 AS Esperadas, COUNT(*) AS Cargadas, CASE WHEN COUNT(*) = 2240 THEN 'COINCIDE' ELSE 'REVISAR' END AS Resultado FROM `StgInvoiceLine`
UNION ALL
SELECT 'Playlist.csv' AS Archivo, 'StgPlaylist' AS Tabla, 18 AS Esperadas, COUNT(*) AS Cargadas, CASE WHEN COUNT(*) = 18 THEN 'COINCIDE' ELSE 'REVISAR' END AS Resultado FROM `StgPlaylist`
UNION ALL
SELECT 'PlaylistTrack.csv' AS Archivo, 'StgPlaylistTrack' AS Tabla, 8715 AS Esperadas, COUNT(*) AS Cargadas, CASE WHEN COUNT(*) = 8715 THEN 'COINCIDE' ELSE 'REVISAR' END AS Resultado FROM `StgPlaylistTrack`;
