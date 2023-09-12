/*Insertar la clasificación de Artículos en Tiribelli de forma masiva con respecto a la carpeta "Marca"*/

BEGIN TRAN
INSERT INTO STA11ITC (FILLER, CODE, IDFOLDER, CODEA, ROW_VERSION, ID_STA11)
SELECT
    '',
    COD_ARTICU,
    CAMPOS_ADICIONALES.value('(/CAMPOS_ADICIONALES/CA_MARCA)[1]', 'nvarchar(max)'),
    COD_ARTICU,
    NULL,
    ID_STA11
FROM Sta11
WHERE CAMPOS_ADICIONALES.value('(/CAMPOS_ADICIONALES/CA_MARCA)[1]', 'nvarchar(max)') IS NOT NULL
ROLLBACK
