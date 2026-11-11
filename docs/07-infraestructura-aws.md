# 07 — Configuración de AWS y resolución de bloqueos

Fecha de registro: 9 de noviembre de 2026, hora de Costa Rica (UTC−06:00).

## Arquitectura y decisiones

Ruta de implementación: **CSV de Chinook en S3 → ETL con AWS Glue → DW MySQL en RDS → Excel**. La primera carga de clientes ya se comprobó en MySQL. Actualización del 10 de noviembre: el usuario mostró Excel con 59 clientes importados mediante Power Query, una tabla dinámica por país y un gráfico con segmentador. Las otras dimensiones, hechos y el dashboard de ventas siguen pendientes de comprobar. Consultar el [diagrama de arquitectura](10-arquitectura-aws.md).

Inicialmente el profesor asignó Google Cloud Data Fusion. El usuario reportó el error `OR_BACR2_59` al configurar facturación de Google Cloud y posteriormente comunicó que el profesor permitió usar AWS. No se atribuye una causa definitiva al error de Google. Redshift quedó descartado para esta implementación después de que la consola mostró una restricción de acceso; el proyecto #1 no exige un motor de DW específico.

Se consideró PostgreSQL, pero durante la configuración el equipo eligió MySQL y creó la instancia con ese motor. Se mantuvo el modelo estrella; los scripts físicos son para MySQL. La autorización de cambio a AWS está reportada por el usuario, sin adjuntar aquí una confirmación escrita del profesor.

## RDS y conexión de escritorio

| Parámetro | Configuración observada o acordada |
| --- | --- |
| Instancia | `invacom-dw` |
| Motor | MySQL Community 8.4.11 |
| Base | `invacom_dw` |
| Región | Ohio, `us-east-2` |
| Disponibilidad | Single-AZ, `us-east-2c` |
| Clase | `db.t4g.micro`, 2 vCPU y 1 GiB RAM |
| Almacenamiento | 20 GiB, General Purpose SSD gp2; se indicó desactivar autoscaling |
| Credenciales | Self managed, autenticación por contraseña; usuario inicial `admin` |
| Cifrado | Activado; clave administrada predeterminada de RDS |
| Backups | Se indicó conservar backups automáticos con retención de un día |
| RDS Proxy y Enhanced Monitoring | Se indicó mantener desactivados |
| Conexión exterior | Se indicó acceso público limitado por security group a IPs concretas |
| Puerto | TCP 3306 |

No se exportó la configuración completa de RDS por API: los campos no mostrados en una captura final deben comprobarse en la consola antes de usarlos como inventario definitivo. La conexión desde Workbench pasó la prueba y se ejecutaron los scripts del DW; esa evidencia sí está guardada.

Para Workbench se utilizó el endpoint de la instancia, puerto 3306 y usuario `admin`. El endpoint se obtiene de RDS; no se versiona la contraseña. MySQL Workbench mostró una advertencia administrativa relativa a `SHOW SLAVE STATUS`; no impidió ejecutar las consultas y crear tablas en MySQL 8.4.11.

El error de conexión `10060` de otro integrante se trató como timeout de red: se indicó agregar su IP pública como origen `/32` de una regla MySQL. No se recibió una confirmación posterior que demuestre que ese integrante logró conectarse.

## S3

Bucket creado: `invacom-chinook-2026`, en Ohio, tipo General purpose. Se mantuvo bloqueo de acceso público, ACLs deshabilitadas y cifrado SSE-S3. Se indicó desactivar versionado y Object Lock.

El usuario confirmó la subida de los 11 CSV directamente en `raw/`, sin subcarpetas por tabla:

```text
s3://invacom-chinook-2026/
  raw/Album.csv
  raw/Artist.csv
  raw/Customer.csv
  raw/Employee.csv
  raw/Genre.csv
  raw/Invoice.csv
  raw/InvoiceLine.csv
  raw/MediaType.csv
  raw/Playlist.csv
  raw/PlaylistTrack.csv
  raw/Track.csv
  scripts/     (scripts de Glue)
  temp/        (temporales de Glue)
```

Cada origen del ETL debe seleccionar su archivo concreto. No leer `raw/` completo como una sola tabla: los CSV tienen esquemas distintos. `scripts/` y `temp/` son los prefijos configurados; su contenido final no se ha inventariado.

