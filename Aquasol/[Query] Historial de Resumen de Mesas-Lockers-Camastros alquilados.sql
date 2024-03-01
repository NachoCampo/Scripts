/*Se crea una View Integral que muestra el "Historial de Alquileres* + "Alquileres del día" todo en una misma consulta donde se pueda filtrar por fecha para tener un resumen de lo que se fue alquilando por día y mismo un control*/
Create View HistorialAlquileresXPuesto AS (
SELECT 
    CAST(FechaConsulta AS DATE) AS [Fecha],  -- Convertir FechaConsulta a solo la fecha (sin hora)
    Cantidad,
    CodArticulo COLLATE Modern_Spanish_CI_AI AS [Cod. Artículo],
    DescArticulo COLLATE Modern_Spanish_CI_AI AS [Desc. Artículo],
    Puesto 
FROM HistorialConsultaAlquileres 
WHERE CAST(FechaConsulta AS DATE) <> CAST(GETDATE() AS DATE)  -- Comparamos solo la fecha, sin la hora

UNION ALL

SELECT 
    CAST(GETDATE() AS DATE) AS FechaConsulta,  -- Convertir la fecha actual a solo fecha (sin hora)
    Cantidad,
    [Cod. Artículo],
    [Desc. Artículo],
    Puesto
FROM AlquileresXPuesto
)


--Esta es la query activa que esta hoy en día funcionando en el Administrador General con los datos del UNION ALL.
Select * from HistorialAlquileresXPuesto
