--Esta consulta muestra todos aquellos clientes que NO compran dentro del último año y sus comprobantes anteriores.
SELECT
    CTA_CLIENTE.COD_CLIENTE AS [Cod. Cliente],
    CTA_CLIENTE.NOMBRE As [Nombre y Apellido],
    GVA14.TELEFONO_1 AS [Teléfono],
    CTA_CLIENTE.LOCALIDAD AS [Localidad],
	CTA02.N_COMP AS [Nro. Comprobante],
	CTA02.FECHA_EMIS AS [Fecha Comprobante],
	SUCURSAL.DESC_SUCURSAL AS [Sucursal]
FROM
    CTA_CLIENTE
JOIN
    GVA14 ON GVA14.COD_CLIENT = CTA_CLIENTE.COD_CLIENTE
LEFT JOIN 
	CTA02 ON CTA02.COD_CLIENT = CTA_CLIENTE.COD_CLIENTE
        AND CTA02.T_COMP = 'FAC'
        AND CTA02.FECHA_EMIS < DATEADD(DAY, -365, GETDATE())
JOIN SUCURSAL ON
	CTA02.ID_SUCURSAL = SUCURSAL.ID_SUCURSAL
WHERE
    CTA_CLIENTE.COD_CLIENTE NOT IN (
        SELECT COD_CLIENT
        FROM CTA02
        WHERE FECHA_EMIS >= DATEADD(DAY, -365, GETDATE())
            AND COD_CLIENT IS NOT NULL
            AND T_COMP = 'FAC'
    ) -- Busco clientes que no hayan comprado en el último año Al menos una compra
    AND CTA02.COD_CLIENT IS NOT NULL 