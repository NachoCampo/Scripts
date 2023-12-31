/*Para las ventas consolidadas en una base de central, me trae todos aquellos clientes que no compran hace dos años*/
SELECT CTA_CLIENTE.COD_CLIENTE, CTA_CLIENTE.NOMBRE, GVA14.TELEFONO_1 AS [TELEFONO], CTA_CLIENTE.LOCALIDAD AS [LOCALIDAD]
FROM CTA_CLIENTE JOIN GVA14 ON
GVA14.COD_CLIENT = CTA_CLIENTE.COD_CLIENTE
WHERE CTA_CLIENTE.COD_CLIENTE NOT IN (
    SELECT COD_CLIENT
    FROM CTA02
    WHERE FECHA_EMIS >= DATEADD(DAY, -730, GETDATE())
    AND T_COMP = 'FAC'
);


/*Para las ventas consolidadas en una base de central, me trae todos aquellos clientes que no compran hace dos años pero al menos tuvieron una unica compra*/
SELECT DISTINCT CTA_CLIENTE.COD_CLIENTE, CTA_CLIENTE.NOMBRE, GVA14.TELEFONO_1 AS [TELEFONO], CTA_CLIENTE.LOCALIDAD AS [LOCALIDAD], MAX (CTA02.FECHA_EMIS) AS [ULTIMA VENTA]
FROM CTA_CLIENTE 
JOIN GVA14 ON GVA14.COD_CLIENT = CTA_CLIENTE.COD_CLIENTE
LEFT JOIN CTA02 ON CTA02.COD_CLIENT = CTA_CLIENTE.COD_CLIENTE
    AND CTA02.FECHA_EMIS <= DATEADD(DAY, -730, GETDATE())
    AND CTA02.T_COMP = 'FAC'
WHERE CTA02.COD_CLIENT IS NOT NULL
	GROUP BY CTA_CLIENTE.COD_CLIENTE, CTA_CLIENTE.NOMBRE, GVA14.TELEFONO_1, CTA_CLIENTE.LOCALIDAD
	ORDER BY CTA_CLIENTE.COD_CLIENTE 