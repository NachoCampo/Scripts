/*Se crea una tabla de 'Historial' para que se pueda consultar los alquileres de los días anteriores*/
CREATE TABLE HistorialConsultaAlquileres (
    Id_Historial INT IDENTITY(1,1) PRIMARY KEY,
    FechaConsulta DATETIME,
    Cantidad INT,
    CodArticulo VARCHAR(50),
    DescArticulo VARCHAR(255),
    Puesto VARCHAR(100)
);

/*Esto reinicia el ID de la Tabla a 0*/
--DBCC CHECKIDENT ('HistorialConsultaAlquileres', RESEED, 0);

--Luego, una vez creada la tabla, el INSERT todos los días a las 23 hs, se ejecuta por Tarea programada e ingresa en la tabla los datos acumulados de ese día ya que a las 00.01 HS se vacía la misma.
INSERT INTO HistorialConsultaAlquileres (FechaConsulta, Cantidad, CodArticulo, DescArticulo, Puesto)
SELECT
    GETDATE() AS FechaConsulta,
    1 AS Cantidad,
    STA11.COD_ARTICU AS CodArticulo,
    STA11.DESCRIPCIO AS DescArticulo, 
    STA11FLD.DESCRIP AS Puesto
FROM 
    STA11 
JOIN 
    STA11ITC ON STA11.COD_ARTICU = STA11ITC.CODEA
JOIN 
    STA11FLD ON STA11ITC.IDFOLDER = STA11FLD.IDFOLDER
WHERE 
    PERFIL = 'N'
    AND (
        STA11.DESCRIPCIO LIKE 'MESAS CON LOCKERS%'
        OR STA11.DESCRIPCIO LIKE 'MESAS SIN LOCKERS%'
        OR STA11.DESCRIPCIO LIKE '%LOCKERS GRANDE%'
        OR STA11.DESCRIPCIO LIKE '%LOCKERS CHICO%'
        OR STA11.DESCRIPCIO LIKE '%CAMASTRO X3 PERSONAS%' 
    );

