CREATE TRIGGER InsertarEnSTA19
ON STA11
AFTER INSERT
AS
BEGIN
    -- Verificar si el artículo no existe en STA19 y tiene STOCK igual a '1' (Llave Stock en Tango)
    INSERT INTO STA19 (
        FILLER,
        CANT_COMP,
        CANT_PEND,
        CANT_STOCK,
        COD_ARTICU,
        COD_DEPOSI,
        FECHA_ANT,
        LOTE,
        SALDO_ANT,
        EXP_SALDO,
        COD_UBIC1,
        COD_UBIC2,
        COD_UBIC3,
        UBIC_TXT,
        CANT_COMP_2,
        CANT_PEND_2,
        CANT_STOCK_2,
        SALDO_ANT_STOCK_2,
        ID_STA11,
        ID_STA22
    )
    SELECT
        '',  -- Valor para FILLER (debe coincidir con el tipo de dato)
        0.0000000,  -- Valor para CANT_COMP (debe coincidir con el tipo de dato)
        0.0000000,  -- Valor para CANT_PEND (debe coincidir con el tipo de dato)
        0.0000000,  -- Valor para CANT_STOCK (debe coincidir con el tipo de dato)
        INSERTED.COD_ARTICU,
        '10',  -- Valor para COD_DEPOSI (debe coincidir con el tipo de dato)
        GETDATE(),  -- Valor para FECHA_ANT (fecha actual, puedes ajustarla según tus necesidades)
        '',  -- Valor para LOTE (debe coincidir con el tipo de dato)
        0.0000000,  -- Valor para SALDO_ANT (debe coincidir con el tipo de dato)
        '',  -- Valor para EXP_SALDO (debe coincidir con el tipo de dato)
        '',  -- Valor para COD_UBIC1 (debe coincidir con el tipo de dato)
        '',  -- Valor para COD_UBIC2 (debe coincidir con el tipo de dato)
        '',  -- Valor para COD_UBIC3 (debe coincidir con el tipo de dato)
        '',  -- Valor para UBIC_TXT (debe coincidir con el tipo de dato)
        0.0000000,  -- Valor para CANT_COMP_2 (debe coincidir con el tipo de dato)
        0.0000000,  -- Valor para CANT_PEND_2 (debe coincidir con el tipo de dato)
        0.0000000,  -- Valor para CANT_STOCK_2 (debe coincidir con el tipo de dato)
        0.0000000,  -- Valor para SALDO_ANT_STOCK_2 (debe coincidir con el tipo de dato)
        INSERTED.ID_STA11,  -- Valor para ID_STA11 (debe coincidir con el tipo de dato)
        '6'  -- Valor para ID_STA22 (debe coincidir con el tipo de dato)
    FROM INSERTED
    WHERE INSERTED.COD_ARTICU NOT IN (SELECT COD_ARTICU FROM STA19)
    AND INSERTED.STOCK = '1';
END;
