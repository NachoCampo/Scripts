SELECT [Cod. Articulo], 
	   [Desc. artículo],
       DATEFROMPARTS(YEAR([Fecha de Comprobante]), MONTH([Fecha de Comprobante]), 1) AS [Fecha Comprobante],
       SUM([Total Cantidad Stock]) AS [Total Cantidad Stock]
FROM (
    SELECT [Cod. Articulo], 
           [Fecha de Comprobante], 
		   [Desc. artículo],
           SUM([Cantidad Control Stock]) AS [Total Cantidad Stock]
    FROM (
        SELECT [Cod. Articulo], [Fecha de Comprobante], SUM([Cantidad Control Stock]) AS [Cantidad Control Stock], [Desc. artículo]
        FROM CASA_SANTIAGO_VACANZA..CasaSantiagoVentasDeflacionadas
        GROUP BY [Cod. Articulo], [Fecha de Comprobante], [Desc. artículo]

        UNION ALL

        SELECT [Cod. Articulo], [Fecha de Comprobante], SUM([Cantidad Control Stock]) AS [Cantidad Control Stock], [Desc. artículo]
        FROM PruebasVentasDeflacionadas
        GROUP BY [Cod. Articulo], [Fecha de Comprobante], [Desc. artículo]
    ) AS CombinedResults
    GROUP BY [Cod. Articulo], [Fecha de Comprobante], [Desc. artículo]
) AS MonthlyResults
GROUP BY [Cod. Articulo], [Desc. artículo] ,DATEFROMPARTS(YEAR([Fecha de Comprobante]), MONTH([Fecha de Comprobante]), 1);
