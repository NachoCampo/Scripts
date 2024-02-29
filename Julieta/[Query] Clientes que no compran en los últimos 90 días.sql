/*Clientes que no realizaron compras luego en los últimos 3 meses a la fecha*/
SELECT GVA14.COD_CLIENT, GVA14.RAZON_SOCI, GVA14.TELEFONO_1 AS [Telefono], GVA14.LOCALIDAD AS [Localidad]
FROM GVA14
WHERE COD_CLIENT NOT IN (
    SELECT COD_CLIENT
    FROM GVA12
    WHERE FECHA_EMIS >= DATEADD(DAY, -90, GETDATE())
    AND T_COMP = 'FAC'
);