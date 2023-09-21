/*Se crea la vista con todos los campos solicitados en el correo.. La vista se llamara: "FavaComprobantes"*/
 CREATE VIEW FavaComprobantes AS   
SELECT   
    GVA12.FECHA_EMIS AS [Fecha de Emisión],  
    dbo.TLMostrarComprobantecliente(gva12.t_comp, gva12.N_COMP, gva12.cod_client,   
        CASE   
            WHEN gva12.cod_client <> '000000' THEN gva14.razon_soci  
            ELSE gva38.RAZON_SOCI  
        END) AS [Comprobante],  
    CASE   
        WHEN GVA12.NRO_SUCURS = '0' THEN 'FAVA'  
        ELSE CAST(GVA12.NRO_SUCURS AS VARCHAR(10)) -- Se ajusta la longitud del campo según tus necesidades  
    END AS [Sucursal], -- Aquí se gestiona GVA12.NRO_SUCURSAL  
    GVA12.COD_VENDED AS [Codigo de Vendedor],  
    GVA23.NOMBRE_VEN AS [Nombre Vendedor],  
    CAST(GVA12.COND_VTA AS INT) AS [Condición de Venta], -- Ajustado a INT (Entero)
    GVA01.DESC_COND AS [Descripción de Cond. Venta],
	AC.COD_STA11 AS [Artículo], --Artículo que interviene en la factura.
    CUENTA.DESC_CUENTA AS [Seccion/Cuenta Contable], -- Esto sale de la cuenta contable del artículo.  
    CAST(GVA53.PREC_ULC_L AS decimal (13,2)) AS [Costo Total],  --Costo Total (Precio Standard que se graba todas las noches). Se va a buscar a la factura.
    CAST(SBA05.COD_CTA AS INT) AS [Cuenta Fondos], -- Ajustado a INT (Entero) 
    SBA01.DESCRIPCIO AS [Nombre de Cuenta Fondos],  
    SBA22.COD_TARJET AS [Codigo de Tarjeta],  
    CAST(SBA20.ID_PLAN_TARJETA AS INT) AS [Cód. Promoción], -- Ajustado a INT (Entero)
    PT.DESC_PLAN_TARJETA AS [Desc. Promoción],  
    CAST(SBA20.CANT_CUOTA AS INT) AS [Cant. Cuotas], -- Ajustado a INT  (Entero)
    CONVERT(NVARCHAR(20), CAST(SBA20.COMISION AS DECIMAL(10, 3))) + '%' AS [Tasa de Interés de la Tarjeta],  
    'Asiento' AS [Detalle del Asiento]  
FROM GVA12  
LEFT JOIN GVA14 ON GVA14.COD_CLIENT = GVA12.COD_CLIENT   
LEFT JOIN GVA38 ON GVA38.T_COMP = GVA12.T_COMP AND GVA38.N_COMP = GVA12.N_COMP  
INNER JOIN GVA01 ON GVA01.COND_VTA = GVA12.COND_VTA  
INNER JOIN SBA04 ON SBA04.N_COMP = GVA12.N_COMP AND SBA04.COD_COMP = GVA12.T_COMP  
INNER JOIN SBA05 ON SBA05.N_COMP = GVA12.N_COMP AND SBA05.COD_COMP = GVA12.T_COMP  
INNER JOIN GVA15 ON GVA15.IDENT_COMP = GVA12.T_COMP  
INNER JOIN GVA23 ON GVA23.COD_VENDED = GVA12.COD_VENDED  
INNER JOIN GVA53 ON GVA53.N_COMP = gva12.N_COMP AND GVA53.T_COMP = gva12.T_COMP  
INNER JOIN STA11 ON STA11.COD_ARTICU = GVA53.COD_ARTICU  
INNER JOIN ARTICULO_CUENTA AC ON STA11.COD_ARTICU = AC.COD_STA11 COLLATE Latin1_General_BIN   
INNER JOIN SBA01 ON SBA01.COD_CTA = SBA05.COD_CTA  
INNER JOIN SBA22 ON SBA22.ID_SBA22 = SBA01.ID_SBA22  
INNER JOIN SBA20 ON SBA20.COD_CTA = SBA01.COD_CTA AND SBA20.T_COMP_REC = GVA12.T_COMP AND SBA20.N_COMP_REC = GVA12.N_COMP  
INNER JOIN PLAN_TARJETA PT ON PT.ID_PLAN_TARJETA = SBA20.ID_PLAN_TARJETA  
INNER JOIN ASIENTO_COMPROBANTE_GV ON ASIENTO_COMPROBANTE_GV.NCOMP_IN_V = GVA12.NCOMP_IN_V  
INNER JOIN ASIENTO_GV ON ASIENTO_COMPROBANTE_GV.ID_ASIENTO_COMPROBANTE_GV = ASIENTO_GV.ID_ASIENTO_COMPROBANTE_GV  
INNER JOIN CUENTA ON CUENTA.ID_CUENTA = ASIENTO_GV.ID_CUENTA AND AC.ID_CUENTA_VENTAS = CUENTA.ID_CUENTA  
GROUP BY  
    GVA12.FECHA_EMIS,  
    dbo.TLMostrarComprobantecliente(gva12.t_comp, gva12.n_comp, gva12.cod_client,   
        CASE   
            WHEN gva12.cod_client <> '000000' THEN gva14.razon_soci  
            ELSE gva38.RAZON_SOCI  
        END),  
    CASE   
        WHEN GVA12.NRO_SUCURS = '0' THEN 'FAVA'  
        ELSE CAST(GVA12.NRO_SUCURS AS VARCHAR(10)) -- Se ajusta la longitud del campo según tus necesidades    
    END,  
    GVA12.COD_VENDED,  
    GVA12.COND_VTA,  
    GVA01.DESC_COND,  
    SBA05.COD_CTA,  
    SBA22.COD_TARJET,  
    GVA23.NOMBRE_VEN,  
    SBA01.DESCRIPCIO,  
    CAST(SBA20.ID_PLAN_TARJETA AS INT),  
    PT.DESC_PLAN_TARJETA,  
    CAST(SBA20.CANT_CUOTA AS INT),  
    CONVERT(NVARCHAR(20), CAST(SBA20.COMISION AS DECIMAL(10, 3))) + '%',  
    AC.COD_STA11,  
    CUENTA.DESC_CUENTA,  
    GVA53.PREC_ULC_L;  

/*Se ejecuta la vista correspondiente en el asistente de Consultas Externas*/
	Select * from FavaComprobantes
