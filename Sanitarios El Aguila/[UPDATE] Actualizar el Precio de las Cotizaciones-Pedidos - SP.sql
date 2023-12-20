WITH PreciosActualizados AS (
    SELECT
     GVA17.COD_ARTICU, --Busco el Cod. Articulo de la tabla de Precios.
     GVA21.N_LISTA, -- Busco La Lista de Precios usada en el Pedido.
     MAX(GVA17.FECHA_MODI) AS FECHA_ACTUALIZACION, -- Obtenemos la fecha de actualización más reciente
     GVA17.PRECIO AS PRECIO_ACTUALIZADO --Traigo el precio más actualizado de esa Lista y de ese Artículo
    FROM GVA17
    INNER JOIN GVA10 ON GVA17.NRO_DE_LIS = GVA10.NRO_DE_LIS 
	INNER JOIN GVA21 ON GVA21.N_LISTA = GVA10.NRO_DE_LIS
    GROUP BY GVA17.COD_ARTICU, GVA21.N_LISTA, GVA17.PRECIO
) --Esta Subquery trae el precio más actualizado
UPDATE GVA03
SET GVA03.PRECIO = PA.PRECIO_ACTUALIZADO --Coloco en el renglon del pedido el Precio más actualizado de la Subquery
FROM GVA03
INNER JOIN GVA37 ON GVA37.NRO_PEDIDO = GVA03.NRO_PEDIDO --Hago la union entre el Numero de Pedido de la cotización y el Pedido generado.
INNER JOIN GVA21 ON GVA21.NRO_PEDIDO = GVA03.NRO_PEDIDO --Hago la union entre el Nro. Pedido del renglon con el encabezado.
INNER JOIN PreciosActualizados PA ON GVA03.COD_ARTICU = PA.COD_ARTICU AND GVA21.N_LISTA = PA.N_LISTA --Hago la union entre el articulo y lista del Precio actualizado y el renglon y lista del pedido.
INNER JOIN GVA08 ON GVA08.N_COTIZ = GVA37.N_COTIZ
WHERE GVA21.ESTADO IN ('1','2') --Filtro por los pedidos "Ingresados" y "Aprobados", solo esos afectará.
    AND GVA03.CANT_PEN_F <> '0.0000000' --Afecta aquellos pedidos que tengan cantidades pendientes de facturar. Si tenemos un pedido que no se facturo completamente, se actualizará el valor de esa unidad pendiente.
    AND (
        -- Caso 1: La cotización se hizo en un día distinto al de la fecha del pedido
        GVA08.FECHA_ALTA <> GVA21.FECHA_PEDI 
    OR 
        -- Caso 2: La cotización y el pedido son del mismo día, pero han pasado más de 6 horas.
        (GVA08.FECHA_ALTA = GVA21.FECHA_PEDI AND DATEDIFF(MINUTE, CONVERT(DATETIME, GVA08.FECHA_ALTA + ' ' + STUFF(STUFF(GVA08.HORA, 5, 0, ':'), 3, 0, ':'), 120), GETDATE() ) >= 360 ));-- La siguiente condición filtra registros donde la diferencia en minutos entre la fecha/hora de alta y la fecha/hora actual es mayor o igual a 360 (6 horas). Esto se hace para incluir o excluir registros según si ha pasado más de 360 (6 horas) minutos desde cierto evento registrado en la tabla de Cotizaciones.
