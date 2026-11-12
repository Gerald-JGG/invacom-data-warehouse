# Scripts de AWS Glue

| Archivo | Procedencia y estado |
| --- | --- |
| invacom-load-dimcliente.py | Exportacion original aportada por Gerald, anterior al filtro visual del 12 de noviembre. Conservada como respaldo historico: su destino inserta directamente. No representa el job visual actual. |
| invacom-load-dimcliente-recarga.py | Version local usada para crear el job separado de recarga. Gerald confirmo dos ejecuciones Succeeded y conteos estables; confirmo 0 claves cambiadas/eliminadas en la comparacion posterior. |
| tests/test_dimcliente_recarga.py | Seis pruebas locales de validacion y control transaccional; no acceden a AWS. |

Los cuatro jobs visuales se modificaron en la consola AWS por el equipo. Sus
consultas nuevas estan conservadas en [etl/sql](../etl/sql/) y los resultados en
[el registro de recargas](../docs/14-recargas-visuales.md). **Todavia faltan las
exportaciones PySpark actuales de esos cuatro jobs**; no se fabricaron archivos
generados por AWS a partir de las capturas. Para obtenerlos, abrir cada job,
guardar y descargar su script actual desde la consola o desde el Script path de S3.
Revisar que no contengan credenciales antes de agregarlos al repositorio.

Pruebas locales, desde la raiz del repositorio con Python 3:

```powershell
python -B -m unittest discover -s scripts-aws/tests -v
```
