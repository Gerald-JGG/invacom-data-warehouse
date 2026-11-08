# 02 — Plan de la primera semana

Fecha de preparación: 7 de noviembre de 2026.

Estado: propuesta para revisión del equipo. Las fechas de inicio y cierre del primer sprint se acordarán al confirmar integrantes y calendario del curso.

## Meta

Organizar el trabajo, obtener acceso a la base asignada y conocer su estructura para formular preguntas de negocio. El incremento esperado es documentación verificable de la fuente y de los requisitos; todavía no se exige un DW completo.

## Organización pendiente

| Dato | Valor |
| --- | --- |
| Integrantes (máximo cuatro) | Por confirmar |
| Coordinador ante el profesor | Por confirmar con el profesor |
| Scrum Master | Por acordar con el equipo; puede rotar |
| Product Owner | Profesor, según el enunciado |
| Repositorio remoto | Pendiente |
| Tablero Kanban compartido | Pendiente |
| Día de planificación y revisión | Por acordar |
| Inicio y cierre del sprint | Por acordar |

## Tareas para llevar al tablero

Las prioridades y criterios de cierre son propuestas. Los responsables se asignarán con el equipo; no se atribuye trabajo a personas que aún no han participado.

| ID | Prioridad | Tarea | Dependencia | Criterio de cierre | Estado |
| --- | --- | --- | --- | --- | --- |
| T01 | Alta | Preparar repositorio local y guía de inicio | Ninguna | Enunciado, README y configuración Git versionados | Hecho |
| T02 | Alta | Registrar requisitos y dudas del enunciado | Ninguna | Requisitos y pendientes documentados con referencia a la fuente | Hecho |
| T03 | Alta | Confirmar integrantes y roles | Respuesta del equipo y profesor | Integrantes, coordinador y Scrum Master registrados | Pendiente |
| T04 | Alta | Crear remoto y compartir acceso al equipo | Cuenta y espacio acordados | Enlace registrado y acceso de integrantes comprobado | Pendiente |
| T05 | Alta | Crear tablero Kanban compartido | Plataforma acordada | Tareas cargadas en Pendiente, En proceso, En revisión y Hecho | Pendiente |
| T06 | Alta | Consultar base asignada y herramienta ETL | Respuesta del profesor | Fuente, forma de acceso y herramienta confirmadas por escrito | Pendiente |
| T07 | Alta | Obtener y abrir la fuente en el entorno local | T06 | Motor y versión registrados; conexión o restauración verificada | Pendiente |
| T08 | Alta | Inventariar tablas, claves y relaciones | T07 | Diccionario inicial con campos, tipos y conteos | Pendiente |
| T09 | Alta | Formular preguntas de negocio y objetivos medibles | T08 y validación del profesor | Preguntas factibles, medidas y criterios de éxito documentados | Pendiente |
| T10 | Media | Realizar perfilado inicial de calidad | T08 | Nulos, duplicados e inconsistencias cuantificados y reglas propuestas | Pendiente |
| T11 | Alta | Revisar el incremento semanal | Calendario acordado | Revisión registrada, commits disponibles en remoto y tablero actualizado | Pendiente |

Este archivo sirve para preparar las tareas. No sustituye el tablero visual compartido exigido por el enunciado.

## Lo primero que debe hacer el equipo ahora

Enviar la consulta preparada en [requisitos](01-requisitos.md#primera-consulta-sugerida-al-profesor) y confirmar integrantes. Mientras llega la respuesta, puede acordar el remoto, el tablero y los roles.

Registrar la respuesta y la comprobación de acceso en la [ficha de recepción de la base](04-ficha-fuente.md). T06 y T07 siguen pendientes hasta contar con esa evidencia.

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
