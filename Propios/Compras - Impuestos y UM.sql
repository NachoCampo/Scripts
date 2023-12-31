/*Cambiar impuestos de Compras en Artículos*/
--begin tran
--Update sta11 set COD_IVA_CO = '1', COD_II_CO = '40', ID_CPA14_COD_IVA_CO = '20', ID_CPA14_COD_II_CO = '25' 
--where PERFIL = 'A'
--and ID_STA11 not in (Select id_Sta11 from STA_ARTICULO_UNIDAD_COMPRA) 
--commit


/*Insertar las unidades de medida de compras para los artículos Compra-Venta que no tienen el registro*/
BEGIN TRAN
INSERT INTO STA_ARTICULO_UNIDAD_COMPRA (FILLER, ID_STA11, ID_MEDIDA_COMPRA, EQUIVALENCIA, HABITUAL, ROW_VERSION)
SELECT
    --NEWID(), -- Generar un nuevo ID único para cada registro insertado
    '', -- Puedes reemplazar 'ValorFijo' con el valor deseado para la columna FILLER
    STA11.ID_STA11,
    '5', -- Puedes reemplazar 'ValorMedidaCompra' con el valor deseado para la columna ID_MEDIDA_COMPRA
    '1.0000000', -- Puedes reemplazar 'ValorEquivalencia' con el valor deseado para la columna EQUIVALENCIA
    '1', -- Puedes reemplazar 'ValorHabitual' con el valor deseado para la columna HABITUAL
    NULL -- Puedes reemplazar 'ValorRowVersion' con el valor deseado para la columna ROW_VERSION
FROM
    Sta11
WHERE
    PERFIL = 'A'
    AND ID_STA11 NOT IN (SELECT ID_STA11 FROM STA_ARTICULO_UNIDAD_COMPRA)
Commit
