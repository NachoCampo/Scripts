Create View FAVACOMPROBANTES AS 
(SELECT 
    GVA12.FECHA_EMIS AS [Fecha de Emisión],
    dbo.TLMostrarComprobantecliente(gva12.t_comp, gva12.N_COMP, gva12.cod_client, CASE 
            WHEN gva12.cod_client <> '000000' THEN gva14.razon_soci
            ELSE gva38.RAZON_SOCI
            END) AS [Comprobante],
    --GVA12.COD_CLIENT AS [Codigo de Cliente],
    --GVA14.RAZON_SOCI AS [Razon Social],
    GVA12.COD_VENDED AS [Codigo de Vendedor],
    GVA23.NOMBRE_VEN AS [Nombre Vendedor],
    GVA12.COND_VTA AS [Condición de Venta],
    GVA01.DESC_COND AS [Descripción de Cond. Venta],
    SBA05.COD_CTA AS [Cuenta Fondos],
    SBA01.DESCRIPCIO AS [Nombre de Cuenta Fondos],
    SBA22.COD_TARJET AS [Codigo de Tarjeta],
    SBA20.ID_PLAN_TARJETA AS [Cód. Promoción],
    PT.DESC_PLAN_TARJETA AS [Desc. Promoción],
    SBA20.CANT_CUOTA AS [Cant. Cuotas],
    CONCAT(SBA20.COMISION, '%') AS [Tasa de Interes de la Tarjeta],
    'Asiento' AS [Detalle del Asiento]
--'Auxiliar' AS [Detalle de los Auxiliares] 
--CUENTA.COD_CUENTA AS [Cód. cuenta] ,
--CUENTA.DESC_CUENTA AS [Desc. cuenta] 
FROM GVA12
LEFT JOIN GVA14 ON GVA14.COD_CLIENT = GVA12.COD_CLIENT 
LEFT JOIN GVA38 ON GVA38.T_COMP = GVA12.T_COMP AND GVA38.N_COMP = GVA12.N_COMP
INNER JOIN GVA01 ON GVA01.COND_VTA = GVA12.COND_VTA
INNER JOIN SBA04 ON SBA04.N_COMP = GVA12.N_COMP AND SBA04.COD_COMP = GVA12.T_COMP
INNER JOIN SBA05 ON SBA05.N_COMP = GVA12.N_COMP AND SBA05.COD_COMP = GVA12.T_COMP
INNER JOIN GVA15 ON GVA15.IDENT_COMP = GVA12.T_COMP
INNER JOIN GVA23 ON GVA23.COD_VENDED = GVA12.COD_VENDED
INNER JOIN SBA01 ON SBA01.COD_CTA = SBA05.COD_CTA
INNER JOIN SBA22 ON SBA22.ID_SBA22 = SBA01.ID_SBA22
INNER JOIN SBA20 ON SBA20.COD_CTA = SBA01.COD_CTA AND SBA20.T_COMP_REC = GVA12.T_COMP AND SBA20.N_COMP_REC = GVA12.N_COMP
INNER JOIN PLAN_TARJETA PT ON PT.ID_PLAN_TARJETA = SBA20.ID_PLAN_TARJETA
INNER JOIN ASIENTO_COMPROBANTE_GV ON ASIENTO_COMPROBANTE_GV.NCOMP_IN_V = GVA12.NCOMP_IN_V
INNER JOIN ASIENTO_GV ON ASIENTO_COMPROBANTE_GV.ID_ASIENTO_COMPROBANTE_GV = ASIENTO_GV.ID_ASIENTO_COMPROBANTE_GV
INNER JOIN CUENTA ON CUENTA.ID_CUENTA = ASIENTO_GV.ID_CUENTA

GROUP BY
    dbo.TLMostrarComprobantecliente(gva12.t_comp, gva12.n_comp, gva12.cod_client, CASE 
            WHEN gva12.cod_client <> '000000' THEN gva14.razon_soci
            ELSE gva38.RAZON_SOCI
            END)
    ,GVA12.COD_VENDED
    ,GVA12.COND_VTA
    ,GVA12.FECHA_EMIS
    ,GVA12.COND_VTA
    ,GVA01.DESC_COND
    ,SBA05.COD_CTA
    ,SBA22.COD_TARJET
    ,GVA23.NOMBRE_VEN
    ,SBA01.DESCRIPCIO
    ,SBA20.ID_PLAN_TARJETA
    ,PT.DESC_PLAN_TARJETA
    ,SBA20.CANT_CUOTA
    ,SBA20.COMISION
)

