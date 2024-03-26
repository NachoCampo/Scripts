/*Se crea una consulta a medida de "Movimientos Consolidados" el cual muestra agrupado por artículo las cantidades, según entrada o salida*/
ALTER VIEW MOVIMIENTOSCONSOLIDADOS AS (
SELECT 
	CTA11.FECHA_MOV AS [Fecha movimiento] ,
	CASE 
		WHEN CTA11.TIPO_MOV = 'E' THEN 'Ingreso'
		WHEN CTA11.TIPO_MOV = 'S' THEN 'Egreso'
		ELSE 'Tipo no especificado'
	END AS [Tipo de Movimiento],
	CTA09.N_COMP AS [Nro. comprobante] ,
    CTA11.COD_ARTICU AS [Cód. Artículo], 
	CTA_ARTICULO.DESC_CTA_ARTICULO AS [Artículo] ,
	SUCURSAL.DESC_SUCURSAL AS [Sucursal] ,
	SUM(CASE CTA11.TIPO_MOV WHEN 'E' THEN CTA11.CANTIDAD ELSE - CTA11.CANTIDAD END) AS [Cantidad] ,
	CASE CTA11.TCOMP_IN_S WHEN 'FC' THEN '[Ventas] Factura' 
						WHEN 'FR' THEN '[Ventas] Factura remito' 
						WHEN 'CC' THEN '[Ventas] Nota de crédito' 
						WHEN 'DC' THEN '[Ventas] Nota de débito' 
						WHEN 'RC' THEN '[Ventas] Recibo' 
						WHEN 'RE' THEN '[Ventas] Remito' 
						WHEN 'DR' THEN '[Ventas] Devolución de remito' 
						WHEN 'FP' THEN '[Compras] Factura' 
						WHEN 'FS' THEN '[Compras] Factura remito' 
						WHEN 'CP' THEN '[Compras] Nota de crédito' 
						WHEN 'DP' THEN '[Compras] Nota de débito' 
						WHEN 'OP' THEN '[Compras] Orden de pago' 
						WHEN 'RP' THEN '[Compras] Remito' 
						WHEN 'DS' THEN '[Compras] Devolución de remito' 
						WHEN 'AJ' THEN '[Stock] Ajuste' 
						WHEN 'AR' THEN '[Stock] Armado' 
						WHEN 'TI' THEN '[Stock] Transferencia' 
						WHEN 'VS' THEN '[Stock] Egreso' 
						WHEN 'VE' THEN '[Stock] Ingreso' 
						WHEN 'ME' THEN '[Stock]] Descarga batch' 
						WHEN 'CR' THEN 'Comanda' END AS [Tipo]
FROM 
CTA11 
LEFT JOIN CTA09 ON CTA09.TCOMP_IN_S = CTA11.TCOMP_IN_S AND CTA09.NCOMP_IN_S = CTA11.NCOMP_IN_S AND CTA09.NRO_SUCURS = CTA11.NRO_SUCURS 
LEFT JOIN SUCURSAL ON (CTA11.NRO_SUCURS = SUCURSAL.NRO_SUCURSAL) 
LEFT JOIN CTA_ARTICULO ON (CTA11.COD_ARTICU = CTA_ARTICULO.COD_ARTICULO) 
LEFT JOIN CTA_DEPOSITO ON (CTA11.COD_DEPOSI = CTA_DEPOSITO.COD_CTA_DEPOSITO) 
LEFT JOIN ( Select  id_sucursal,id_cta_articulo, id_cta_deposito, Max(fecha) as fecha_max  from CTA_SALDO_ARTICULO_DEPOSITO group by id_sucursal,id_cta_articulo, id_cta_deposito) as SALDO on (CTA_ARTICULO.ID_CTA_ARTICULO = SALDO.ID_CTA_ARTICULO AND CTA_DEPOSITO.ID_CTA_DEPOSITO = SALDO.ID_CTA_DEPOSITO AND SUCURSAL.ID_SUCURSAL = SALDO.ID_SUCURSAL) 
LEFT JOIN CTA_SALDO_ARTICULO_DEPOSITO ON(SALDO.ID_CTA_ARTICULO = CTA_SALDO_ARTICULO_DEPOSITO.ID_CTA_ARTICULO AND SALDO.ID_CTA_DEPOSITO = CTA_SALDO_ARTICULO_DEPOSITO.ID_CTA_DEPOSITO AND SALDO.ID_SUCURSAL = CTA_SALDO_ARTICULO_DEPOSITO.ID_SUCURSAL AND SALDO.fecha_max = CTA_SALDO_ARTICULO_DEPOSITO.fecha) 
LEFT JOIN CTA_ARTICULO_SUCURSAL ON (CTA_SALDO_ARTICULO_DEPOSITO.ID_CTA_ARTICULO = CTA_ARTICULO_SUCURSAL.ID_CTA_ARTICULO AND CTA_SALDO_ARTICULO_DEPOSITO.ID_SUCURSAL = CTA_ARTICULO_SUCURSAL.ID_SUCURSAL) 
LEFT JOIN CTA_MEDIDA AS MEDIDA_STOCK ON (CTA_ARTICULO_SUCURSAL.ID_CTA_MEDIDA_STOCK = MEDIDA_STOCK.ID_CTA_MEDIDA) 
LEFT JOIN CTA_MEDIDA AS MEDIDA_STOCK_2 ON (CTA_ARTICULO_SUCURSAL.ID_CTA_MEDIDA_STOCK_2 = MEDIDA_STOCK.ID_CTA_MEDIDA) 
LEFT JOIN SUCURSAL SUC_DESTINO ON SUC_DESTINO.NRO_SUCURSAL = CTA09.SUC_DESTIN 
LEFT JOIN SUCURSAL SUC_ORIGEN ON SUC_ORIGEN.NRO_SUCURSAL = CTA09.SUC_ORIG
WHERE 
 CTA09.ESTADO_MOV <> 'A'
GROUP BY 
	CTA11.FECHA_MOV , CTA11.TIPO_MOV , CTA09.N_COMP , CTA_ARTICULO.DESC_CTA_ARTICULO , SUCURSAL.DESC_SUCURSAL ,  CASE CTA11.TCOMP_IN_S 
						WHEN 'FC' THEN '[Ventas] Factura' 
						WHEN 'FR' THEN '[Ventas] Factura remito' 
						WHEN 'CC' THEN '[Ventas] Nota de crédito' 
						WHEN 'DC' THEN '[Ventas] Nota de débito' 
						WHEN 'RC' THEN '[Ventas] Recibo' 
						WHEN 'RE' THEN '[Ventas] Remito' 
						WHEN 'DR' THEN '[Ventas] Devolución de remito' 
						WHEN 'FP' THEN '[Compras] Factura' 
						WHEN 'FS' THEN '[Compras] Factura remito' 
						WHEN 'CP' THEN '[Compras] Nota de crédito' 
						WHEN 'DP' THEN '[Compras] Nota de débito' 
						WHEN 'OP' THEN '[Compras] Orden de pago' 
						WHEN 'RP' THEN '[Compras] Remito' 
						WHEN 'DS' THEN '[Compras] Devolución de remito' 
						WHEN 'AJ' THEN '[Stock] Ajuste' 
						WHEN 'AR' THEN '[Stock] Armado' 
						WHEN 'TI' THEN '[Stock] Transferencia' 
						WHEN 'VS' THEN '[Stock] Egreso' 
						WHEN 'VE' THEN '[Stock] Ingreso' 
						WHEN 'ME' THEN '[Stock]] Descarga batch' 
						WHEN 'CR' THEN 'Comanda' END , CTA11.COD_ARTICU , CTA11.COD_CLASIF , CTA11.PRECIO
)