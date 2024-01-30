CREATE PROCEDURE ActualizarEstadoPedido
AS
BEGIN
    SET NOCOUNT ON;

    -- Actualizar el estado en GVA21
    UPDATE GVA21
    SET ESTADO = '4' --Cambia el estado a "Cerrado".
    WHERE NRO_PEDIDO IN (
        SELECT GVA55.NRO_PEDIDO --Revisa que ya se haya facturado.
        FROM GVA55
        WHERE EXISTS (
            SELECT 1
            FROM GVA03
            WHERE GVA03.NRO_PEDIDO = GVA55.NRO_PEDIDO --Revisa Nro. Pedido del Renglón con la relación GVA55.
              AND GVA03.COD_ARTICU = 'A000001' --Revisa que el renglón tenga el Servicio.
              AND GVA03.CANT_PEN_F = '0.0000000' --Revisa que la cantidad pendiente de facturar este en 0.000000, eso quiere decir que ya se facturo.
        )
    );
    -- Fin del procedimiento
END;


--Ejecución del Procedimiento.
EXEC ActualizarEstadoPedido;
