# Proyecto 1 — Minería de Datos

Proyecto académico de ISW-911 para diseñar e implementar un Data Warehouse (DW) para Invacom Inc S.A., con un proceso de extracción, transformación y carga (ETL) y análisis mediante tablas dinámicas de Excel conectadas al DW.

## Estado actual

Inicio del proyecto: 7 de noviembre de 2026.

Actualización del 9 de noviembre de 2026: el DW tiene sus cuatro tablas creadas en Amazon RDS MySQL 8.4.11. Se configuraron S3, IAM, endpoints privados, conexión Glue y catálogo de tablas. La primera carga de `DimCliente` mediante AWS Glue se comprobó en MySQL: 59 clientes, 59 IDs y claves distintos, y 29 estados normalizados como `Sin dato`. Se conservan capturas y el registro SQL. Las cargas de fechas, canciones y ventas, la recarga sin duplicados y Excel siguen pendientes. El profesor permitió usar AWS como alternativa a Data Fusion, según lo comunicado por el usuario.

## Por dónde empezar

1. Revisar los [requisitos y dudas pendientes](docs/01-requisitos.md).
2. Completar la [planificación de la primera semana](docs/02-plan-inicial.md) con el equipo.
3. Revisar con el equipo el [modelo dimensional propuesto](docs/05-modelo-dimensional.md).
4. Consultar la [infraestructura AWS](docs/07-infraestructura-aws.md) y la [primera carga de clientes](docs/08-etl-dimcliente.md). Continuar con las dimensiones restantes y los hechos; no repetir la carga de clientes hasta implementar la recarga por clave.

## Documentación

- `docs/proyectos/Proyecto # 1 Mineria de Datos.pdf`: enunciado original; fuente de los requisitos.
- `docs/proyectos/Proyecto # 2 Minera de Datos.pdf`: segundo enunciado recibido, conservado como referencia y pendiente de análisis.
- [Requisitos](docs/01-requisitos.md): alcance, entregables, criterios de aceptación y preguntas abiertas.
- [Plan inicial](docs/02-plan-inicial.md): tareas de la primera semana y seguimiento.
- [Registro de avances](docs/03-registro-avances.md): evidencia resumida del trabajo realizado.
- [Recepción de la base de datos](docs/04-ficha-fuente.md): ficha y pasos para confirmar la asignación y verificar el acceso.
- [Modelo dimensional de ventas](docs/05-modelo-dimensional.md): granularidad, claves, medidas, controles y diagrama editable.
- [Creación del DW en MySQL](docs/06-crear-dw-mysql.md): ejecución en Workbench, restricciones y controles de estructura.
- [Infraestructura AWS](docs/07-infraestructura-aws.md): recursos, configuración, permisos y solución de bloqueos.
- [Diagrama de arquitectura AWS](docs/10-arquitectura-aws.md): flujo de datos, catálogo, permisos y red; disponible en draw.io, SVG y PNG.
- [Excel conectado al DW](docs/11-excel-clientes.md): importación de clientes, tabla dinámica y dashboard inicial. [Abrir el libro](excel/analisis-ventas-chinook.xlsx).
- [ETL de clientes](docs/08-etl-dimcliente.md): extracción, transformación, parámetros, resultados y límites de la primera carga.
- [Evidencias del 9 de noviembre](docs/evidencias/2026-11-09/README.md): capturas originales, registro SQL y manifiesto SHA-256.
- [Avance para el seguimiento del sprint](docs/sprints/avance-2026-11-09.md): trabajo realizado y pendientes para el Scrum Master.

## SQL disponible

- [Crear los destinos staging de los 11 CSV](sql/04_crear_staging_chinook_mysql.sql) y [validar sus conteos](sql/05_validar_staging_chinook_mysql.sql). Preparados, pendientes de ejecución; [instrucciones y mapeo](docs/09-staging-chinook.md).
- [Crear las tablas MySQL](sql/01_crear_dw_mysql.sql).
- [Consultar su estructura](sql/02_verificar_estructura_mysql.sql).
- [Validar la carga de clientes](sql/03_validar_dimcliente.sql).
- [Transformación Spark SQL de clientes](etl/sql/transformar_dimcliente.sql), para Glue; no ejecutar en Workbench.

Los documentos Markdown son material de trabajo para preparar el documento final en APA 7; no sustituyen esa entrega.

## Trabajo con Git

- Cada integrante debe realizar sus propios commits con su identidad real.
- Agrupar cada commit por un cambio coherente: documentación, modelo, ETL o validaciones.
- Usar mensajes descriptivos, por ejemplo: `docs: definir preguntas de negocio`.
- Registrar avances reales cada semana. Varios commits iniciales no equivalen a evidencia de varias semanas.
- Revisar `git status` y `git diff --staged` antes de confirmar cambios.
- No versionar contraseñas, archivos `.env`, respaldos de bases de datos ni datos fuente sin revisar su contenido y autorización de distribución.

Repositorio remoto: <https://github.com/Gerald-JGG/invacom-data-warehouse>. Se mostró la creación del GitHub Project `Invacom Data Warehouse` con vistas Product Backlog, Sprint Actual y Cronograma; faltan su enlace y la verificación de asignaciones, fechas y cierre de sprint. Los nuevos archivos documentales se mantienen locales hasta realizar el commit y publicación correspondientes.
