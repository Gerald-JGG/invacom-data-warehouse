# 14 — Recargas de los cuatro ETL visuales

Fecha de validacion: 12 de noviembre de 2026. El equipo opero la consola AWS y
Workbench; Codex preparo instrucciones, consultas y este registro. No se ejecuto
el ETL remotamente desde Codex.

## Comportamiento implementado

Cada job agrega un origen JDBC con los registros actuales del destino. Un nodo
Spark SQL `LEFT ANTI JOIN` compara las claves y envia al destino solamente las
filas que aun no existen. Se conserva el editor visual.

| Job | Clave de comparacion | Tabla JDBC existente | Consulta nueva |
| --- | --- | --- | --- |
| invacom-load-dimcliente | CustomerId | invacom_dw.DimCliente | [Filtrar clientes nuevos](../etl/sql/filtrar_clientes_nuevos.sql) |
| invacom-load-dimcancion | TrackId | invacom_dw.DimCancion | [Filtrar canciones nuevas](../etl/sql/filtrar_canciones_nuevas.sql) |
| invacom-load-dimFecha | FechaKey | invacom_dw.DimFecha | [Filtrar fechas nuevas](../etl/sql/filtrar_fechas_nuevas.sql) |
| invacom-load-dimVenta | InvoiceLineId | invacom_dw.FactVenta | [Filtrar ventas nuevas](../etl/sql/filtrar_ventas_nuevas.sql) |

Los origenes MySQL usan JDBC connection details y la conexion
`invacom-mysql-connection`. El destino conserva las tablas correspondientes de
`invacom_catalog`. En cada filtro, `origen` debe ser la transformacion preparada
y `existentes` la lectura de la tabla destino. El destino tiene como unico padre
el filtro nuevo, sin una segunda ruta directa desde la transformacion anterior.

### Fuentes y relaciones conservadas

- Clientes: Customer.csv -> transformar clientes -> filtro -> DimCliente.
- Canciones: Track, Album, Artist, Genre y MediaType CSV -> transformar cancion
  -> filtro -> DimCancion. Se conservan siete atributos, con NombreCancion.
- Fechas: Invoice.csv -> generacion del calendario continuo -> filtro -> DimFecha.
  El resultado incluye FechaKey, Fecha, Anio, Trimestre, Mes y Dia.
- Ventas: Invoice y InvoiceLine CSV mas DimCliente, DimCancion y DimFecha JDBC
  -> transformar ventas -> filtro -> FactVenta. La lectura adicional de
  FactVenta alimenta solamente el filtro final.

En Transformar ventas se conservaron los alias `facturas`, `detalles`, `clientes`,
`canciones` y `fechas`. Se corrigio un origen de fechas vacio/desconectado y la
seleccion accidental de Ventas existentes como padre de esa transformacion.

## Validacion de repeticion con el mismo origen

| Destino | Resultado despues de repetir | Evidencia |
| --- | --- | --- |
| DimCliente | 59 filas, 59 CustomerId, 59 ClienteKey, 29 estados Sin dato | Gerald confirmo que los resultados se mantuvieron tras Succeeded; captura del filtro y copia temporal de claves |
| DimCancion | 3503 filas, 3503 TrackId, 3503 CancionKey | Captura de conteos posterior a la recarga |
| DimFecha | 1817 filas, 1817 FechaKey, rango 2009-01-01 a 2013-12-22 | Gerald confirmo Succeeded y coincidencia de los resultados; sin captura final de esta recarga |
| FactVenta | 2240 filas, 2240 InvoiceLineId, 412 facturas, 2240 unidades, 2328.60 importe | Captura final de la consulta de control |

Los controles reproducibles estan en
[07_validar_recargas_dw_mysql.sql](../sql/07_validar_recargas_dw_mysql.sql).
Los conteos corresponden al dataset actual, no a constantes que el ETL deba imponer
cuando llegue informacion nueva. La comprobacion adicional de ventas sin dimension
esta preparada, pero no consta un resultado enviado por el equipo.

### Lectura de las capturas

Ver [evidencias del 12 de noviembre](evidencias/2026-11-12/README.md).
En canciones, Data preview mostro 196 filas aun despues de corregir los alias.
La vista previa compara muestras y no demuestra cuantas filas cargara la ejecucion
completa. La validacion se baso en la ejecucion y los conteos reales de MySQL.
En clientes el filtro mostro 0 filas en la vista previa.

## Alcance y limites

- Los cuatro filtros implementan **solo insercion de claves nuevas**. No actualizan
  atributos modificados de claves existentes, ni borran registros ausentes.
- El job adicional [recarga de clientes](13-recarga-dimcliente.md) permite insertar
  y actualizar por CustomerId conservando ClienteKey; es una alternativa para clientes.
- Ejecutar dimensiones antes que ventas cuando existan datos nuevos. Una venta sin
  dimension correspondiente puede quedar excluida por los joins de la transformacion.
- Conservar concurrencia maxima 1 y evitar dos jobs escribiendo al mismo destino
  simultaneamente. El anti join no es una transaccion atomica entre lectura y escritura;
  las claves UNIQUE/PK siguen siendo la ultima proteccion ante duplicados.
- `SELECT DISTINCT` elimina filas totalmente iguales, no resuelve atributos
  contradictorios para la misma clave. Los CSV actuales tienen claves unicas;
  un origen nuevo requiere validar tambien sus conflictos y registros invalidos.
- Se comprobo repetir el mismo origen. No se hizo una prueba controlada agregando
  clientes, canciones o ventas nuevas, ni modificando atributos existentes.

## Archivos pendientes de exportacion

Se preservaron las consultas nuevas exactas del filtro y las capturas disponibles.
No estan todavia las exportaciones `.py` finales de los cuatro jobs visuales.
El archivo `scripts-aws/invacom-load-dimcliente.py` es el respaldo anterior al
filtro y esta identificado como tal. No se debe presentarlo como version actual.
Descargar los scripts guardados en AWS y revisar su contenido antes de incorporarlos.
El documento Word preparado por otro integrante y el diagrama existente no se editaron.
