# Proyecto 1 — Minería de Datos

Proyecto académico de ISW-911 para diseñar e implementar un Data Warehouse (DW) para Invacom Inc S.A., con un proceso de extracción, transformación y carga (ETL) y análisis mediante tablas dinámicas de Excel conectadas al DW.

## Estado actual

Inicio del proyecto: 7 de noviembre de 2026.

Actualización del 8 de noviembre de 2026: se recibió la fuente `chinook_digital_store` en 11 archivos CSV y el usuario confirmó Google Cloud Data Fusion como herramienta asignada. Se preparó una propuesta de modelo estrella de ventas con diagrama editable. El acceso a Google Cloud, el motor de destino y la implementación del DW/ETL siguen pendientes.

## Por dónde empezar

1. Revisar los [requisitos y dudas pendientes](docs/01-requisitos.md).
2. Completar la [planificación de la primera semana](docs/02-plan-inicial.md) con el equipo.
3. Revisar con el equipo el [modelo dimensional propuesto](docs/05-modelo-dimensional.md).
4. Resolver el acceso a Google Cloud y confirmar el destino del DW antes de implementar el ETL.

## Documentación

- `docs/proyectos/Proyecto # 1 Mineria de Datos.pdf`: enunciado original; fuente de los requisitos.
- `docs/proyectos/Proyecto # 2 Minera de Datos.pdf`: segundo enunciado recibido, conservado como referencia y pendiente de análisis.
- [Requisitos](docs/01-requisitos.md): alcance, entregables, criterios de aceptación y preguntas abiertas.
- [Plan inicial](docs/02-plan-inicial.md): tareas de la primera semana y seguimiento.
- [Registro de avances](docs/03-registro-avances.md): evidencia resumida del trabajo realizado.
- [Recepción de la base de datos](docs/04-ficha-fuente.md): ficha y pasos para confirmar la asignación y verificar el acceso.
- [Modelo dimensional de ventas](docs/05-modelo-dimensional.md): granularidad, claves, medidas, controles y diagrama editable.

Los documentos Markdown son material de trabajo para preparar el documento final en APA 7; no sustituyen esa entrega.

## Trabajo con Git

- Cada integrante debe realizar sus propios commits con su identidad real.
- Agrupar cada commit por un cambio coherente: documentación, modelo, ETL o validaciones.
- Usar mensajes descriptivos, por ejemplo: `docs: definir preguntas de negocio`.
- Registrar avances reales cada semana. Varios commits iniciales no equivalen a evidencia de varias semanas.
- Revisar `git status` y `git diff --staged` antes de confirmar cambios.
- No versionar contraseñas, archivos `.env`, respaldos de bases de datos ni datos fuente sin revisar su contenido y autorización de distribución.

Repositorio remoto: <https://github.com/Gerald-JGG/invacom-data-warehouse>. El tablero Kanban compartido sigue pendiente de configuración con el equipo. Los nuevos commits locales deben publicarse para que los demás integrantes los vean.