## Identificadores de red utilizados

| Recurso | Identificador |
| --- | --- |
| Cuenta del proyecto | `016355875829` |
| VPC | `vpc-09f857e7270c9309c` |
| Subred usada por Glue | `subnet-006e00c69708cb6b3`, `us-east-2c` |
| Security group compartido | `invacom-dw-sg`, `sg-05d9e25e9eb5e3ece` |
| Endpoint STS | `invacom-sts-endpoint`, `vpce-01814c10b87b9f212` |
| Endpoint Secrets Manager | `invacom-secretsmanager-endpoint`, `vpce-06408924ff1bd2ccc` |
| Tabla de rutas seleccionada para S3 | `rtb-0294dcbcf5583cea` |

Estos identificadores describen el entorno actual. En otra cuenta se deben reemplazar por sus recursos equivalentes.

Reglas del security group utilizadas:

- Entrada MySQL/Aurora TCP 3306 desde la IP autorizada de la computadora, con máscara `/32`.
- Entrada **All TCP, 0–65535**, con origen **el mismo security group**; el usuario confirmó haberla guardado. Permite comunicación interna de Glue y acceso HTTPS a los endpoints que comparten el grupo.
- Se conservó la salida predeterminada; no se indicó abrir entrada desde `0.0.0.0/0`.

La regla de la IP del escritorio y la regla interna sirven a clientes distintos. Usar **My IP** desde el navegador de otra persona autoriza la IP de esa persona, no la de todos los integrantes.

## Endpoints privados

| Servicio | Tipo | Configuración y evidencia |
| --- | --- | --- |
| `com.amazonaws.us-east-2.sts` | Interface | Available, DNS privado activado, IPv4, misma VPC y subred, grupo `invacom-dw-sg`; comprobado en capturas del chat |
| `com.amazonaws.us-east-2.secretsmanager` | Interface | Available, DNS privado activado, IPv4 y misma VPC; se indicó asociar `invacom-dw-sg`; posteriormente se creó correctamente la conexión Glue |
| `com.amazonaws.us-east-2.s3` | Gateway | Asociado a la tabla de rutas principal de las tres subredes; el usuario confirmó creación. No se guardó captura final del estado Available |

Se seleccionó política de endpoint Full access. Esto no sustituye los permisos IAM sobre secretos y objetos S3. No se creó un NAT Gateway durante el procedimiento documentado.

Los endpoints Interface de STS y Secrets Manager tienen consumo por tiempo aprovisionado; no desaparece al cerrar el navegador. El uso de RDS, Glue, almacenamiento y red también debe revisarse en el saldo de créditos. No se presenta la estimación previa del asistente AWS de US$11,88/mes como costo validado: no contemplaba todos los componentes de esta configuración. No se ha obtenido un reporte real de facturación.

## IAM y errores de creación de la conexión

Se usó el asistente **Getting started → Set up roles and users** para preparar `AWSGlueServiceRole`. No se seleccionaron usuarios adicionales en el primer paso. Se configuró lectura y escritura del bucket y se eligió el rol estándar.

La inspección en IAM mostró cuatro políticas: `AWSGlueConsole-S3-read-and-write-policy`, `AWSGlueConsoleFullAccess`, `AWSGlueServiceRole` y `AWSGlueServiceRole-EZCRC-s3Policy`. También se observó confianza en el servicio `glue.amazonaws.com` con condición de cuenta de origen. Probar permisos automáticos no resolvió el fallo inicial; se volvió a usar el rol existente.

CloudTrail en Ohio permitió identificar el rol rechazado y la operación concreta. Secuencia de diagnóstico:

| Error | Hallazgo y corrección aplicada |
| --- | --- |
| `AccessDeniedException when creating service linked secrets` | CloudTrail mostró que `AWSGlueServiceRole` no tenía `secretsmanager:CreateSecret`; se agregó una política inline limitada a los secretos de la conexión |
| Denegación de `secretsmanager:PutResourcePolicy` | Se agregó esa acción a la misma política. Una primera comprobación mostró que aún no se había guardado; se volvió a editar y guardar |
| `Failed to assume the customers role. Verify that your VPC has access to STS` | Se creó el endpoint STS con DNS privado y se configuró la regla interna del security group |
| `Unable to connect to secrets manager` | Se creó el endpoint privado de Secrets Manager |
| `The connection failed to provision during creation. Please delete the connection and create a new connection` | AWS no permitió actualizar el objeto fallido; se eliminó y recreó únicamente la conexión Glue, conservando RDS, tablas y S3 |

