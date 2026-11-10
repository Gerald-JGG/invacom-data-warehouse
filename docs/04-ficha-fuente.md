# 04 — Recepción de la base de datos

Estado: fuente recibida el 8 de noviembre y apertura local verificada. Actualización del 09/11/2026: el usuario confirmó subida de los 11 CSV a S3 y se comprobó la primera carga de clientes en MySQL; las otras dimensiones y los hechos siguen pendientes. No se restauró una base transaccional completa.

Esta ficha acompaña las tareas T06 y T07 del [plan inicial](02-plan-inicial.md). Registra la confirmación comunicada por el usuario y lo observado al abrir la fuente localmente.

## 1. Confirmación de la asignación

| Dato | Información confirmada |
| --- | --- |
| Nombre de la base asignada | `chinook_digital_store` |
| Persona que confirmó la asignación | Usuario, quien comunicó la asignación del profesor en el chat |
| Fecha y referencia de la respuesta | 08/11/2026, mensaje del usuario con captura y archivos locales |
| Canal o ubicación de descarga | Pendiente |
| Herramienta ETL asignada o autorizada | Data Fusion inicialmente; AWS autorizado después según el usuario. Primera carga implementada con AWS Glue |
| Motor de la base y versión, si se conocen | Entrega en CSV; destino RDS MySQL 8.4.11 |
| Restricciones indicadas por el profesor | Pendiente |

No incluir contraseñas, tokens ni enlaces con credenciales. Referenciar la respuesta con fecha y canal; no es necesario copiar conversaciones personales completas.

## 2. Recepción local

Completar cuando se disponga del archivo o del acceso.

| Dato | Resultado observado |
| --- | --- |
| Fecha de recepción | 08/11/2026 |
| Nombre y extensión del archivo, si aplica | 11 archivos `.csv`, desde `Album.csv` hasta `Track.csv` |
| Ruta local del archivo, si aplica | `chinook_digital_store/`, ruta relativa a la raíz del proyecto |
| Tamaño del archivo, si aplica | 419.180 bytes en total |
| Forma de acceso: archivo o conexión | Archivos CSV locales |
| Responsable de comprobar la apertura | Codex, durante la preparación del modelo solicitado por el usuario |
| Resultado de la apertura o restauración | Los 11 CSV se leyeron con `csv.DictReader`, UTF-8 con soporte BOM; 15.607 filas de datos en total |
| Error y solución, si aplica | Sin errores en la lectura local. La configuración de nube y la primera carga están documentadas en los capítulos 07 y 08 |

Los originales recibidos se mantienen en `chinook_digital_store/`, sin modificarlos, y se incorporan al repositorio por instrucción del usuario para compartir el avance con el equipo. Para futuras entregas se propuso `data/raw/`, directorio excluido de Git. Para una conexión, guardar las credenciales fuera de la documentación versionada.

## 3. Secuencia para completar el primer paso

1. Solicitar o localizar la confirmación oficial de la base y herramienta ETL.
2. Registrar la confirmación en la sección 1 y actualizar P01–P03 de [requisitos](01-requisitos.md) solo cuando corresponda.
3. Obtener el archivo o acceso y completar la sección 2.
4. Verificar que la fuente abre con la herramienta correspondiente. Registrar el procedimiento real y su resultado.
5. Revisar `git status` para comprobar que los datos y credenciales no se incluirán en el commit.
6. Versionar la ficha y la actualización de requisitos en un mismo commit sobre la recepción de la fuente.

Mensaje de commit sugerido para cuando ocurra esa recepción: `docs: registrar fuente asignada y verificar acceso`.

## Cuándo queda terminado

- [x] La asignación está confirmada y tiene una referencia verificable en el mensaje del usuario.
- [x] La herramienta ETL está confirmada por el usuario.
- [x] La fuente está disponible localmente.
- [x] La apertura de los CSV se ejecutó y quedó documentada.

El [modelo propuesto](05-modelo-dimensional.md) registra las relaciones comprobadas y los controles iniciales. Quedan pendientes el diccionario completo de campos y el perfilado de calidad completo; abrir los CSV no equivale a cargar el DW.
