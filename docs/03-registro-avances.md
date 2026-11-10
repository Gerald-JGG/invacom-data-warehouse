# 03 — Registro de avances

Registrar únicamente trabajo realizado. Las fechas corresponden al día real de trabajo; este archivo no sustituye el historial de Git ni el tablero.

## 7 de noviembre de 2026 — Preparación inicial

### Resultado

- Se inicializó el repositorio Git local con la identidad ya configurada en el entorno.
- Se versionó el enunciado original y se creó una guía de inicio.
- Se configuraron exclusiones para credenciales, archivos temporales y datos o respaldos locales.
- Se documentaron los requisitos, entregables y pesos de evaluación del enunciado.
- Se separaron los requisitos confirmados por el documento de los objetivos y tareas propuestos.
- Se preparó una consulta sobre la base asignada y la ambigüedad de la herramienta ETL.
- Se preparó el plan de la primera semana con dependencias y criterios de cierre.

### Validación

- Requisitos y pesos contrastados con el enunciado.
- Pesos de la rúbrica: 100 % en total.
- Cambios agrupados en commits por tema; revisión de diferencias y espacios con Git.
- Enlaces relativos de la documentación comprobados al cerrar esta preparación.

### Pendientes

- Obtener la base asignada y confirmar la herramienta ETL.
- Confirmar integrantes, roles, fecha de entrega y calendario.
- Crear y compartir el repositorio remoto y el tablero Kanban.
- Analizar los datos para definir necesidades, objetivos medibles y modelo dimensional.

No se han enviado mensajes al profesor, creado servicios remotos ni ejecutado procesos ETL. La implementación aún no ha comenzado.

### Consultar evidencia en Git

```powershell
git log --oneline --reverse
git show --stat <identificador-del-commit>
```

Los commits iniciales pertenecen a una única jornada. Los avances de semanas posteriores se registrarán cuando ocurran.

## 7 de noviembre de 2026 — Preparación para recibir la fuente

- Se comprobó que los tres commits iniciales existen y que el repositorio estaba limpio antes de continuar.
- Se agregó una ficha para registrar la asignación, la herramienta ETL, la recepción y la apertura real de la fuente.
- Se enlazó la ficha desde la guía y el plan inicial.
- Se mantuvieron T06 y T07 pendientes: aún no hay evidencia de recepción ni de apertura de la base.
- Se verificaron los enlaces locales y las diferencias de Git antes del commit.

## 8 de noviembre de 2026 — Modelo dimensional de ventas

- El usuario confirmó Chinook como fuente asignada y Google Cloud Data Fusion como herramienta ETL.
- Se leyeron los 11 CSV locales y se comprobaron las relaciones necesarias para la estrella de ventas.
- Se conciliaron los totales de las 412 facturas con sus 2.240 detalles usando aritmética decimal; no hubo diferencias.
- Se preparó una propuesta con `FactVenta`, `DimFecha`, `DimCliente` y `DimCancion`, y se documentaron la granularidad, las claves, las medidas y el mapeo fuente-destino.
- Se generaron un diagrama editable `.drawio`, un SVG y un PNG; se inspeccionó visualmente la imagen y se verificó la estructura XML del archivo editable.
- Se actualizaron el README, las confirmaciones de requisitos y la ficha de recepción. La propuesta aún requiere revisión del equipo; el DW, el ETL y Excel no se han implementado.
- Por instrucción del usuario, este avance se reúne en un único commit: documentación, roles, propuesta del modelo, diagrama, CSV de Chinook y enunciados organizados en `docs/proyectos/`. Se mantienen los originales y el diagrama sin modificaciones. El segundo enunciado queda pendiente de análisis.

## 9 de noviembre de 2026 — Estructura física del DW en MySQL

- El usuario comunicó autorización del profesor para usar AWS como alternativa a Google Cloud y confirmó la creación de RDS MySQL 8.4.11, la conexión desde Workbench y la existencia de `invacom_dw`.
- Se prepararon scripts para crear las cuatro tablas del modelo y consultar columnas, claves, relaciones y conteos.
- Se documentaron la ejecución, las reglas para la futura carga Glue y los límites de repetir `CREATE TABLE IF NOT EXISTS`.
- El diagrama se conservó sin cambios. No se accedió al RDS desde Codex: posteriormente el equipo ejecutó los scripts en Workbench y aportó el registro de ejecución sin errores, preservado en las evidencias de esta jornada.

## 9 de noviembre de 2026 — Infraestructura AWS y primera carga de clientes

- Se configuró RDS MySQL, se ejecutaron la creación y verificación del DW y se registró evidencia de cuatro tablas, 28 columnas, 15 restricciones y tres relaciones.
- Se creó el bucket privado de S3 y el usuario confirmó subida de los 11 CSV a `raw/`.
- Se preparó `AWSGlueServiceRole`, se diagnosticaron denegaciones con CloudTrail y se acotaron los permisos necesarios para crear y configurar el secreto de la conexión.
- Se configuraron endpoints privados de STS y Secrets Manager, acceso S3 por Gateway y una regla interna TCP del security group.
- Se creó correctamente `invacom-mysql-connection`, se creó `invacom_catalog` y el crawler registró las cuatro tablas del DW.
- Se guardó e inició `invacom-load-dimcliente`, flujo S3 → Spark SQL → MySQL, con dos workers G.1X, cero reintentos y diez minutos de timeout.
- Las capturas SQL finales comprueban 59 clientes, 59 CustomerId distintos, 59 ClienteKey distintas y 29 estados Sin dato. Se revisó una muestra de diez filas con nombres completos y caracteres internacionales.
- Se conservaron 12 capturas y un registro SQL sin modificar, con manifiesto SHA-256 e índice. El historial confirma la primera ejecución Succeeded y una segunda Failed; la causa de esta última queda pendiente de revisar en View details.
- Se preservaron la transformación Spark SQL y las consultas de validación en archivos propios, y se documentaron infraestructura, fallos y soluciones. No se exportó aún el PySpark/configuración nativa del job.
- Se preparó un registro de avance para el Scrum Master sin inventar planificación, fechas de sprints pasados ni responsables de acciones no confirmados.

Documentación ampliada: [infraestructura AWS](07-infraestructura-aws.md), [ETL de clientes](08-etl-dimcliente.md), [evidencias](evidencias/2026-11-09/README.md) y [avance para sprint](sprints/avance-2026-11-09.md).

Pendientes: dimensiones de fecha y canción, hechos, recarga sin duplicados, controles de ventas, Excel, documento APA 7, revisión/cierre de sprint y sustentación. Esta actualización documental no modifica recursos de AWS, no vuelve a ejecutar el ETL y no modifica el diagrama.
