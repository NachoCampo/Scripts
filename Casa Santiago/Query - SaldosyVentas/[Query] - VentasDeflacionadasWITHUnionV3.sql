/*Es un resumen por artículo de la base Pruebas con las columnas: Fechas de Emisión, Cod. Artículo, Descripción Artículo, Cantidad y Total*/
CREATE VIEW VentasDeflacionadasPruebas AS (
SELECT 
	GVA12.FECHA_EMIS AS [Fecha de emisión] ,
	GVA53.COD_ARTICU AS [Cód. Artículo] ,
	ISNULL(GVA45.[DESC], STA11.DESCRIPCIO) AS [Descripción] ,
	SUM(CASE WHEN GVA12.T_Comp <> 'FAC' and GVA15.Tipo_Comp = 'C' then (-1) ELSE (1) END * GVA53.CANTIDAD) AS [Cantidad] ,
	SUM( CASE WHEN GVA12.T_Comp <> 'FAC' and GVA15.Tipo_Comp = 'C' then (-1) ELSE (1) END *  CASE 'BIMONCTE' WHEN 'BIMONCTE' THEN   (CASE GVA12.MON_CTE WHEN 1 THEN CASE 'NO' WHEN 'NO'                                   THEN CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                        THEN (GVA53.PRECIO_NET * GVA53.CANTIDAD)                                        ELSE GVA53.IMPORTE_EXENTO END                                   ELSE                                      CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                       THEN (GVA53.PRECIO_NET * GVA53.CANTIDAD) - ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_BONIF/100) + ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_FLE/100) +                                            ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_REC/100)                                      ELSE GVA53.IMP_NETO_P END                                   END 			                        ELSE CASE 'NO' WHEN 'NO'                                   THEN CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                        THEN (GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.COTIZ                                        ELSE (GVA53.IMPORTE_EXENTO * GVA12.COTIZ) END                                   ELSE CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                        THEN ((GVA53.PRECIO_NET * GVA53.CANTIDAD) - ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_BONIF/100) + ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_FLE/100) +                                            ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_REC/100)) * GVA12.COTIZ                                       ELSE (GVA53.IMP_NETO_P * GVA12.COTIZ) END                                   END                              END)  WHEN 'BIORIGEN' THEN   (CASE GVA12.MON_CTE WHEN 1 THEN CASE GVA12.Cotiz WHEN 0                                   THEN 0                                   ELSE CASE 'NO' WHEN 'NO'                                        THEN CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                             THEN (GVA53.PRECIO_NET * GVA53.CANTIDAD) / GVA12.COTIZ                                             ELSE (GVA53.IMPORTE_EXENTO / GVA12.COTIZ) END                                        ELSE CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                             THEN ((GVA53.PRECIO_NET * GVA53.CANTIDAD) - ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_BONIF/100) + ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_FLE/100) +                                                  ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_REC/100))  / GVA12.COTIZ                                            ELSE (GVA53.IMP_NETO_P / GVA12.COTIZ) END                                        END 				                           END 				                      ELSE CASE 'NO' WHEN 'NO'                                   THEN CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                        THEN (GVA53.PRECIO_NET * GVA53.CANTIDAD)                                        ELSE GVA53.IMPORTE_EXENTO END                                   ELSE CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                        THEN (GVA53.PRECIO_NET * GVA53.CANTIDAD) - ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_BONIF/100) + ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_FLE/100) +                                             ((GVA53.PRECIO_NET * GVA53.CANTIDAD)* GVA12.PORC_REC/100)                                       ELSE GVA53.IMP_NETO_P END                                   END                              END)  WHEN 'BICOTIZ'  THEN   (CASE GVA12.MON_CTE WHEN 1 THEN CASE 'NO' WHEN 'NO'                                   THEN CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                        THEN (GVA53.PRECIO_NET * GVA53.CANTIDAD) / 1                                        ELSE (GVA53.IMPORTE_EXENTO / 1) END                                   ELSE CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                        THEN ((GVA53.PRECIO_NET * GVA53.CANTIDAD) - ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_BONIF/100) + ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_FLE/100) +                                             ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_REC/100)) / 1                                       ELSE (GVA53.IMP_NETO_P / 1) END                                   END                              ELSE CASE 'NO' WHEN 'NO'                              THEN CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                   THEN (GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.COTIZ / 1                                   ELSE (GVA53.IMPORTE_EXENTO * GVA12.COTIZ) / 1 END                              ELSE CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                   THEN ((GVA53.PRECIO_NET * GVA53.CANTIDAD) - ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_BONIF/100) + ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_FLE/100) +                                        ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_REC/100))  * GVA12.COTIZ  / 1                                  ELSE (GVA53.IMP_NETO_P  * GVA12.COTIZ) / 1 END                              END                              END)  END       ) AS [Total] 
