CREATE PROCEDURE ActualizarDescargaNegativoVentas
AS
BEGIN
    SET NOCOUNT ON;

    -- Actualizar DESCARGA_NEGATIVO_VENTAS a 1 para los códigos de artículos que comienzan con 'F00%'
    UPDATE STA11
    SET DESCARGA_NEGATIVO_VENTAS = 1
    WHERE COD_ARTICU LIKE 'F00%';

    -- Actualizar DESCARGA_NEGATIVO_VENTAS a 1 para los códigos de artículos que comienzan con 'C00%'
    UPDATE STA11
    SET DESCARGA_NEGATIVO_VENTAS = 1
    WHERE COD_ARTICU LIKE 'C00%';

    -- Mostrar mensaje de éxito
    SELECT 'Se ha actualizado DESCARGA_NEGATIVO_VENTAS a 1 para los códigos de artículos que comienzan con ''F00%'' y ''C00%''.';
END;
