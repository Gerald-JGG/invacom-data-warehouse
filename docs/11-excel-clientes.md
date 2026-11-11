# 11 — Excel conectado al DW y dashboard de clientes

Fecha: 10 de noviembre de 2026.

## Resultado comprobado

El equipo configuró desde Excel una consulta MySQL a RDS y mostró **59 filas cargadas** en la consulta `ClientesDW`. Después creó una tabla dinámica por país, un gráfico dinámico de barras y un segmentador de país en Dashboard. El libro guardado está en [excel/analisis-ventas-chinook.xlsx](../excel/analisis-ventas-chinook.xlsx).

Al revisar la estructura interna del archivo guardado se comprobaron una conexión, una tabla de consulta, una tabla dinámica, un gráfico y un segmentador. Las hojas guardadas son `Analisis`, `Clientes por Pais`, `Dashboard`, `ClientesDW` y `DatosVentas`. No se modificó el archivo desde Codex después de las acciones del usuario en Excel.

## Conexión y consulta

El conector inicial mostró que faltaban componentes. El usuario instaló MySQL Connector/NET y completó la conexión con el endpoint de RDS, la base `invacom_dw` y autenticación Database. Las credenciales se introdujeron en el diálogo de Excel.

```sql
SELECT ClienteKey, CustomerId, NombreCompleto, Pais, Estado, Ciudad
FROM DimCliente
ORDER BY CustomerId;
```

El resultado se cargó como tabla en una hoja nueva, renombrada `ClientesDW`. El panel Consultas y conexiones mostró 59 filas. La documentación de referencia del proveedor está en [Microsoft Learn](https://learn.microsoft.com/en-us/power-query/connectors/mysql-database); la descarga oficial está en [MySQL Connector/NET](https://dev.mysql.com/downloads/connector/net/).

## Tabla dinámica y dashboard

- Filas: `Pais`.
- Valores: **recuento de CustomerId**, no suma de identificadores.
- Total general mostrado: **59**.
- Tabla ordenada de mayor a menor. Se observaron USA 13, Canada 8, France 5 y Brazil 5.
- Gráfico: barras horizontales, título Clientes por país, etiquetas de cantidades y países ordenados con los mayores arriba.
- Segmentador: Pais, agregado a la derecha del gráfico.

La hoja `Clientes por Pais` alimenta el gráfico de Dashboard y debe conservarse, aunque se oculte. `ClientesDW` conserva los datos importados. `DatosVentas` está preparada para el futuro análisis de FactVenta; no acredita que esas ventas ya estén importadas.

## Actualización y uso por otros integrantes

Agregar un cliente en un CSV no actualiza directamente el libro. Primero debe cargarse en `DimCliente` mediante un ETL que gestione recargas por clave. Después se actualiza la consulta de Excel y la tabla dinámica. No se ha comprobado todavía una inserción nueva y actualización de extremo a extremo.

El archivo conserva la consulta, conexión y datos guardados. Para actualizarlo desde otra computadora se necesitan el proveedor MySQL, credenciales válidas, la IP autorizada en el security group y RDS disponible. No se debe ampliar el acceso de entrada a todo Internet para compartir el libro.

No se detectaron campos de contraseña no vacíos ni `savePassword=true` en los XML del libro al prepararlo para Git. Esto no representa una auditoría completa de todas las credenciales del equipo. El libro incluye el endpoint del servidor y datos de ejemplo de Chinook. El instalador MSI es una dependencia local, no un archivo del proyecto versionado.

## Pendientes

1. Confirmar y validar las cargas de DimFecha, DimCancion y FactVenta.
2. Resolver y probar recargas sin duplicados conservando claves sustitutas.
3. Importar ventas a Excel y crear las tablas dinámicas de fecha, país, artista y género.
4. Mostrar ventas totales, unidades y recuento distinto de facturas. La moneda sigue sin confirmarse.
5. Comprobar actualización, filtros y conciliación con MySQL antes de la exposición.

Este avance de clientes no se presenta como un dashboard completo de ventas ni como prueba de las cargas todavía pendientes.
