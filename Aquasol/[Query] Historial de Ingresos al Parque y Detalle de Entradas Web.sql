CREATE view HistorialDeIngresosAlParque As (  
SELECT   
    CAST(1 AS INT) AS [Contador],   
    Articulos.Code AS [Codigo de Entrada],   
    Articulos.Description AS [Descripción de Entrada],   
    CONVERT(DATETIME, CONVERT(VARCHAR, Entry, 23)) AS [Fecha de Ingreso],   
    DeviceEntry AS [Molinete]   
FROM   
    [WSC_AQUASOL].[dbo].[Qrs]   
    JOIN Articulos ON Qrs.ArticuloId = Articulos.Id   
WHERE   
    [Entry] IS NOT NULL  
)


Create View DetalleVentaEntradasWeb AS (
Select 
CAST(1 AS INT) AS [Contador],   
A.Code AS [Codigo] , 
A.Description AS [Descripción], 
CAST(Q.ReservaId AS INT) AS [Número de Reserva], 
CONVERT(DATETIME, CONVERT(VARCHAR, q.CreatedOn, 23)) AS [Fecha de Compra], 
CONVERT(DATETIME, CONVERT(VARCHAR, Entry, 23)) AS [Fecha de Ingreso]from Qrs Q
	Join Articulos A on
		A.Id = Q.ArticuloId
where Q.CreatedBy = 'WEB'
)