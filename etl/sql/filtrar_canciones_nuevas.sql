-- Spark SQL, nodo visual Filtrar canciones nuevas.
-- origen: transformar cancion; existentes: JDBC invacom_dw.DimCancion.
SELECT DISTINCT
    o.TrackId, o.NombreCancion, o.Album, o.Artista,
    o.Genero, o.TipoMedio, o.DuracionMs
FROM origen o
LEFT ANTI JOIN existentes e ON o.TrackId = e.TrackId
