/*Se crea una vista con todos los comprobantes de tesorería y sus renglones*/

Create View TotalComprobantesTesoreria AS (
SELECT   
 SUCURSAL.NRO_SUCURSAL AS [Nro. Sucursal] ,  
 SUCURSAL.DESC_SUCURSAL AS [Desc. sucursal] ,  
 CTA28.COD_COMP AS [Cód. Comprobante] ,  
 CTA28.N_COMP AS [Nro. Comprobante] ,  
 CTA28.BARRA AS [Barra] ,  
 CTA28.FECHA AS [Fecha de Comprobante] ,  
 CTA28.SITUACION AS [Estado] ,  
 CASE CTA28.CLASE   
  when 1 then 'Cobros'   
  when 2 then 'Pagos'   
  when 3 then 'Depósitos'   
  when 4 then 'Otros Movimientos y Cartera'   
  when 5 then 'Rechazo Cheques Propios'  
  when 6 then 'Rechazo Cheques de Terceros'  
  when 7 then 'Otros Movimientos'   
  when 8 then 'Transferencia de Cheques Diferidos a Bancos'   
  else 'Transferencia Entre Carteras' end AS [Clase de Comprobante] ,  
 CTA_CUENTA_TESORERIA.COD_CTA_CUENTA_TESORERIA AS [Cód. cuenta] ,  
 CTA_CUENTA_TESORERIA.DESC_CTA_CUENTA_TESORERIA AS [Desc. cuenta] ,  
 SUM(CTA29.MONTO) AS [Total mon. cte.] ,  
 CTA29.COD_OPERAC AS [Cód. de Operación] ,  
 CTA29.LEYENDA AS [Leyenda]   
FROM   
CTA28   
LEFT JOIN CTA29 ON (CTA28.COD_COMP = CTA29.COD_COMP AND CTA28.N_COMP = CTA29.N_COMP AND CTA28.BARRA = CTA29.BARRA AND CTA28.NRO_SUCURS = CTA29.NRO_SUCURS)   
LEFT JOIN CTA_CUENTA_TESORERIA ON (CTA_CUENTA_TESORERIA.COD_CTA_CUENTA_TESORERIA  = CTA29.COD_CTA)   
LEFT JOIN SUCURSAL ON (SUCURSAL.NRO_SUCURSAL = CTA29.NRO_SUCURS)  
  
  
WHERE   
  
CTA29.RENGLON <> 0   
AND (
        (CTA28.CLASE = 1 AND 'Cobros' = 'Cobros') OR
        (CTA28.CLASE = 2 AND 'Pagos' = 'Pagos') OR
        (CTA28.CLASE = 3 AND 'Depósitos' = 'Depósitos') OR
        (CTA28.CLASE = 4 AND 'Otros Movimientos y Cartera' = 'Otros Movimientos y Cartera') OR
        (CTA28.CLASE = 5 AND 'Rechazo Cheques Propios' = 'Rechazo Cheques Propios') OR
        (CTA28.CLASE = 6 AND 'Rechazo Cheques de Terceros' = 'Rechazo Cheques de Terceros') OR
        (CTA28.CLASE = 7 AND 'Otros Movimientos' = 'Otros Movimientos') OR
        (CTA28.CLASE = 8 AND 'Transferencia de Cheques Diferidos a Bancos' = 'Transferencia de Cheques Diferidos a Bancos'))

		
GROUP BY   
  
SUCURSAL.NRO_SUCURSAL , SUCURSAL.DESC_SUCURSAL , CTA28.COD_COMP , CTA28.N_COMP , CTA28.BARRA , CTA28.FECHA , CTA28.SITUACION ,   
 CASE CTA28.CLASE   
  when 1 then 'Cobros'   
  when 2 then 'Pagos'   
  when 3 then 'Depósitos'   
  when 4 then 'Otros Movimientos y Cartera'   
  when 5 then 'Rechazo Cheques Propios'   
  when 6 then 'Rechazo Cheques de Terceros'   
  when 7 then 'Otros Movimientos'   
  when 8 then 'Transferencia de Cheques Diferidos a Bancos'   
         else 'Transferencia Entre Carteras' end,
CTA_CUENTA_TESORERIA.COD_CTA_CUENTA_TESORERIA , CTA_CUENTA_TESORERIA.DESC_CTA_CUENTA_TESORERIA , CTA29.COD_OPERAC , CTA29.LEYENDA  
)
