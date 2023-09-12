SELECT
    CTA_CLIENTE.COD_CLIENTE,
    CTA_CLIENTE.NOMBRE,
    GVA14.TELEFONO_1 AS [TELEFONO],
    CTA_CLIENTE.LOCALIDAD AS [LOCALIDAD],
    CASE --LE AGREGO A LA CONSULTA LAS CARPETAS.. SI EL CLIENTE ESTA CLASIFICADO MUESTRA LA CARPETA, SI NO LO ESTA LO MUESTRA "SIN CLASIFICAR"
        WHEN GVA14FLD.DESCRIP IS NULL THEN 'SIN CLASIFICAR' 
        ELSE GVA14FLD.DESCRIP
    END AS [CLASIFICACION]
FROM
    CTA_CLIENTE
JOIN
    GVA14 ON GVA14.COD_CLIENT = CTA_CLIENTE.COD_CLIENTE
LEFT JOIN 
    GVA14ITC ON GVA14ITC.ID_GVA14 = GVA14.ID_GVA14  --lE AGREGO LA CLASIFICACION DEL CLIENTE.
LEFT JOIN
    GVA14FLD ON GVA14FLD.IDFOLDER = GVA14ITC.IDFOLDER --LE AGREGO LAS CARPETAS DE LA CLASIFICACION DEL CLIENTE.
WHERE
    CTA_CLIENTE.COD_CLIENTE NOT IN (
        SELECT DISTINCT COD_CLIENT
        FROM CTA02
        WHERE FECHA_EMIS >= DATEADD(DAY, -730, GETDATE())
		AND COD_CLIENTE IS NOT NULL
		AND T_COMP = 'FAC'
    ) -- Busco clientes que no hayan comprado en los últimos 2 años.
AND 
	CTA_CLIENTE.COD_CLIENTE IN (
        SELECT DISTINCT COD_CLIENT
        FROM CTA02
        WHERE FECHA_EMIS < DATEADD(DAY, -730, GETDATE())
		AND COD_CLIENTE IS NOT NULL
		AND T_COMP = 'FAC' 
    ) -- Busco clientes que al menos hayan hecho una compra y no ninguno;
