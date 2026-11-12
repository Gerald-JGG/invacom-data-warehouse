-- Spark SQL, nodo visual Filtrar ventas nuevas.
-- origen: Transformar ventas; existentes: JDBC invacom_dw.FactVenta.
-- Ventas existentes es padre SOLO del filtro, no de Transformar ventas.
SELECT DISTINCT
    o.InvoiceLineId, o.InvoiceId, o.FechaKey, o.ClienteKey,
    o.CancionKey, o.Cantidad, o.PrecioUnitario, o.ImporteVenta
FROM origen o
LEFT ANTI JOIN existentes e ON o.InvoiceLineId = e.InvoiceLineId
