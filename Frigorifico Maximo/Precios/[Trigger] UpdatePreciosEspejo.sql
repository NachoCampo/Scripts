/*Se arma un trigger en la GVA17 para duplicar los cambios de precios de una lista sobre otra y armar una lista espejo*/
CREATE TRIGGER Tr_UpdatePreciosEspejo
ON GVA17
AFTER UPDATE
AS
BEGIN
    -- Verificar si se actualizaron los precios en la lista de precios original (NRO_DE_LIS = 35)
    IF UPDATE(PRECIO) AND EXISTS (SELECT 1 FROM inserted WHERE NRO_DE_LIS = 35)
    BEGIN
        -- Actualizar los precios en la lista de precios espejo (NRO_DE_LIS = 135)
        UPDATE GVA17
        SET PRECIO = i.PRECIO, FECHA_MODI = i.FECHA_MODI  -- Utiliza los nuevos precios de la lista original y fecha modificación.
        FROM GVA17 AS g
        INNER JOIN inserted AS i ON g.COD_ARTICU = i.COD_ARTICU
        WHERE g.NRO_DE_LIS = 135; -- Actualizar solo en la lista de precios espejo
    END
END;
