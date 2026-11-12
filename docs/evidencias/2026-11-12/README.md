# Evidencias de recargas — 12 de noviembre de 2026

Capturas aportadas por Gerald en el chat, copiadas sin editar desde los adjuntos.
`integridad.json` registra nombre, tamano y SHA-256 de los seis PNG originales.
Fecha de esta carpeta: jornada de pruebas y recepcion de las capturas; no reemplaza
la fecha historica de creacion de cada recurso AWS que aparezca en pantalla.

| Archivo | Que demuestra |
| --- | --- |
| [01-clientes-filtro-visual.png](01-clientes-filtro-visual.png) | Job visual guardado; dos padres, alias origen/existentes, anti join por CustomerId y preview de 0 filas |
| [02-clientes-claves-temporales.png](02-clientes-claves-temporales.png) | Workbench creo ClientesAntesRecarga con 59 registros; los errores 1050 posteriores se deben a intentar crear de nuevo esa misma tabla temporal |
| [03-canciones-filtro-alias-correctos.png](03-canciones-filtro-alias-correctos.png) | Filtro visual con alias correctos y anti join por TrackId; preview de 196 filas de muestra, no conteo completo de carga |
| [04-canciones-conteos.png](04-canciones-conteos.png) | 3503 canciones, 3503 TrackId y 3503 CancionKey distintos |
| [05-ventas-flujo-visual.png](05-ventas-flujo-visual.png) | Cinco fuentes conectadas a Transformar ventas, lectura de Ventas existentes separada y filtro antes de Cargar FactVenta |
| [06-ventas-conteos.png](06-ventas-conteos.png) | 2240 lineas, 2240 IDs de detalle, 412 facturas, 2240 unidades y 2328.60 importe |

Resultados reportados por Gerald, sin capturas especificas de estos resultados:

- Dos ejecuciones Succeeded del job adicional de recarga de clientes; conteos
  59/59/59/29 y comparacion de claves sin cambios ni eliminaciones.
- Ejecucion Succeeded del visual de clientes y datos sin cambios.
- Ejecucion Succeeded de fechas y controles 1817/1817/2009-01-01/2013-12-22.

La copia temporal de claves ya existia cuando se intento crear por segunda vez.
No se puede atribuir una comparacion a una captura que no muestra su resultado;
por eso se distingue la confirmacion textual de la evidencia visual.

Para reproducir los controles: [SQL de validacion](../../../sql/07_validar_recargas_dw_mysql.sql).
Explicacion: [recargas visuales](../../14-recargas-visuales.md).
