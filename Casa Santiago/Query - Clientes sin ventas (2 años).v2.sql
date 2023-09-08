/*La query en cuestion trae todos aquellos clientes que NO compran hace 2 años o más, pero al menos tuvieron una compra cargada en el sistema*/
	SELECT
    CTA_CLIENTE.COD_CLIENTE,
    CTA_CLIENTE.NOMBRE,
    GVA14.TELEFONO_1 AS [TELEFONO],
    CTA_CLIENTE.LOCALIDAD AS [LOCALIDAD]
FROM
    CTA_CLIENTE
JOIN
    GVA14 ON GVA14.COD_CLIENT = CTA_CLIENTE.COD_CLIENTE
WHERE
    CTA_CLIENTE.COD_CLIENTE NOT IN (
        SELECT DISTINCT COD_CLIENT
        FROM CTA02
        WHERE FECHA_EMIS >= DATEADD(DAY, -730, GETDATE())
		AND COD_CLIENTE IS NOT NULL
		AND T_COMP = 'FAC'
    ) --Busco clientes que no hayan comprado en los últimos 2 años.
    AND CTA_CLIENTE.COD_CLIENTE IN (
        SELECT DISTINCT COD_CLIENT
        FROM CTA02
        WHERE FECHA_EMIS < DATEADD(DAY, -730, GETDATE())
		AND COD_CLIENTE IS NOT NULL
		AND T_COMP = 'FAC' 
    )--Busco clientes que al menos haya hecho una compra y no ninguna;