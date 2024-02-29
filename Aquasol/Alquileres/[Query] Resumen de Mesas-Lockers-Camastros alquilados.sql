--Creación de la View y trae los alquileres del día que se consulta. A la 00.01 hs esta consulta se ve vacía debido a que todos los artículos, mediante el SP_HABILITA_ESCALA se vuelven a habilitar.
Create View AlquileresXPuesto AS (
SELECT
	1 AS [Cantidad],
    STA11.COD_ARTICU AS [Cód. Artículo],
    STA11.DESCRIPCIO AS [Desc. Artículo], 
    STA11FLD.DESCRIP AS [Puesto]
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
    )
GROUP BY 
    STA11FLD.DESCRIP, 
    STA11.COD_ARTICU, 
    STA11.DESCRIPCIO
)
