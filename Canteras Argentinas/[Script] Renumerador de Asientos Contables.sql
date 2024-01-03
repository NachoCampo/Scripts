/*Script que renumera y reordena la tabla ASIENTO_ANALITICO_CN*/
-- Crear una tabla temporal para almacenar la nueva numeración
SELECT 
    ROW_NUMBER() OVER (ORDER BY CASE WHEN ID_TIPO_ASIENTO = 19 THEN 0 ELSE 1 END, FECHA_ASIENTO) AS New_Nro_Asiento,
    ROW_NUMBER() OVER (ORDER BY CASE WHEN ID_TIPO_ASIENTO = 19 THEN 0 ELSE 1 END, FECHA_ASIENTO) AS New_Nro_Interno,
    ID_ASIENTO_ANALITICO_CN,
    ID_TIPO_ASIENTO,
    FECHA_ASIENTO
INTO #TEMP_ASIENTO
FROM ASIENTO_ANALITICO_CN;

-- Actualizar la tabla original con la nueva numeración
UPDATE ASIENTO_ANALITICO_CN
SET 
    nro_asiento_analitico = T.New_Nro_Asiento,
    nro_interno_analitico = T.New_Nro_Interno
FROM ASIENTO_ANALITICO_CN A
JOIN #TEMP_ASIENTO T ON A.ID_ASIENTO_ANALITICO_CN = T.ID_ASIENTO_ANALITICO_CN;

-- Obtener el último número generado en ASIENTO_ANALITICO_CN
DECLARE @UltimoNroAsiento INT;
SELECT @UltimoNroAsiento = MAX(nro_asiento_analitico) FROM ASIENTO_ANALITICO_CN;

-- Actualizar PROVIDER_NRO_ASIENTO_CORRELATIVO con el último número generado
UPDATE PROVIDER_NRO_ASIENTO_CORRELATIVO
SET ULTIMO_NRO_ASIENTO = @UltimoNroAsiento;
 
-- Eliminar la tabla temporal
DROP TABLE #TEMP_ASIENTO;
