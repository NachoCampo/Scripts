CREATE PROCEDURE sp_ActualizarCantidades
AS
BEGIN
    SET NOCOUNT ON;

    -- Actualiza GVA03 en el artículo A000001 colocandolo en '1.0000000' si falta algún artículo otro artículo facturarse en GVA53 para el NRO_PEDIDO. Es decir, compara COD_ARTICU de GVA53 y GVA03. Si hay un artículo que no se facturo, cambia las cantidades pendientes en la GVA03.
    UPDATE GVA03
    SET
        CANT_A_FAC = CASE WHEN GVA03.COD_ARTICU = 'A000001' THEN 1.0000000 ELSE 0.0000000 END,
        CANT_PEN_F = CASE WHEN GVA03.COD_ARTICU = 'A000001' THEN 1.0000000 ELSE 0.0000000 END
    FROM GVA03
    INNER JOIN GVA55 ON GVA03.NRO_PEDIDO = GVA55.NRO_PEDIDO
    WHERE
        GVA03.COD_ARTICU = 'A000001' --Filtra solamente por el "A000001"
        AND GVA03.CANT_PEN_F = 0.0000000 --Lo actualiza cuando esta en 0.000000
        AND EXISTS (
            SELECT 1
            FROM GVA53
            WHERE GVA53.N_COMP = GVA55.N_COMP
              AND GVA53.T_COMP = GVA55.T_COMP
              AND GVA53.COD_ARTICU = GVA03.COD_ARTICU
        );

    -- Verifica que si el COD_ARTICU de la GVA03 ya fue facturado, le pone las cantidades en 0.000000 para que el facturador al tratar de volver a seleccionar el pedido no traiga esos renglones.. Esto no incluye al "A000001".
    UPDATE GVA03
    SET
        CANT_A_FAC = 0.0000000,
        CANT_PEN_F = 0.0000000
    FROM GVA03
    INNER JOIN GVA55 ON GVA03.NRO_PEDIDO = GVA55.NRO_PEDIDO
    INNER JOIN GVA53 ON GVA53.N_COMP = GVA55.N_COMP
                   AND GVA53.T_COMP = GVA55.T_COMP
                   AND GVA53.COD_ARTICU = GVA03.COD_ARTICU
    WHERE
        GVA03.CANT_PEN_F > 0.0000000
		AND
		GVA03.COD_ARTICU != 'A000001' --Excluye el artículo de "Servicio de Envio".
END;