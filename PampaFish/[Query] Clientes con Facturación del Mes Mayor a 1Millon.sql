-- Creación de la Vista
Create View FacturacionMayora1MillonMensual AS 
SELECT
    -- Selecciona el código del cliente de la tabla GVA12 como "Código de Cliente"
    GVA12.COD_CLIENT AS [Código de Cliente],
    -- Selecciona la razón social de la tabla GVA14 como "Razón Social"
    GVA14.RAZON_SOCI AS [Razón Social],
    -- Cálculo de la Cantidad de Compras
    COUNT(CASE WHEN GVA12.T_COMP = 'FAC' THEN GVA12.N_COMP END) AS [Cantidad de Compras],
    -- Cálculo de la Facturación Total
    SUM(CASE WHEN GVA12.T_COMP = 'FAC' THEN GVA12.IMPORTE ELSE 0 END) +
    SUM(CASE WHEN GVA12.T_COMP = 'N/C' THEN -GVA12.IMPORTE ELSE 0 END) AS [Facturación Total]
FROM
    GVA12
JOIN
    GVA15 ON GVA12.T_COMP = GVA15.IDENT_COMP -- Realiza una unión con GVA15 usando la columna T_COMP de GVA12 y IDENT_COMP de GVA15
JOIN
    GVA14 ON GVA12.COD_CLIENT = GVA14.COD_CLIENT -- Realiza una unión con GVA14 usando la columna COD_CLIENT de GVA12 y GVA14
WHERE
    
    MONTH(GVA12.FECHA_EMIS) = MONTH(GETDATE()) -- Filtra las filas donde el mes de la fecha de emisión coincide con el mes actual
    AND YEAR(GVA12.FECHA_EMIS) = YEAR(GETDATE()) -- Filtra las filas donde el año de la fecha de emisión coincide con el año actual
    AND GVA12.COD_VENDED IN (04,05,06,07) -- Filtra las filas donde el código del vendedor está en la lista especificada
GROUP BY
    GVA12.COD_CLIENT, -- Agrupa los resultados por el código del cliente
    GVA14.RAZON_SOCI -- Agrupa los resultados por la razón social
HAVING
    SUM(CASE WHEN GVA12.T_COMP = 'FAC' THEN GVA12.IMPORTE ELSE -GVA12.IMPORTE END) > 1000000;     -- Filtra los resultados para incluir solo aquellos con una facturación total mayor a $1,000,000