Política inline utilizada, nombre `InvacomGlueConnectionSecret`:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ChinookConnectionSecret",
      "Effect": "Allow",
      "Action": [
        "secretsmanager:CreateSecret",
        "secretsmanager:TagResource",
        "secretsmanager:DescribeSecret",
        "secretsmanager:GetSecretValue",
        "secretsmanager:PutResourcePolicy"
      ],
      "Resource": "arn:aws:secretsmanager:us-east-2:016355875829:secret:glue!016355875829-invacom-mysql-connection-*"
    }
  ]
}
```

La política corresponde a esta cuenta, región y nombre de conexión. No contiene el secreto ni debe sustituirse por acceso administrativo general. La lectura de metadatos no autoriza publicar las credenciales. Los intentos fallidos pudieron dejar secretos asociados; no se ha hecho inventario ni limpieza de ellos y no se deben borrar indiscriminadamente.

## Conexión Glue y catálogo

Conexión: `invacom-mysql-connection`, tipo MySQL, versión 2, base `invacom_dw`, puerto 3306, SSL requerido, autenticación de usuario y contraseña, rol `AWSGlueServiceRole` y red de la tabla anterior. Se observó aviso verde **Connection is ready for you to use**; [evidencia](evidencias/2026-11-09/01-conexion-glue-lista.png).

En Glue se creó la base de metadatos `invacom_catalog`, tipo Glue Database, sin Location. Es diferente de la base física `invacom_dw` en RDS.

Crawler `invacom-crawler-mysql-dw`:

- Fuente MySQL, conexión `invacom-mysql-connection`, include path `invacom_dw/%`.
- Rol `AWSGlueServiceRole`, salida `invacom_catalog`, sin prefijo y frecuencia On demand.
- Sin clasificadores personalizados ni metadatos adicionales de Comments/Raw types.
- Se ejecutó una vez y agregó `invacom_dw_dimcancion`, `invacom_dw_dimcliente`, `invacom_dw_dimfecha` e `invacom_dw_factventa`; [evidencia](evidencias/2026-11-09/02-crawler-cuatro-tablas.png).

El selector de fuente JDBC no mostraba la conexión de tipo MySQL. Elegir **MySQL** en el crawler sí la mostró; no fue necesario crear otra conexión JDBC. La catalogación registró estructura, no cargó los CSV. Las tablas de destino estaban vacías al iniciar este proceso.

## Pendientes de infraestructura y respaldo

- Exportar el script PySpark y la configuración completa del job guardado. Hasta ahora se conserva su consulta SQL y capturas, no una exportación nativa del job.
- Capturar el estado final de la ejecución Glue y el inventario final de RDS/endpoints si se requieren como evidencia de consola.
- Comprobar saldo real de créditos y recursos activos; al finalizar el proyecto, planificar su eliminación después de preservar scripts, evidencias y datos necesarios.
- No atribuir las acciones de consola a un integrante específico sin confirmación: fueron realizadas por el equipo desde sesiones compartidas y guiadas en el chat.

## Referencias utilizadas durante el diagnóstico

- [Configuración IAM de Glue](https://docs.aws.amazon.com/glue/latest/dg/set-up-iam.html).
- [Creación de secretos y permisos](https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_CreateSecret.html).
- [PutResourcePolicy](https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_PutResourcePolicy.html).
- [Eventos de Secrets Manager en CloudTrail](https://docs.aws.amazon.com/secretsmanager/latest/userguide/monitoring-cloudtrail.html).
- [Endpoint privado STS](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_sts_vpc_endpoint_create.html).
- [Red para Glue y RDS](https://docs.aws.amazon.com/glue/latest/dg/setup-vpc-for-glue-access.html).
- [Nodos de destino basados en el catálogo](https://docs.aws.amazon.com/glue/latest/dg/data-target-nodes.html).
