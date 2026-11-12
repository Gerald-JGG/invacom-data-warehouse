# 13 — Recarga de clientes sin duplicar registros

Fecha: 12 de noviembre de 2026. Estado: **dos ejecuciones Succeeded confirmadas por Gerald; conteos estables y conservacion de claves confirmados en Workbench**.

## Resultado de la prueba realizada

Gerald creo el job separado y confirmo dos ejecuciones Succeeded. Despues de la
primera se comprobaron 59 clientes, 59 IDs unicos, 59 claves unicas y 29 estados
Sin dato. La tabla temporal de claves ya existia en Workbench; el error 1050 al
intentar crearla otra vez no fue un error del ETL. Tras la segunda ejecucion,
Gerald confirmo los mismos conteos y 0 claves cambiadas/clientes eliminados.
No se hicieron pruebas con nuevos clientes ni cambios de atributos. Las capturas
disponibles y las confirmaciones textuales se distinguen en
[el indice de evidencias](evidencias/2026-11-12/README.md).

## Problema identificado

El script exportado [invacom-load-dimcliente.py](../scripts-aws/invacom-load-dimcliente.py)
termina con `write_dynamic_frame.from_catalog`: carga por insercion. La restriccion
UNIQUE de CustomerId impide duplicar clientes, pero repetir esa carga puede fallar.
No es suficiente quitar duplicados dentro del CSV: tambien hay que reconocer lo
que ya existe en el destino.

## Solucion propuesta para este job

Archivo separado: [invacom-load-dimcliente-recarga.py](../scripts-aws/invacom-load-dimcliente-recarga.py).
El original permanece intacto como respaldo del flujo visual.

1. Lee el mismo Customer.csv privado en S3 y conserva la transformacion Spark SQL.
2. Valida IDs positivos, atributos obligatorios y longitudes de las columnas.
3. Consolida filas iguales. Si un ID trae atributos diferentes en el mismo lote,
   detiene la carga para que se revise el origen, sin escoger una fila arbitraria.
4. Usa una transaccion JDBC MySQL con `INSERT ... ON DUPLICATE KEY UPDATE`.
   CustomerId identifica al cliente: inserta los nuevos y actualiza nombre y
   ubicacion de los existentes. **ClienteKey nunca se actualiza**.
5. Confirma el lote completo o solicita rollback ante un fallo de escritura.

Es una actualizacion de dimension tipo 1: sobrescribe atributos, sin historial.
No elimina los clientes ausentes del CSV. Los huecos futuros en AUTO_INCREMENT
son normales y no equivalen a clientes duplicados.

Para los 59 clientes de Chinook se utiliza JDBC directamente desde el driver de
Spark, con un limite de 10 000 filas. Esto evita agregar staging o procedimientos
almacenados para este primer caso. Para volumenes mayores se debe adoptar una
carga por staging y fusion en el servidor. No usar este script para otras tablas.

Las credenciales se obtienen de `invacom-mysql-connection`, sin escribirlas en
el codigo. La conexion usa SSL obligatorio (cifrado; no agrega verificacion de
identidad del servidor). Si existen certificados JDBC personalizados, se detiene
para adaptar esa configuracion. No se agregan dependencias descargadas de Internet.

## Procedimiento para reproducir la prueba

1. Crear un job **Script editor / Spark / Python**, llamado
   `invacom-load-dimcliente-recarga`. Pegar el contenido completo de la version nueva.
   El codigo personalizado puede perder la edicion visual; por eso se prueba aparte.
2. Conservar Glue 6.0, G.1X, 2 workers, timeout 10 minutos, 0 reintentos,
   concurrencia maxima 1 y bookmarks desactivados. No ejecutar simultaneamente
   el original y la recarga.
3. Usar AWSGlueServiceRole y asociar `invacom-mysql-connection` en las conexiones
   de red del job. Mantener las rutas scripts/ y temp/ del bucket del proyecto.
   El rol debe poder leer el CSV, la conexion y su secreto, y usar la red JDBC
   existente. No ampliar permisos a administrador para resolver posibles errores.
4. Antes de ejecutar, abrir la **misma sesion de Workbench** y correr la seccion
   ANTES de [06_validar_recarga_dimcliente_mysql.sql](../sql/06_validar_recarga_dimcliente_mysql.sql).
5. Ejecutar la version candidata, esperar **Succeeded** y correr la seccion DESPUES.
6. Ejecutarla una segunda vez con el mismo CSV y repetir DESPUES.
   Deben mantenerse 59 clientes, 59 IDs distintos, 29 estados Sin dato,
   cero cambios de ClienteKey y cero ventas sin cliente.
7. Guardar capturas de ambas ejecuciones y resultados. Solo entonces considerar
   esta version comprobada y acordar cual job se usara en las siguientes recargas.

Un job puede haber confirmado la transaccion y fallar despues al cerrar/registrar
su estado; repetir el lote vuelve a actualizar los mismos IDs. El estado de Glue
por si solo no sustituye la comprobacion en MySQL.

Si en otro entorno la conexion unificada version 2 no devuelve `fullUrl`, usuario y password en
`extract_jdbc_conf`, el script se detiene antes de escribir; hay que comprobar esa
integracion en AWS. Las ejecuciones exitosas fueron realizadas por Gerald en
AWS; Codex no accedio directamente a la cuenta ni al RDS.

## Validacion local y alcance

Las pruebas locales cubren el CSV real (59 clientes, 29 estados vacios normalizados),
duplicados identicos, conflictos de ID, atributos invalidos y solicitud de
commit/rollback mediante un doble JDBC. No sustituyen una prueba real de MySQL,
Spark, SSL ni permisos de AWS. La repeticion real y conservacion de claves se
validaron segun la confirmacion del equipo anterior. El script no borra ni
recrea el destino. La modificacion posterior de los cuatro jobs visuales se
documenta por separado en [14-recargas-visuales.md](14-recargas-visuales.md).

## Referencias tecnicas

- [AWS Glue: extract_jdbc_conf](https://docs.aws.amazon.com/glue/latest/dg/aws-glue-api-crawler-pyspark-extensions-glue-context.html#aws-glue-api-crawler-pyspark-extensions-glue-context-extract_jdbc_conf).
- [MySQL 8.4: INSERT y ON DUPLICATE KEY UPDATE](https://dev.mysql.com/doc/refman/8.4/en/insert.html).
