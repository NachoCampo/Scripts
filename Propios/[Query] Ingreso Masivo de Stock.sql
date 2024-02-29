SELECT
    sta11.COD_ARTICU AS [Código],
    sta11.DESCRIPCIO AS [Descripción],
    '01' AS [Depósito],
	'NO' AS [Informar Partida],
	'' AS [Numero partida],
	'' AS [Vencimiento Partida],
    MEDIDA.DESC_MEDIDA AS [Unidad medida],
    '' AS [Cantidad],
	Sta11.ID_MEDIDA_STOCK_2 AS [Unidad medida 2],
	'' AS [Cantidad 2],
	'1.00' AS [Precio],
	'' AS [Error],
	CAST(sta11.EQUIVALENCIA_STOCK_2 AS INT) AS [Equivalencia 2]
FROM
    Sta11
   -- JOIN STA19 ON sta19.COD_ARTICU = sta11.cod_articu
    JOIN MEDIDA ON sta11.ID_MEDIDA_CONTROL_STOCK = medida.ID_MEDIDA
WHERE
    --sta19.cant_stock != '0.0000000'
   -- AND sta19.CANT_STOCK LIKE '-%'
    sta11.FECHA_ALTA >= '2023-08-03'
