# 09 — Recepción de los 11 CSV en MySQL

Fecha: 10 de noviembre de 2026. Estado: scripts preparados localmente; pendientes de ejecución en RDS y cargas en Glue.

## Separación entre fuente y modelo dimensional

Por solicitud del usuario se preparan destinos para todos los CSV. Se utiliza la base existente `invacom_dw` y el prefijo `Stg` para distinguir las tablas de recepción de las dimensiones y hechos. No se modifican las cuatro tablas existentes, sus datos ni el diagrama.

`StgEmployee` recibe los empleados originales; no es una dimensión analítica `DimEmpleado`. Incorporar esa dimensión y su relación con las ventas requiere definir un cambio del modelo. Los jobs dimensionales pueden seguir leyendo directamente S3 como hasta ahora; staging es una recepción adicional, no un requisito nuevo de la guía confirmado con el profesor.

## Ejecución

1. En la conexión existente de Workbench, abrir y ejecutar completo [04_crear_staging_chinook_mysql.sql](../sql/04_crear_staging_chinook_mysql.sql).
2. Revisar Action Output y el resultado final: deben aparecer las 11 tablas `Stg`. `IF NOT EXISTS` no valida ni modifica una tabla previa del mismo nombre; si ya existe una, comparar su estructura antes de cargar.
3. Ejecutar el crawler existente `invacom-crawler-mysql-dw`, cuyo include path es `invacom_dw/%`, y comprobar las nuevas entradas en `invacom_catalog`. Conserva también las cuatro entradas anteriores. Si faltan tablas, revisar el resultado del crawler.
4. En cada flujo de recepción de Glue usar el CSV exacto de `s3://invacom-chinook-2026/raw/`, encabezados y delimitador coma; transformar los tipos y seleccionar la tabla staging correspondiente del catálogo.
5. Después de cargar, ejecutar [05_validar_staging_chinook_mysql.sql](../sql/05_validar_staging_chinook_mysql.sql). Los conteos por sí solos no comprueban todos los valores ni las relaciones.

| CSV | Tabla MySQL | Filas esperadas |
| --- | --- | --- |
| Artist.csv | StgArtist | 275 |
| Album.csv | StgAlbum | 347 |
| MediaType.csv | StgMediaType | 5 |
| Genre.csv | StgGenre | 25 |
| Track.csv | StgTrack | 3503 |
| Employee.csv | StgEmployee | 8 |
| Customer.csv | StgCustomer | 59 |
| Invoice.csv | StgInvoice | 412 |
| InvoiceLine.csv | StgInvoiceLine | 2240 |
| Playlist.csv | StgPlaylist | 18 |
| PlaylistTrack.csv | StgPlaylistTrack | 8715 |

Los nombres de las entradas del catálogo pueden normalizarse a minúsculas y añadir el nombre de la base, como ocurrió con `invacom_dw_dimcliente`. Verificar la ubicación física de la entrada elegida; no confundir `StgCustomer` con `DimCliente`.

## Tipos, vacíos y recargas

Las columnas conservan los nombres de los encabezados originales. Los IDs son INT; Bytes es BIGINT; UnitPrice y Total son DECIMAL(12,2); las fechas son DATETIME. Las longitudes de texto se contrastaron con los 11 CSV locales. En Glue convertir explícitamente los strings inferidos a esos tipos y convertir campos numéricos o de fecha vacíos en NULL antes de escribir. Mantener fechas completas de nacimiento y contratación de Employee.

Las columnas no pertenecientes a la clave admiten NULL. Conservar los atributos originales en staging: no aplicar aquí la concatenación y selección reducida de campos de DimCliente. Por ejemplo, cargar los 15 atributos de Employee, no la transformación de clientes.

Cada tabla tiene una PK con el ID de fuente; PlaylistTrack usa la combinación PlaylistId y TrackId. No se definen FK en staging para permitir recepción en cualquier orden; las relaciones deben validarse antes de construir el DW. No se desactivan las FK existentes del modelo dimensional.

Los scripts crean estructura y consultan conteos: no leen S3 ni insertan registros. Una segunda carga INSERT con las mismas claves puede fallar. No hay upsert ni reemplazo automático; no volver a ejecutar jobs de carga sin definir esa estrategia y revisar resultados de intentos parciales.

## Verificación local y límites

Se contrastaron los encabezados, las longitudes de texto y los valores enteros con los CSV locales. No se ejecutaron estos nuevos scripts en un motor MySQL ni en RDS desde Codex. La evidencia previa de DimCliente no acredita cargas en staging. El total esperado de staging es 15.607 filas repartidas en 11 tablas.
