# 01 — Requisitos y definición inicial

Fecha: 7 de noviembre de 2026.

Fuente: `Proyecto # 1 Mineria de Datos.pdf`, páginas 1–7. Las propuestas de este documento se identifican como tales; no representan acuerdos con el profesor ni necesidades verificadas de usuarios.

## Problema indicado en el enunciado

Invacom Inc S.A. necesita implementar un Data Warehouse. El equipo debe investigar los fundamentos de ETL y DW y aplicarlos a una base de datos que se proporcionará para el ejercicio.

El dominio de la fuente, su estructura y los problemas concretos de los usuarios aún no se conocen. Por eso todavía no se fijan indicadores, tablas de hechos ni dimensiones.

## Objetivo general propuesto

Implementar un Data Warehouse para Invacom Inc S.A. a partir de la base de datos asignada, mediante un proceso ETL que prepare los datos para responder necesidades de análisis validadas con el profesor y presentar los resultados en tablas dinámicas de Excel conectadas al DW.

Este objetivo es un borrador para revisión del equipo. Los objetivos medibles se completarán al conocer la fuente y las preguntas de negocio.

## Requisitos y evidencia de cumplimiento

| ID | Requisito | Evidencia esperada |
| --- | --- | --- |
| R01 | Definir necesidades del negocio y de los usuarios | Preguntas de análisis, uso esperado y validación con el profesor, que actúa como Product Owner |
| R02 | Definir objetivos claros y medibles del DW | Objetivos con indicador, criterio de éxito y consulta o informe que permita verificarlo |
| R03 | Identificar las fuentes | Inventario de tablas, campos, claves y relaciones de la base asignada |
| R04 | Evaluar calidad de los datos | Resultados de análisis de nulos, duplicados e inconsistencias y reglas de tratamiento |
| R05 | Diseñar un modelo dimensional estrella o copo de nieve | Diagrama y explicación de dimensiones, hechos, medidas y granularidad |
| R06 | Diseñar e implementar extracción, transformación y carga | Código o proyecto ETL, instrucciones de ejecución y evidencias de limpieza y carga |
| R07 | Crear la infraestructura del DW | Scripts o configuración reproducible y verificación de las tablas cargadas |
| R08 | Presentar análisis en Excel conectado al DW | Tablas dinámicas que respondan las preguntas de negocio y conexión demostrable |
| R09 | Utilizar Git y un repositorio remoto | Enlace, avances semanales y commits de todos los integrantes |
| R10 | Trabajar con Scrum adaptado y tablero Kanban | Sprints semanales, Scrum Master, tareas, responsables y evidencia de revisión |
| R11 | Entregar un único documento final en APA 7 | Documento con las secciones exigidas, revisado por el equipo |
| R12 | Sustentar presencialmente y participar en la dinámica de jurado | Demostración y defensa de las decisiones técnicas y de negocio |

## Documento final requerido

- Portada.
- Introducción.
- Enlace al repositorio Git con código y evidencia de avances semanales.
- Enunciado del problema.
- Objetivo general.
- Objetivos específicos.
- Descripción de la solución.
- Diagrama del modelo dimensional.
- Conclusión.
- Bibliografía.

## Evaluación que orienta las prioridades

| Criterio | Peso |
| --- | --- |
| Diseño y modelado dimensional | 20 % |
| Desarrollo ETL | 35 % |
| Implementación DW y visualización | 10 % |
| Documentación APA 7 | 5 % |
| Git y trabajo semanal | 5 % |
| Gestión ágil | 5 % |
| Sustentación y defensa | 20 % |
| Total | 100 % |

El enunciado establece grupos de máximo cuatro personas y evaluación del aporte individual. Cada integrante debe comprender la solución y participar en la sustentación presencial.

## Información pendiente de confirmar

| ID | Pregunta | Motivo | Estado |
| --- | --- | --- | --- |
| P01 | ¿Cuál es la base de datos asignada y cómo se obtiene? | Es necesaria para analizar la fuente y diseñar el modelo | Pendiente |
| P02 | ¿Qué herramienta ETL corresponde al grupo? | La página 4 indica elección; la rúbrica de la página 6 menciona asignación por sorteo | Pendiente |
| P03 | ¿Qué motor y versión usa la fuente? ¿Hay restricciones para el motor del DW? | Permite preparar conexiones e infraestructura compatibles | Pendiente |
| P04 | ¿Quiénes integran el equipo y quién será coordinador y Scrum Master? | Permite asignar responsabilidades reales | Pendiente |
| P05 | ¿Cuál es la fecha de entrega y cuántas revisiones semanales habrá? | Permite establecer el calendario de sprints | Pendiente |
| P06 | ¿Qué necesidades de análisis debe priorizar Invacom? | Evita inventar requisitos de negocio | Pendiente |

## Primera consulta sugerida al profesor

> Profesor, estamos iniciando el proyecto de Minería de Datos. ¿Nos puede confirmar cuál base de datos le corresponde al grupo y dónde obtenerla? También quisiéramos confirmar si la herramienta ETL se elige o se asigna por sorteo y cuál nos corresponde.

Texto preparado para que el equipo lo revise y envíe por su canal habitual. No se ha enviado desde este repositorio.

## Criterio de cierre de la definición inicial

Esta etapa quedará lista cuando el equipo conozca la fuente asignada, confirme su herramienta ETL y documente las necesidades de análisis y objetivos medibles. Este documento todavía registra un inicio y sus pendientes, no una validación del negocio.
