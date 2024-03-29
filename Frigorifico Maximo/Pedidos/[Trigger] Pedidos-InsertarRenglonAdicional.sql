CREATE TRIGGER tr_InsertarReng lonAdicional
ON [MAXIVALENTI_SRL]..GVA21
AFTER INSERT
AS
BEGIN
DECLARE @NroPedido VARCHAR(14); -- Se declara la variable @NroPedido

-- Obtener el último Nro_Pedido insertado en la GVA21
SELECT TOP 1 @NroPedido = NRO_PEDIDO
FROM [MAXIVALENTI_SRL]..GVA21
ORDER BY ID_GVA21 DESC;

    -- Insertar el nuevo renglón en GVA03
    INSERT INTO [MAXIVALENTI_SRL]..[GVA03] 
    (
		CAN_EQUI_V,
        CANT_A_DES,
        CANT_A_FAC,
        CANT_PEDID,
        CANT_PEN_D,
        CANT_PEN_F,
        COD_ARTICU,
        DESCUENTO,
        N_RENGLON,
        NRO_PEDIDO,
        PEN_REM_FC,
        PEN_FAC_RE,
        PRECIO,
        TALON_PED,
        COD_CLASIF,
        CANT_A_DES_2,
        CANT_A_FAC_2,
        CANT_PEDID_2,
        CANT_PEN_D_2,
        CANT_PEN_F_2,
        PEN_REM_FC_2,
        PEN_FAC_RE_2,
        ID_MEDIDA_VENTAS,
        ID_MEDIDA_STOCK_2,
        ID_MEDIDA_STOCK,
        UNIDAD_MEDIDA_SELECCIONADA,
        COD_ARTICU_KIT,
        RENGL_PADR,
        PROMOCION,
        PRECIO_ADICIONAL_KIT,
        KIT_COMPLETO,
        INSUMO_KIT_SEPARADO,
        PRECIO_LISTA,
        PRECIO_BONIF,
        DESCUENTO_PARAM,
        PRECIO_FECHA,
        FECHA_MODIFICACION_PRECIO,
        USUARIO_MODIFICACION_PRECIO,
        TERMINAL_MODIFICACION_PRECIO,
        ID_NEXO_PEDIDOS_RENGLON_ORDEN,
        CANT_A_DES_EXPORTADA,
        CANT_A_FAC_EXPORTADA,
        CANT_A_DES_2_EXPORTADA,
        CANT_A_FAC_2_EXPORTADA
    )
    SELECT
		1.0000000 AS CAN_EQUI_V,
        1.0000000 AS CANT_A_DES,
        1.0000000 AS CANT_A_FAC,
        1.0000000 AS CANT_PEDID,
        1.0000000 AS CANT_PEN_D,
        1.0000000 AS CANT_PEN_F,
        'A000001' AS COD_ARTICU,
        0.0000000 AS DESCUENTO,
        COALESCE(MAX(N_RENGLON), 0) + 1 AS N_RENGLON, --Busca el mayor numero de renglón insertado y coloca el +1, o bien le coloca el "1" en caso de que este en cero.
        @NroPedido AS NRO_PEDIDO, --Trae el Nro. Pedido de la primer consulta donde lo obtiene de la variable.
        0.0000000 AS PEN_REM_FC,
        0.0000000 AS PEN_FAC_RE,
        0.0100000 AS PRECIO,
        8 AS TALON_PED, --Revisar el Talonario de Pedidos por cada base.
        '' AS COD_CLASIF,
        0.0000000 AS CANT_A_DES_2,
        0.0000000 AS CANT_A_FAC_2,
        0.0000000 AS CANT_PEDID_2,
        0.0000000 AS CANT_PEN_D_2,
        0.0000000 AS CANT_PEN_F_2,
        0.0000000 AS PEN_REM_FC_2,
        0.0000000 AS PEN_FAC_RE_2,
        3 AS ID_MEDIDA_VENTAS,
        NULL AS ID_MEDIDA_STOCK_2,
        3 AS ID_MEDIDA_STOCK, --Colocar el ID_MEDIDA_STOCK de "Sinunidad"
        'V' AS UNIDAD_MEDIDA_SELECCIONADA,
        '' AS COD_ARTICU_KIT,
        0 AS RENGL_PADR,
        0 AS PROMOCION,
        0.0000000 AS PRECIO_ADICIONAL_KIT,
        0 AS KIT_COMPLETO,
        0 AS INSUMO_KIT_SEPARADO,
        0.0100000 AS PRECIO_LISTA,
        0.0100000 AS PRECIO_BONIF,
        0.0000000 AS DESCUENTO_PARAM,
        NULL AS PRECIO_FECHA,
        NULL AS FECHA_MODIFICACION_PRECIO,
        NULL AS USUARIO_MODIFICACION_PRECIO,
        NULL AS TERMINAL_MODIFICACION_PRECIO,
        0 AS ID_NEXO_PEDIDOS_RENGLON_ORDEN,
        0.0000000 AS CANT_A_DES_EXPORTADA,
        0.0000000 AS CANT_A_FAC_EXPORTADA,
        0.0000000 AS CANT_A_DES_2_EXPORTADA,
        0.0000000 AS CANT_A_FAC_2_EXPORTADA
    FROM
        [MAXIVALENTI_SRL]..[GVA03]
    WHERE
        NRO_PEDIDO = @NroPedido;
END;
