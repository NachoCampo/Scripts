SELECT 
	GVA12.FECHA_EMIS AS [Fecha Emisión],
	GVA53.T_COMP AS [Tipo de Comprobante], 
    GVA53.N_COMP AS [Número de Comprobante], 
    GVA53.COD_ARTICU AS [Cod. Articulo], 
    STA11.DESCRIPCIO AS [Desc. Articulo], 
    GVA53.PRECIO_PAN AS [Precio Pantalla], 
    GVA53.PRECIO_BONIF AS [Precio Bonificado],  
	GVA12.USUARIO_INGRESO AS [Usuario],
    GVA12.TERMINAL_INGRESO AS [Terminal] 
FROM 
    GVA53 
JOIN 
    gva12 ON gva12.N_COMP = GVA53.N_COMP AND gva12.T_COMP = GVA53.T_COMP
JOIN 
    STA11 ON STA11.COD_ARTICU = GVA53.COD_ARTICU
WHERE 
    GVA12.N_COMP NOT IN (SELECT N_COMP FROM GVA55) 
    AND GVA53.PRECIO_PAN = '0.0000000' 
    AND GVA53.COD_ARTICU != '' 
ORDER BY 
    GVA12.FECHA_EMIS;