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

--Muestra el detalle de los ingresos del día, siempre y cuando tengan QR de Ingreso y también la entrada sea posterior a las 8.15 de la mañana.
SELECT 
    A.[Code] AS Codigo,
    A.[Description] AS Descripcion,
    COUNT(A.[Code]) AS Ingresaron
FROM [WSC_AQUASOL].[dbo].[Qrs] QR
INNER JOIN [dbo].[Articulos] A ON QR.ArticuloId = A.Id
WHERE 
    CAST(QR.[Entry] AS DATE) = CAST(GETDATE() AS DATE)
    AND QR.[Entry] IS NOT NULL
    AND CAST(QR.[Entry] AS TIME) >= '08:15:00'
GROUP BY A.Code, A.[Description];

--Muestra en "Cantidad de Ingresos" del día, siempre y cuando tengan QR de Ingreso y también la entrada sea posterior a las 8.15 de la mañana.
SELECT COUNT(1) AS CantDeIngresos FROM [WSC_AQUASOL].[dbo].[Qrs]
WHERE CAST([Entry] AS DATE) = CAST(GETDATE() AS DATE)
AND [Entry] IS NOT NULL
AND CAST([Entry] AS TIME) >= '08:15:00'