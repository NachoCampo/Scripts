--La vista muestra el Circuito de Cobranzas donde tenemos "Nro. Pedido", "Nro. Factura", "Nro. Recibo", "Total Factura" y "Total Cobrado".
CREATE VIEW CircuitoCobranzas AS (
SELECT
    GVA14.COD_CLIENT AS [Cod. Cliente],
    GVA14.RAZON_SOCI AS [Razon Social],
	GVA21.FECHA_ENTR AS [Fecha Entrega Pedido], --Se coloca la Fecha de Entrega del Pedido para que sea filtro en la consulta.
    GVA21.FECHA_PEDI AS [Fecha Pedido],
    GVA21.NRO_PEDIDO AS [Nro. Pedido],
    GVA12.FECHA_EMIS AS [Fecha Factura],
    GVA12.T_COMP AS [Tipo Comprobante Factura],
    GVA55.N_COMP AS [Nro. Factura],
    --GVA07.FECHA_VTO AS [Fecha Vencimiento],
    GVA07.T_COMP_CAN AS [Tipo Recibo],
    GVA07.N_COMP_CAN AS [Nro. Recibo] ,
    SUM(GVA12.IMPORTE) AS [Total Factura],
    SUM(GVA07.IMPORT_CAN) AS [Total Cobrado],
    GVA21.USUARIO_INGRESO AS [Usuario Ingreso],
    GVA21.TERMINAL_INGRESO AS [Terminal Ingreso],
    CASE 
        WHEN SUM(GVA12.IMPORTE) = SUM(GVA07.IMPORT_CAN) THEN 'Totalmente Cobrada'
        WHEN SUM(GVA07.IMPORT_CAN) IS NULL THEN 'Sin Cobrar'
        ELSE 'Parcialmente Cobrada'
    END AS [Estado de Cobro]
FROM 
    GVA12
LEFT JOIN 
    GVA14 ON GVA14.COD_CLIENT = GVA12.COD_CLIENT 
LEFT JOIN 
    GVA07 ON GVA12.N_COMP = GVA07.N_COMP AND GVA12.T_COMP = GVA07.T_COMP
LEFT JOIN 
    GVA55 ON GVA55.N_COMP = GVA12.N_COMP
LEFT JOIN 
    GVA21 ON GVA21.NRO_PEDIDO = GVA55.NRO_PEDIDO
WHERE 
    GVA21.USUARIO_INGRESO LIKE 'PEDIDO%' AND GVA12.COND_VTA IN (2,3,4,5,6)
GROUP BY 
    GVA14.COD_CLIENT,
    GVA14.RAZON_SOCI,
    GVA21.FECHA_PEDI,
    GVA21.FECHA_ENTR,
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




--Consulta Externa agregada a Tango.
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET DATEFORMAT DMY 
SET DATEFIRST 7 
SET DEADLOCK_PRIORITY -8;
Select * from CircuitoCobranzas