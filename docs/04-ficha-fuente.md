# 04 — Recepción de la base de datos

Estado: pendiente de recibir y confirmar la fuente asignada.

Esta ficha acompaña las tareas T06 y T07 del [plan inicial](02-plan-inicial.md). Se completa con la respuesta del profesor y, después, con lo observado al abrir la fuente. No contiene resultados de un análisis todavía.

## 1. Confirmación de la asignación

| Dato | Información confirmada |
| --- | --- |
| Nombre de la base asignada | Pendiente |
| Persona que confirmó la asignación | Pendiente |
| Fecha y referencia de la respuesta | Pendiente |
| Canal o ubicación de descarga | Pendiente |
| Herramienta ETL asignada o autorizada | Pendiente |
| Motor de la base y versión, si se conocen | Pendiente |
| Restricciones indicadas por el profesor | Pendiente |

No incluir contraseñas, tokens ni enlaces con credenciales. Referenciar la respuesta con fecha y canal; no es necesario copiar conversaciones personales completas.

## 2. Recepción local

Completar cuando se disponga del archivo o del acceso.

| Dato | Resultado observado |
| --- | --- |
| Fecha de recepción | Pendiente |
| Nombre y extensión del archivo, si aplica | Pendiente |
| Ruta local del archivo, si aplica | Pendiente |
| Tamaño del archivo, si aplica | Pendiente |
| Forma de acceso: archivo o conexión | Pendiente |
| Responsable de comprobar la apertura | Pendiente |
| Resultado de la apertura o restauración | Sin ejecutar |
| Error y solución, si aplica | Sin evaluar |

Para una entrega en archivo, conservar el original en `data/raw/`, directorio excluido de Git. Para una conexión, guardar las credenciales fuera de la documentación versionada. La forma de abrir o restaurar se definirá después de conocer el formato y el motor.

## 3. Secuencia para completar el primer paso

1. Solicitar o localizar la confirmación oficial de la base y herramienta ETL.
2. Registrar la confirmación en la sección 1 y actualizar P01–P03 de [requisitos](01-requisitos.md) solo cuando corresponda.
3. Obtener el archivo o acceso y completar la sección 2.
4. Verificar que la fuente abre con la herramienta correspondiente. Registrar el procedimiento real y su resultado.
5. Revisar `git status` para comprobar que los datos y credenciales no se incluirán en el commit.
6. Versionar la ficha y la actualización de requisitos en un mismo commit sobre la recepción de la fuente.

Mensaje de commit sugerido para cuando ocurra esa recepción: `docs: registrar fuente asignada y verificar acceso`.

## Cuándo queda terminado

- [ ] La asignación está confirmada y tiene una referencia verificable.
- [ ] La herramienta ETL está confirmada.
- [ ] La fuente está disponible localmente o por conexión.
- [ ] La apertura o restauración se ejecutó y quedó documentada.

Después se continúa con T08: inventariar tablas, campos, claves, relaciones y conteos. Tener esta ficha preparada no significa que la fuente ya se recibió.