FROM 
GVA12 (NOLOCK)  
INNER JOIN GVA53 (NOLOCK) ON 
GVA53.T_COMP = GVA12.T_COMP AND GVA53.N_COMP = GVA12.N_COMP 
LEFT JOIN STA11 (NOLOCK) ON 
GVA53.COD_ARTICU = STA11.Cod_Articu
LEFT JOIN GVA45 (NOLOCK) ON GVA45.T_COMP = GVA12.T_COMP AND GVA45.N_COMP = GVA12.N_COMP AND GVA45.N_RENGLON = GVA53.N_RENGL_V
LEFT JOIN GVA15 ON GVA15.IDENT_COMP = GVA12.T_COMP
WHERE 
(GVA53.COD_ARTICU <> 'Art. Ajuste') AND (GVA53.COD_ARTICU <> '')
AND (GVA53.RENGL_PADR = 0 OR GVA53.INSUMO_KIT_SEPARADO =1)
GROUP BY 
	GVA12.FECHA_EMIS , GVA53.COD_ARTICU , ISNULL(GVA45.[DESC], STA11.DESCRIPCIO)
)

/*Es un resumen por artículo de la base Casa Santiago con las columnas: Fechas de Emisión, Cod. Artículo, Descripción Artículo, Cantidad y Total*/
CREATE VIEW VentasDeflacionadasCasaSantiago AS (
SELECT 
	GVA12.FECHA_EMIS AS [Fecha de emisión] ,
	GVA53.COD_ARTICU AS [Cód. Artículo] ,
	ISNULL(GVA45.[DESC], STA11.DESCRIPCIO) AS [Descripción] ,
	SUM(CASE WHEN GVA12.T_Comp <> 'FAC' and GVA15.Tipo_Comp = 'C' then (-1) ELSE (1) END * GVA53.CANTIDAD) AS [Cantidad] ,
	SUM( CASE WHEN GVA12.T_Comp <> 'FAC' and GVA15.Tipo_Comp = 'C' then (-1) ELSE (1) END *  CASE 'BIMONCTE' WHEN 'BIMONCTE' THEN   (CASE GVA12.MON_CTE WHEN 1 THEN CASE 'NO' WHEN 'NO'                                   THEN CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                        THEN (GVA53.PRECIO_NET * GVA53.CANTIDAD)                                        ELSE GVA53.IMPORTE_EXENTO END                                   ELSE                                      CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                       THEN (GVA53.PRECIO_NET * GVA53.CANTIDAD) - ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_BONIF/100) + ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_FLE/100) +                                            ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_REC/100)                                      ELSE GVA53.IMP_NETO_P END                                   END 			                        ELSE CASE 'NO' WHEN 'NO'                                   THEN CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                        THEN (GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.COTIZ                                        ELSE (GVA53.IMPORTE_EXENTO * GVA12.COTIZ) END                                   ELSE CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                        THEN ((GVA53.PRECIO_NET * GVA53.CANTIDAD) - ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_BONIF/100) + ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_FLE/100) +                                            ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_REC/100)) * GVA12.COTIZ                                       ELSE (GVA53.IMP_NETO_P * GVA12.COTIZ) END                                   END                              END)  WHEN 'BIORIGEN' THEN   (CASE GVA12.MON_CTE WHEN 1 THEN CASE GVA12.Cotiz WHEN 0                                   THEN 0                                   ELSE CASE 'NO' WHEN 'NO'                                        THEN CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                             THEN (GVA53.PRECIO_NET * GVA53.CANTIDAD) / GVA12.COTIZ                                             ELSE (GVA53.IMPORTE_EXENTO / GVA12.COTIZ) END                                        ELSE CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                             THEN ((GVA53.PRECIO_NET * GVA53.CANTIDAD) - ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_BONIF/100) + ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_FLE/100) +                                                  ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_REC/100))  / GVA12.COTIZ                                            ELSE (GVA53.IMP_NETO_P / GVA12.COTIZ) END                                        END 				                           END 				                      ELSE CASE 'NO' WHEN 'NO'                                   THEN CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                        THEN (GVA53.PRECIO_NET * GVA53.CANTIDAD)                                        ELSE GVA53.IMPORTE_EXENTO END                                   ELSE CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                        THEN (GVA53.PRECIO_NET * GVA53.CANTIDAD) - ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_BONIF/100) + ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_FLE/100) +                                             ((GVA53.PRECIO_NET * GVA53.CANTIDAD)* GVA12.PORC_REC/100)                                       ELSE GVA53.IMP_NETO_P END                                   END                              END)  WHEN 'BICOTIZ'  THEN   (CASE GVA12.MON_CTE WHEN 1 THEN CASE 'NO' WHEN 'NO'                                   THEN CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                        THEN (GVA53.PRECIO_NET * GVA53.CANTIDAD) / 1                                        ELSE (GVA53.IMPORTE_EXENTO / 1) END                                   ELSE CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                        THEN ((GVA53.PRECIO_NET * GVA53.CANTIDAD) - ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_BONIF/100) + ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_FLE/100) +                                             ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_REC/100)) / 1                                       ELSE (GVA53.IMP_NETO_P / 1) END                                   END                              ELSE CASE 'NO' WHEN 'NO'                              THEN CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                   THEN (GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.COTIZ / 1                                   ELSE (GVA53.IMPORTE_EXENTO * GVA12.COTIZ) / 1 END                              ELSE CASE WHEN SUBSTRING(GVA12.N_COMP, 1, 1) <> 'C'                                   THEN ((GVA53.PRECIO_NET * GVA53.CANTIDAD) - ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_BONIF/100) + ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_FLE/100) +                                        ((GVA53.PRECIO_NET * GVA53.CANTIDAD) * GVA12.PORC_REC/100))  * GVA12.COTIZ  / 1                                  ELSE (GVA53.IMP_NETO_P  * GVA12.COTIZ) / 1 END                              END                              END)  END       ) AS [Total] 
