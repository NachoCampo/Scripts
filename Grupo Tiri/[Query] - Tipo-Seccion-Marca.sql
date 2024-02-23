SELECT 
Tipo.IDFOLDER AS [Numero de Tipo],
Tipo.DESCRIP AS "Tipo",
Seccion.IDFOLDER AS [Numero de Seccion],
Seccion.DESCRIP AS "Seccion",
Marca.IDFOLDER AS [Numero de Marca],
Marca.DESCRIP AS "Marca"
	FROM STA11FLD AS Marca
		JOIN STA11FLD AS Seccion ON Seccion.IDFOLDER = Marca.IDPARENT
		JOIN STA11FLD AS Tipo ON Tipo.IDFOLDER = Seccion.IDPARENT
	Where Tipo.DESCRIP <> 'TIPO-SECCION-MARCA'
order by Tipo, Seccion, Marca
