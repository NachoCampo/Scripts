/*Se crea una View Integral que muestra el "Historial de Alquileres* + "Alquileres del día" todo en una misma consulta donde se pueda filtrar por fecha para tener un resumen de lo que se fue alquilando por día y mismo un control*/
Create View HistorialAlquileresXPuesto AS (
SELECT 
    FechaConsulta AS [Fecha],
    Cantidad,
    CodArticulo COLLATE Modern_Spanish_CI_AI AS [Cod. Artículo],
    DescArticulo COLLATE Modern_Spanish_CI_AI AS [Desc. Artículo], 
    Puesto 
FROM HistorialConsultaAlquileres  --Le pega a la tabla Historial armada a medida.
WHERE FechaConsulta <> CONVERT(VARCHAR(10), GETDATE(), 120)  -- Asegúrate de que la columna FechaConsulta no sea igual a la fecha actual

UNION ALL

SELECT 
    CONVERT(VARCHAR(10), GETDATE(), 120) AS FechaConsulta,  -- Obtener solo la fecha actual en formato YYYY-MM-DD
    Cantidad,
    [Cod. Artículo],
    [Desc. Artículo],
    Puesto
FROM AlquileresXPuesto --Le pega a la VIEW de los alquileres del día.
)


--Esta es la query activa que esta hoy en día funcionando en el Administrador General con los datos del UNION ALL.
Select * from HistorialAlquileresXPuesto