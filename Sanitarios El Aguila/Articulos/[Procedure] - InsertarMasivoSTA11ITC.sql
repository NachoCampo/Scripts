/*Los campos del clasificador son estos 6:
CA_TEXT_1693335516000 --Moneda
CA_CLAS_BONIFICACION --Bonificacion
CA_CLAS_MARCA --Marca
CA_CLAS_FAMILIA --Familia
CA_CLAS_MATERIAL --Material
CA_CLAS_TIPO --TIPO
*/

/*Se arma un Procedure en la base de datos para hacer el "insert" de cada uno de los clasificadores*/
-- Crear un procedimiento almacenado llamado InsertarMasivoSTA11ITC
CREATE PROCEDURE InsertarMasivoSTA11ITC
AS
BEGIN
    -- Inserción para CA_TEXT_1693335516000 (Moneda)
    INSERT INTO STA11ITC (FILLER, CODE, IDFOLDER, CODEA, ROW_VERSION, ID_STA11)
    SELECT
        '',
        COD_ARTICU,
        CAMPOS_ADICIONALES.value('(/CAMPOS_ADICIONALES/CA_TEXT_1693335516000)[1]', 'nvarchar(max)'),
        COD_ARTICU,
        NULL,
        ID_STA11
    FROM Sta11
    WHERE CAMPOS_ADICIONALES.exist('/CAMPOS_ADICIONALES/CA_TEXT_1693335516000') = 1
	AND CAMPOS_ADICIONALES.value('(/CAMPOS_ADICIONALES/CA_TEXT_1693335516000)[1]', 'nvarchar(max)') <> '';

    -- Inserción para CA_CLAS_BONIFICACION (Bonificacion)
    INSERT INTO STA11ITC (FILLER, CODE, IDFOLDER, CODEA, ROW_VERSION, ID_STA11)
    SELECT
        '',
        COD_ARTICU,
        CAMPOS_ADICIONALES.value('(/CAMPOS_ADICIONALES/CA_CLAS_BONIFICACION)[1]', 'nvarchar(max)'),
        COD_ARTICU,
        NULL,
        ID_STA11
    FROM Sta11
    WHERE CAMPOS_ADICIONALES.exist('/CAMPOS_ADICIONALES/CA_CLAS_BONIFICACION') = 1
	AND CAMPOS_ADICIONALES.value('(/CAMPOS_ADICIONALES/CA_CLAS_BONIFICACION)[1]', 'nvarchar(max)') <> '';

    -- Inserción para CA_CLAS_MARCA (Marca)
    INSERT INTO STA11ITC (FILLER, CODE, IDFOLDER, CODEA, ROW_VERSION, ID_STA11)
    SELECT
        '',
        COD_ARTICU,
        CAMPOS_ADICIONALES.value('(/CAMPOS_ADICIONALES/CA_CLAS_MARCA)[1]', 'nvarchar(max)'),
        COD_ARTICU,
        NULL,
        ID_STA11
    FROM Sta11
    WHERE CAMPOS_ADICIONALES.exist('/CAMPOS_ADICIONALES/CA_CLAS_MARCA') = 1
	AND CAMPOS_ADICIONALES.value('(/CAMPOS_ADICIONALES/CA_CLAS_MARCA)[1]', 'nvarchar(max)') <> '';

    -- Inserción para CA_CLAS_FAMILIA (Familia)
    INSERT INTO STA11ITC (FILLER, CODE, IDFOLDER, CODEA, ROW_VERSION, ID_STA11)
    SELECT
        '',
        COD_ARTICU,
        CAMPOS_ADICIONALES.value('(/CAMPOS_ADICIONALES/CA_CLAS_FAMILIA)[1]', 'nvarchar(max)'),
        COD_ARTICU,
        NULL,
        ID_STA11
    FROM Sta11
    WHERE CAMPOS_ADICIONALES.exist('/CAMPOS_ADICIONALES/CA_CLAS_FAMILIA') = 1
	AND CAMPOS_ADICIONALES.value('(/CAMPOS_ADICIONALES/CA_CLAS_FAMILIA)[1]', 'nvarchar(max)') <> '';

    -- Inserción para CA_CLAS_MATERIAL (Material)
    INSERT INTO STA11ITC (FILLER, CODE, IDFOLDER, CODEA, ROW_VERSION, ID_STA11)
    SELECT
        '',
        COD_ARTICU,
        CAMPOS_ADICIONALES.value('(/CAMPOS_ADICIONALES/CA_CLAS_MATERIAL)[1]', 'nvarchar(max)'),
        COD_ARTICU,
        NULL,
        ID_STA11
    FROM Sta11
    WHERE CAMPOS_ADICIONALES.exist('/CAMPOS_ADICIONALES/CA_CLAS_MATERIAL') = 1
	AND CAMPOS_ADICIONALES.value('(/CAMPOS_ADICIONALES/CA_CLAS_MATERIAL)[1]', 'nvarchar(max)') <> '';

    -- Inserción para CA_CLAS_TIPO (TIPO)
    INSERT INTO STA11ITC (FILLER, CODE, IDFOLDER, CODEA, ROW_VERSION, ID_STA11)
    SELECT
        '',
        COD_ARTICU,
        CAMPOS_ADICIONALES.value('(/CAMPOS_ADICIONALES/CA_CLAS_TIPO)[1]', 'nvarchar(max)'),
        COD_ARTICU,
        NULL,
        ID_STA11
    FROM Sta11
    WHERE CAMPOS_ADICIONALES.exist('/CAMPOS_ADICIONALES/CA_CLAS_TIPO') = 1
	AND CAMPOS_ADICIONALES.value('(/CAMPOS_ADICIONALES/CA_CLAS_TIPO)[1]', 'nvarchar(max)') <> '';

END;


-- Ejecutar el procedimiento almacenado creado arriba
Begin Tran
EXEC InsertarMasivoSTA11ITC
Rollback
--commit

