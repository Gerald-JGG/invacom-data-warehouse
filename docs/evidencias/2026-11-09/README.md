# Evidencias — 9 de noviembre de 2026

Capturas y registro de ejecución proporcionados por el usuario durante la configuración guiada. Los archivos se copiaron sin recortar ni modificar. [integridad.json](integridad.json) registra sus SHA-256. La fecha corresponde a Costa Rica (UTC−06:00); algunas pantallas AWS muestran el 10 de noviembre en UTC para esta misma jornada.

| Archivo | Qué acredita | Límite de la evidencia |
| --- | --- | --- |
| [01-conexion-glue-lista.png](01-conexion-glue-lista.png) | Conexión MySQL con aviso verde de disponibilidad | No demuestra por sí sola una carga |
| [02-crawler-cuatro-tablas.png](02-crawler-cuatro-tablas.png) | El crawler agregó cuatro tablas a `invacom_catalog` | En la captura el cierre del crawler aparece como STOPPING; el usuario reportó Completed |
| [03-origen-customer-csv.png](03-origen-customer-csv.png) | Ruta, formato CSV, coma, comillas y encabezado del origen | Recursive aparece marcado en esta captura; se indicó desmarcarlo después, sin captura final de ese campo |
| [04-transformacion-clientes.png](04-transformacion-clientes.png) | SQL, alias y seis columnas de salida con tipos | Verifica configuración y esquema, no todos los registros |
| [05-flujo-clientes.png](05-flujo-clientes.png) | Cadena S3 → SQL → MySQL con nodos validados | No demuestra ejecución |
| [06-recursos-job.png](06-recursos-job.png) | Glue 6.0, G.1X, dos workers, cero reintentos y diez minutos | La configuración puede cambiar después de la captura |
| [07-rutas-conexion-job.png](07-rutas-conexion-job.png) | Rutas propias de S3 y conexión MySQL asociada al job | El desplegable dice None, pero Current connections contiene la conexión |
| [08-ejecucion-job-running.png](08-ejecucion-job-running.png) | Se inició una ejecución del job | Está en Running; el estado final aparece en la captura 13 |
| [09-clientes-muestra.png](09-clientes-muestra.png) | Diez filas de `DimCliente`, nombres concatenados y claves generadas | Es una muestra, no una comparación completa de las 59 filas |
| [10-clientes-conteos.png](10-clientes-conteos.png) | 59 filas, 59 CustomerId distintos y 59 ClienteKey distintas | No verifica por sí sola todos los valores de cada cliente |
| [11-clientes-estados-sin-dato.png](11-clientes-estados-sin-dato.png) | 29 filas con Estado = Sin dato | Es un control agregado |
| [12-ejecucion-estructura-workbench.txt](12-ejecucion-estructura-workbench.txt) | Ejecución sin errores de creación y verificación; cuatro tablas, 28 columnas, 15 restricciones y tres relaciones | Action Output informa filas devueltas, no los valores de cada resultado |

| [13-historial-ejecuciones-clientes.png](13-historial-ejecuciones-clientes.png) | Primera ejecución Succeeded y segunda Failed, con horarios y duraciones | No muestra la causa de la segunda falla ni costos finales |

Los resultados SQL de las capturas 10 y 11 coinciden con los controles esperados del CSV. Por tanto se verifica la primera carga de clientes con esos controles; no se afirma que todo el DW esté terminado.

No se incluyeron capturas de valores de contraseñas ni del contenido de secretos. Las capturas sí contienen identificadores de infraestructura y datos de ejemplo de Chinook.
