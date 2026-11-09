# 02 — Plan de la primera semana

Fecha de preparación: 7 de noviembre de 2026.

Estado: propuesta para revisión del equipo. Las fechas de inicio y cierre del primer sprint se acordarán al confirmar integrantes y calendario del curso.

## Meta

Organizar el trabajo, obtener acceso a la base asignada y conocer su estructura para formular preguntas de negocio. El incremento esperado es documentación verificable de la fuente y de los requisitos; todavía no se exige un DW completo.

## Organización del equipo

Asignación registrada el 8 de noviembre de 2026 por indicación de Gerald. Coordinación y Scrum Master fueron definidos por el usuario; los otros frentes son provisionales y pueden redistribuirse con el equipo.

| Integrante | Rol o frente responsable | Responsabilidades |
| --- | --- | --- |
| Gerald Josue Gonzalez Granados | Coordinador del equipo | Centralizar consultas con el profesor, dar seguimiento a los entregables y coordinar la integración final |
| Jose Andres Miranda Arias | Scrum Master | Facilitar la planificación y revisión, mantener el tablero actualizado con el equipo y registrar bloqueos y resultados del sprint |
| Jose Felipe Carrera Araya | Datos y modelado (provisional) | Analizar Chinook, documentar calidad de datos y preparar el modelo dimensional y los scripts del DW |
| Elias Josue Salas Mendez | ETL y Google Cloud (provisional) | Preparar acceso y conexiones de Data Fusion, implementar pipelines y coordinar validaciones de carga |
| Rachel Barquero Varela | Informes y documentación (provisional) | Conectar Excel al DW, preparar tablas dinámicas e integrar el documento APA 7 y la presentación |

Cada responsable coordina su frente con apoyo y revisión de otro integrante. Todos deben aportar técnicamente, registrar sus propios commits y comprender la solución. Estos roles no acreditan tareas realizadas ni sustituyen la asignación concreta de tareas en el sprint.

El enunciado indica un máximo de cuatro integrantes. Se registra la composición de cinco comunicada por el usuario; no se ha documentado aún la autorización del profesor para ese tamaño de grupo.

| Dato | Valor |
| --- | --- |
| Integrantes | Cinco, registrados en la tabla anterior; autorización del tamaño del grupo pendiente de documentar |
| Coordinador ante el profesor | Gerald Josue Gonzalez Granados, designado por el usuario; nombramiento ante el profesor pendiente de confirmar |
| Scrum Master | Jose Andres Miranda Arias, designado por el usuario; puede rotar en sprints posteriores |
| Product Owner | Profesor, según el enunciado |
| Repositorio remoto | https://github.com/Gerald-JGG/invacom-data-warehouse |
| Tablero Kanban compartido | Pendiente |
| Día de planificación y revisión | Por acordar |
| Inicio y cierre del sprint | Por acordar |

## Tareas para llevar al tablero

Las prioridades y criterios de cierre son propuestas. Los responsables se asignarán con el equipo; no se atribuye trabajo a personas que aún no han participado.

| ID | Prioridad | Tarea | Dependencia | Criterio de cierre | Estado |
| --- | --- | --- | --- | --- | --- |
| T01 | Alta | Preparar repositorio local y guía de inicio | Ninguna | Enunciado, README y configuración Git versionados | Hecho |
| T02 | Alta | Registrar requisitos y dudas del enunciado | Ninguna | Requisitos y pendientes documentados con referencia a la fuente | Hecho |
| T03 | Alta | Confirmar integrantes y roles | Respuesta del equipo y profesor | Integrantes, coordinador y Scrum Master registrados | En proceso: integrantes y distribución registrados; falta confirmar ante el profesor y revisar los frentes provisionales con el equipo |
| T04 | Alta | Crear remoto y compartir acceso al equipo | Cuenta y espacio acordados | Enlace registrado y acceso de integrantes comprobado | En proceso: remoto creado y conectado; acceso del equipo por comprobar |
| T05 | Alta | Crear tablero Kanban compartido | Plataforma acordada | Tareas cargadas en Pendiente, En proceso, En revisión y Hecho | Pendiente |
| T06 | Alta | Consultar base asignada y herramienta ETL | Respuesta del profesor | Fuente, forma de acceso y herramienta confirmadas por escrito | Hecho: usuario confirmó Chinook y Data Fusion |
| T07 | Alta | Obtener y abrir la fuente en el entorno local | T06 | Formato y, si aplica, motor registrados; apertura verificada | Hecho: 11 CSV abiertos localmente; no hubo restauración en un motor |
| T08 | Alta | Inventariar tablas, claves y relaciones | T07 | Diccionario inicial con campos, tipos y conteos | En proceso: conteos y relaciones iniciales revisados; falta diccionario completo |
| T09 | Alta | Formular preguntas de negocio y objetivos medibles | T08 y validación del profesor | Preguntas factibles, medidas y criterios de éxito documentados | En proceso: tres preguntas propuestas; falta validación y objetivos medibles |
| T10 | Media | Realizar perfilado inicial de calidad | T08 | Nulos, duplicados e inconsistencias cuantificados y reglas propuestas | Pendiente |
| T11 | Alta | Revisar el incremento semanal | Calendario acordado | Revisión registrada, commits disponibles en remoto y tablero actualizado | Pendiente |

Este archivo sirve para preparar las tareas. No sustituye el tablero visual compartido exigido por el enunciado.

## Lo primero que debe hacer el equipo ahora

Al preparar el plan se propuso enviar la consulta de [requisitos](01-requisitos.md#primera-consulta-sugerida-al-profesor). Actualización del 08/11/2026: el usuario ya confirmó la base y la herramienta. Ahora toca revisar el modelo propuesto con el equipo y resolver el acceso a Google Cloud, el destino del DW, el tablero y los roles.

La confirmación y la comprobación de lectura local están registradas en la [ficha de recepción de la base](04-ficha-fuente.md). No se ha implementado aún la carga en nube.

## Rutina semanal

1. Planificación: acordar tareas, responsables y un incremento alcanzable para la semana.
2. Actualización asíncrona diaria: cada integrante indica qué hizo, qué hará y sus bloqueos.
3. Revisión: mostrar resultados y commits, actualizar el tablero y registrar las decisiones.

Una tarea pasa a Hecho cuando cumple su criterio de cierre y su resultado está revisado y versionado cuando corresponda. No registrar consultas como respondidas ni conexiones como verificadas sin evidencia.

## Registro breve para cada revisión

```text
Fecha:
Participantes:
Meta de la semana:
Tareas terminadas y evidencia (archivo, commit o enlace):
Pendientes y bloqueos:
Decisiones y quién las confirmó:
Próxima meta y responsables:
```

## Etapas posteriores propuestas

Después de esta primera semana se planificarán el modelo dimensional, la primera carga ETL, las validaciones, la conexión de Excel y la sustentación. Su calendario dependerá del plazo oficial y de lo encontrado en la fuente.
