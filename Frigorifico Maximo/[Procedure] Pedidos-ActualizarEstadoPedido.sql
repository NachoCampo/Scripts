CREATE PROCEDURE ActualizarEstadoPedido
AS
BEGIN
    SET NOCOUNT ON;

	UPDATE GVA21
		SET ESTADO = '4' -- Cambia el estado a "Cerrado".
			WHERE NRO_PEDIDO IN (
				SELECT GVA55.NRO_PEDIDO -- Revisa que ya se haya facturado.
    FROM GVA55
		WHERE EXISTS (
			SELECT 1
			FROM GVA03
				WHERE GVA03.NRO_PEDIDO = GVA55.NRO_PEDIDO -- Revisa Nro. Pedido del Renglón con la relación GVA55.
				AND GVA03.COD_ARTICU = 'A000001' -- Revisa que el renglón tenga el Servicio.
				AND GVA03.CANT_PEN_F = '1.0000000' -- Para 'A000001', la cantidad pendiente debe ser 1.0000000.
    )
		AND NOT EXISTS (
			SELECT 1
			FROM GVA03
				WHERE GVA03.NRO_PEDIDO = GVA55.NRO_PEDIDO -- Revisa Nro. Pedido del Renglón con la relación GVA55.
				AND GVA03.COD_ARTICU != 'A000001' -- Excluye 'A000001' para los demás artículos.
				AND GVA03.CANT_PEN_F != '0.0000000' -- Revisa que la cantidad pendiente de facturar esté en 0.0000000.
    )
);

END;


--Ejecución del Procedimiento.
EXEC ActualizarEstadoPedido;
