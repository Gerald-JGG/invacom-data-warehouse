# 06 — Crear la estructura del DW en MySQL

Fecha: 9 de noviembre de 2026.

## Estado y decisiones

El equipo creó la instancia `invacom-dw` en Amazon RDS con MySQL 8.4.11 y confirmó desde MySQL Workbench que la conexión funciona y que existe la base `invacom_dw`. El usuario ejecutó los dos scripts y proporcionó el [registro de Action Output](evidencias/2026-11-09/12-ejecucion-estructura-workbench.txt): creación sin errores de las cuatro tablas, 28 columnas, 15 restricciones y tres relaciones. La ejecución se realizó en Workbench por el equipo, no desde una conexión remota de Codex.

El profesor permitió usar AWS, según lo comunicado por el usuario. La [primera carga con AWS Glue](08-etl-dimcliente.md) ya tiene controles de resultados comprobados en MySQL. La documentación inicial de Data Fusion se conserva como antecedente; el diagrama y su granularidad se mantienen sin cambios.

## Ejecutar en Workbench

1. Abrir la conexión **Invacom DW** que pasó la prueba.
2. Usar **File → Open SQL Script** y seleccionar [01_crear_dw_mysql.sql](../sql/01_crear_dw_mysql.sql).
3. Ejecutar el archivo completo con el botón del rayo para todas las sentencias. Si hay texto seleccionado, quitar la selección antes de ejecutarlo.
4. Revisar **Action Output**: cada creación debe terminar sin errores. Si hay un error, detenerse y conservar el mensaje completo para corregirlo.
5. Abrir y ejecutar [02_verificar_estructura_mysql.sql](../sql/02_verificar_estructura_mysql.sql).
6. Revisar las cuatro tablas, columnas, restricciones y tres relaciones. En esta primera creación los cuatro conteos deben ser cero.
7. Actualizar **Schemas** con el botón de refrescar; desplegar `invacom_dw → Tables`.

Si se ejecutan directamente desde otra computadora, primero obtener los archivos del repositorio o copiarlos por el canal de trabajo acordado. No crear otra instancia RDS para ejecutar estos scripts.

## Qué crea el script

| Tabla | Función y claves |
| --- | --- |
| `DimFecha` | Fecha, año, trimestre, mes y día. Clave de calendario AAAAMMDD y fecha única |
| `DimCliente` | Cliente y ubicación de residencia. Clave sustituta automática y `CustomerId` único |
| `DimCancion` | Canción, álbum, artista, género, tipo de medio y duración. Clave sustituta automática y `TrackId` único |
| `FactVenta` | Una fila por detalle de factura; `InvoiceLineId` único y referencias obligatorias a las dimensiones |

Todas las tablas usan InnoDB, claves foráneas activas y UTF-8 de cuatro bytes (`utf8mb4`) para conservar nombres internacionales. Los importes usan `DECIMAL`, sin redondeos binarios de `FLOAT`.

Los tipos `TEXT` del diagrama lógico se concretan como `VARCHAR` con espacio suficiente para los CSV recibidos. No se modifica el diagrama por este ajuste físico. Se verificaron las longitudes máximas actuales: canción 123 caracteres, álbum 95, artista 85, país 14 y ciudad 19; todos caben en los tamaños elegidos.

## Reglas para la futura carga Glue

- Cargar dimensiones antes que hechos. MySQL genera `ClienteKey` y `CancionKey`; resolver sus valores reales con `CustomerId` y `TrackId` antes de cargar `FactVenta`.
- Construir `FechaKey`, `Anio`, `Trimestre`, `Mes` y `Dia` desde la misma fecha. Un `CHECK` verifica su consistencia.
- Normalizar los estados vacíos como `Sin dato` en el ETL. El valor predeterminado solo aplica cuando se omite la columna; no convierte automáticamente cadenas vacías ni `NULL` explícitos.
- Calcular `ImporteVenta = Cantidad × PrecioUnitario` usando el precio de `InvoiceLine`. El `CHECK` rechaza importes inconsistentes.
- El alcance actual son ventas con cantidad positiva y precio no negativo. Devoluciones o cantidades negativas requerirían revisar el modelo antes de cargarlas.
- La clave del detalle evita duplicados, pero un `INSERT` repetido falla: el ETL aún debe implementar la estrategia de actualización por clave. No considerar resuelta la recarga solo por tener una clave primaria.
- No eliminar ni recrear dimensiones para recargarlas si ya hay hechos que dependen de sus claves. No desactivar claves foráneas para forzar una carga.

## Repetición y límites

El archivo de creación no contiene `DROP`, `TRUNCATE`, borrados ni cargas de datos. Usa `CREATE TABLE IF NOT EXISTS`: ejecutarlo de nuevo conserva las tablas y sus datos, pero no compara ni corrige tablas existentes. Una advertencia de tabla existente no demuestra que la estructura coincida; revisar con el segundo script y, si hace falta, `SHOW CREATE TABLE`.

MySQL confirma cambios DDL de forma implícita: no se depende de `ROLLBACK` para deshacer la creación de tablas. Si una sentencia falla, pueden quedar creadas las anteriores. Corregir y verificar antes de continuar.

Codex no dispone en esta sesión de una conexión autenticada al RDS ni de un servidor MySQL local activo. La ejecución real de los scripts está acreditada por el registro proporcionado por el equipo; no se realizaron pruebas de inserciones inválidas para cada restricción. `DimCliente` ya contiene 59 clientes y pasó los controles agregados documentados. Las otras dimensiones, los hechos y Excel siguen pendientes de carga o comprobación; no exigir cero filas en clientes al repetir el archivo de verificación.

## Evidencia que debe registrar el equipo

- Fecha e integrante que ejecutó los scripts.
- Resultado de las consultas de estructura y conteos.
- Mensajes de error, si los hubo, y su solución.
- Confirmación de que existen las cuatro tablas y las tres relaciones.

Las credenciales se guardan en el administrador de contraseñas o almacén local correspondiente; no se incluyen en SQL, capturas públicas ni Git.

## Referencias técnicas

- [CREATE TABLE en MySQL 8.4](https://dev.mysql.com/doc/refman/8.4/en/create-table.html).
- [Claves foráneas](https://dev.mysql.com/doc/refman/8.4/en/create-table-foreign-keys.html).
- [Restricciones CHECK](https://dev.mysql.com/doc/refman/8.4/en/create-table-check-constraints.html).
