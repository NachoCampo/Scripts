--La consulta muestra el Circuito de Cobranzas donde tenemos "Nro. Pedido", "Nro. Factura", "Nro. Recibo", "Total Factura" y "Total Cobrado".
CREATE VIEW CircuitoCobranzas AS (
SELECT
	GVA14.COD_CLIENT AS [Cod. Cliente], --Codigo de Cliente
	GVA14.RAZON_SOCI AS [Razon Social], --Razón Social del Cliente
    GVA21.FECHA_PEDI AS [Fecha Pedido], --Fecha del Pedido
    GVA21.NRO_PEDIDO AS [Nro. Pedido], -- Número de Pedido
    --GVA12.FECHA_EMIS AS [Fecha Factura], -- Fecha de la Factura
    GVA12.T_COMP AS [Tipo Comprobante], --Tipo de Comprobante relacionado a la Fac.
    GVA55.N_COMP AS [Nro. Factura], --Nro. de Factura.
    --GVA07.FECHA_VTO AS [Fecha Vencimiento], --Fecha de Vencimiento.
    GVA07.T_COMP_CAN AS [Tipo Recibo], --Código de Recibo.
    GVA07.N_COMP_CAN AS [Nro. Recibo] ,--Número de Recibo.
    SUM(GVA12.IMPORTE) AS [Total Factura], --Total de la Factura.
	SUM(GVA07.IMPORT_CAN) AS [Total Cobrado], --Total cobrado contra la Factura.
    GVA21.USUARIO_INGRESO AS [Usuario Ingreso], --Usuario de Ingreso del Pedido.
    GVA21.TERMINAL_INGRESO AS [Terminal Ingreso] --Terminal de Ingreso del Pedido.
FROM 
    GVA12
LEFT JOIN 
    GVA14 ON GVA14.COD_CLIENT = GVA12.COD_CLIENT --Relacion Maestro de Clientes VS Cliente del Comprobante.
LEFT JOIN 
    GVA07 ON GVA12.N_COMP = GVA07.N_COMP AND GVA12.T_COMP = GVA07.T_COMP --Relacion Comprobantes Cuenta Corriente VS Imputaciones.
JOIN 
    GVA55 ON GVA55.N_COMP = GVA12.N_COMP -- Relacion Pedido/Factura VS Comprobantes de Cuenta Corriente.
JOIN 
    GVA21 ON GVA21.NRO_PEDIDO = GVA55.NRO_PEDIDO --Relacion Encabezado de Pedido VS Pedido/Factura

WHERE GVA21.USUARIO_INGRESO LIKE 'PEDIDO%' AND GVA12.COND_VTA IN (2,3,4,5,6) --Solo se filtra a los Usuarios "Pedido%" donde queremos que traiga PEDIDO1, PEDIDO2, PEDIDO3, PEDIDO4 y PEDIDO5. También se filtra por Condición de Venta en Cuenta Corriente.

GROUP BY 
	GVA14.COD_CLIENT,
	GVA14.RAZON_SOCI,
    GVA21.FECHA_PEDI,
    GVA21.NRO_PEDIDO,
    GVA12.FECHA_EMIS,
    GVA12.T_COMP,
    GVA55.N_COMP,
    GVA07.FECHA_VTO,
    GVA07.T_COMP_CAN,
    GVA07.N_COMP_CAN,
    GVA21.USUARIO_INGRESO,
    GVA21.TERMINAL_INGRESO
)
