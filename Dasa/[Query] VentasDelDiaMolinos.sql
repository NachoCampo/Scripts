--Esta query es la original para DASA_SA y LESALBU_MDQ_SA donde se crean dos vistas con las Ventas (sin tope) y las unifica en una sola query. Luego desde el Live se filtra por día de "hoy". 
--La query muestra filtrada por el Proveedor "Molinos Rio de la Plata".
SELECT 
	GVA12.FECHA_EMIS AS [Fecha de emisión] ,
	GVA53.T_Comp AS [Tipo comprobante] ,
	GVA53.N_Comp AS [Nro. comprobante] ,
	CASE WHEN PROVEEDOR_HABITUAL_ART.COD_PROVEE IS NULL THEN    CPA01.NOM_PROVEE ELSE CPA01_PROV_HABITUAL.NOM_PROVEE END AS [Razón social (Proveedor)] ,
	 SUM( CASE WHEN GVA12.T_Comp <> 'FAC' and GVA15.Tipo_Comp = 'C' then (-1) ELSE (1) END *  CASE 'BIMONCTE' WHEN 'BIMONCTE' THEN   (CASE GVA12.MON_CTE WHEN 1 THEN CASE 'NO' WHEN 'NO'                                   THEN CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                        THEN (GVA53.PRECIO_NET * GVA53.CANTIDAD)                                        ELSE GVA53.IMPORTE_EXENTO END                                   ELSE                                      CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                       THEN (GVA53.PRECIO_NET * GVA53.CANTIDAD) - ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_BONIF/100) + ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_FLE/100) +                                            ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_REC/100)                                      ELSE GVA53.IMP_NETO_P END                                   END 			                        ELSE CASE 'NO' WHEN 'NO'                                   THEN CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                        THEN (GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.COTIZ                                        ELSE (GVA53.IMPORTE_EXENTO * GVA12.COTIZ) END                                   ELSE CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                        THEN ((GVA53.PRECIO_NET * GVA53.CANTIDAD) - ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_BONIF/100) + ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_FLE/100) +                                            ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_REC/100)) * GVA12.COTIZ                                       ELSE (GVA53.IMP_NETO_P * GVA12.COTIZ) END                                   END                              END)  WHEN 'BIORIGEN' THEN   (CASE GVA12.MON_CTE WHEN 1 THEN CASE GVA12.Cotiz WHEN 0                                   THEN 0                                   ELSE CASE 'NO' WHEN 'NO'                                        THEN CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                             THEN (GVA53.PRECIO_NET * GVA53.CANTIDAD) / GVA12.COTIZ                                             ELSE (GVA53.IMPORTE_EXENTO / GVA12.COTIZ) END                                        ELSE CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                             THEN ((GVA53.PRECIO_NET * GVA53.CANTIDAD) - ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_BONIF/100) + ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_FLE/100) +                                                  ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_REC/100))  / GVA12.COTIZ                                            ELSE (GVA53.IMP_NETO_P / GVA12.COTIZ) END                                        END 				                           END 				                      ELSE CASE 'NO' WHEN 'NO'                                   THEN CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                        THEN (GVA53.PRECIO_NET * GVA53.CANTIDAD)                                        ELSE GVA53.IMPORTE_EXENTO END                                   ELSE CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                        THEN (GVA53.PRECIO_NET * GVA53.CANTIDAD) - ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_BONIF/100) + ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_FLE/100) +                                             ((GVA53.PRECIO_NET * GVA53.CANTIDAD)* GVA12.PORC_REC/100)                                       ELSE GVA53.IMP_NETO_P END                                   END                              END)  WHEN 'BICOTIZ'  THEN   (CASE GVA12.MON_CTE WHEN 1 THEN CASE 'NO' WHEN 'NO'                                   THEN CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                        THEN (GVA53.PRECIO_NET * GVA53.CANTIDAD) / 1                                        ELSE (GVA53.IMPORTE_EXENTO / 1) END                                   ELSE CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                        THEN ((GVA53.PRECIO_NET * GVA53.CANTIDAD) - ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_BONIF/100) + ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_FLE/100) +                                             ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_REC/100)) / 1                                       ELSE (GVA53.IMP_NETO_P / 1) END                                   END                              ELSE CASE 'NO' WHEN 'NO'                              THEN CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                   THEN (GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.COTIZ / 1                                   ELSE (GVA53.IMPORTE_EXENTO * GVA12.COTIZ) / 1 END                              ELSE CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                   THEN ((GVA53.PRECIO_NET * GVA53.CANTIDAD) - ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_BONIF/100) + ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_FLE/100) +                                        ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_REC/100))  * GVA12.COTIZ  / 1                                  ELSE (GVA53.IMP_NETO_P  * GVA12.COTIZ) / 1 END                              END                              END)  END       ) AS [Total] 
FROM 
GVA12 (NOLOCK)  
INNER JOIN GVA53 (NOLOCK) ON 
GVA53.T_COMP = GVA12.T_COMP AND GVA53.N_COMP = GVA12.N_COMP 
 
LEFT JOIN STA11 (NOLOCK) ON 
GVA53.COD_ARTICU = STA11.Cod_Articu

LEFT JOIN CPA15 AS PROVEEDOR_HABITUAL_ART ON GVA53.COD_ARTICU = PROVEEDOR_HABITUAL_ART.COD_ARTICU AND PROVEEDOR_HABITUAL_ART.PROV_HABITUAL = 'S'
 
LEFT JOIN (SELECT COD_ARTICU, MIN(CPA15.COD_PROVEE) COD_PROVEE FROM CPA15 GROUP BY COD_ARTICU) AS PROVEEDOR_ART ON 
GVA53.COD_ARTICU = PROVEEDOR_ART.COD_ARTICU

LEFT JOIN CPA01 (NOLOCK) AS CPA01_PROV_HABITUAL ON PROVEEDOR_HABITUAL_ART.COD_PROVEE = CPA01_PROV_HABITUAL.COD_PROVEE 
 
LEFT JOIN CPA01 (NOLOCK) ON 
CASE WHEN PROVEEDOR_HABITUAL_ART.COD_PROVEE IS NULL THEN    ISNULL(PROVEEDOR_ART.COD_PROVEE, '' ) ELSE PROVEEDOR_HABITUAL_ART.COD_PROVEE END = CPA01.COD_PROVEE

LEFT JOIN GVA15 ON GVA15.IDENT_COMP = GVA12.T_COMP
WHERE 
(GVA53.COD_ARTICU <> 'Art. Ajuste') AND (GVA53.COD_ARTICU <> '')
 AND 
 (GVA53.RENGL_PADR = 0 OR GVA53.INSUMO_KIT_SEPARADO =1) AND CASE WHEN PROVEEDOR_HABITUAL_ART.COD_PROVEE IS NULL THEN    ISNULL(PROVEEDOR_ART.COD_PROVEE, '' ) ELSE PROVEEDOR_HABITUAL_ART.COD_PROVEE END IN ( '110001' ) 


GROUP BY 
	GVA12.FECHA_EMIS , GVA53.T_Comp , GVA53.N_Comp , CASE WHEN PROVEEDOR_HABITUAL_ART.COD_PROVEE IS NULL THEN    CPA01.NOM_PROVEE ELSE CPA01_PROV_HABITUAL.NOM_PROVEE END
)


--Esta consulta se agrega en el Administrador General > Consultas Externas apuntando a las dos bases de datos.
Select * from [DASA SA]..DasaVentasDelDiaMolinos
Union all
Select * from [LESALBU_MDQ_SA]..LesalbuVentasDiaMolinos