FROM 
GVA12 (NOLOCK)  
INNER JOIN GVA53 (NOLOCK) ON 
GVA53.T_COMP = GVA12.T_COMP AND GVA53.N_COMP = GVA12.N_COMP 
LEFT JOIN STA11 (NOLOCK) ON 
GVA53.COD_ARTICU = STA11.Cod_Articu
LEFT JOIN GVA45 (NOLOCK) ON GVA45.T_COMP = GVA12.T_COMP AND GVA45.N_COMP = GVA12.N_COMP AND GVA45.N_RENGLON = GVA53.N_RENGL_V
LEFT JOIN GVA15 ON GVA15.IDENT_COMP = GVA12.T_COMP
WHERE 
(GVA53.COD_ARTICU <> 'Art. Ajuste') AND (GVA53.COD_ARTICU <> '')
AND (GVA53.RENGL_PADR = 0 OR GVA53.INSUMO_KIT_SEPARADO =1)
GROUP BY 
	GVA12.FECHA_EMIS , GVA53.COD_ARTICU , ISNULL(GVA45.[DESC], STA11.DESCRIPCIO)
)



/*Unifica las dos empresas con sus totales*/
SELECT 
    DATEFROMPARTS(YEAR([Fecha de emisión]), MONTH([Fecha de emisión]), 1) AS [Fecha],
    [Cod. Articulo] AS [Codigo de Articulo],
    [Descripcion] AS [Descripcion Articulo],
    SUM(CASE WHEN [Desc. Sucursal] = 'Pruebas' THEN Cantidad ELSE 0 END) AS [Pruebas],
    SUM(CASE WHEN [Desc. Sucursal] = 'Casa Santiago' THEN Cantidad ELSE 0 END) AS [Casa Santiago],
    SUM(Cantidad) AS [Cantidad Total],
	SUM (Total) AS [Total Facturado]
FROM (
    SELECT 
        [Fecha de emisión], 
        [Cod. Articulo], 
        [Descripcion], 
        Cantidad,
		[Total],
        'Pruebas' AS [Desc. Sucursal] -- Agrega el nombre de la sucursal
    FROM 
        VentasDeflacionadasPruebas
    UNION ALL
    SELECT 
        [Fecha de emisión], 
        [Cod. Articulo], 
        [Descripcion], 
        Cantidad,
		[Total],
        'Casa Santiago' AS [Desc. Sucursal] -- Agrega el nombre de la sucursal
    FROM 
        CASA_SANTIAGO_VACANZA..VentasDeflacionadasCasaSantiago
) AS CombinedResults
GROUP BY 
    DATEFROMPARTS(YEAR([Fecha de emisión]), MONTH([Fecha de emisión]), 1),
    [Cod. Articulo],
    [Descripcion];

