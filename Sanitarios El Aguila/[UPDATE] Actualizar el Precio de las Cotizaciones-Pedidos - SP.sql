/* Actualiza los renglones de las cotizaciones con el precio más actualizado con el Precio de Venta*/
CREATE PROCEDURE ActualizarPrecios
AS
BEGIN
WITH PreciosActualizados AS (
    SELECT
     GVA17.COD_ARTICU, --Busco el Cod. Articulo de la tabla de Precios.
      GVA08.NRO_DE_LIS, -- Busco La Lista de Precios usada en la cotizacion.
     MAX(GVA17.FECHA_MODI) AS FECHA_ACTUALIZACION, -- Obtenemos la fecha de actualización más reciente
      GVA17.PRECIO AS PRECIO_ACTUALIZADO --Traigo el precio más actualizado de esa Lista y de ese Artículo
    FROM GVA17
    INNER JOIN GVA10 ON GVA17.NRO_DE_LIS = GVA10.NRO_DE_LIS
	INNER JOIN GVA08 ON GVA08.NRO_DE_LIS = GVA10.NRO_DE_LIS
    GROUP BY GVA17.COD_ARTICU, GVA08.NRO_DE_LIS, GVA17.PRECIO
) --Esta Subquery trae el precio más actualizado
UPDATE GVA09
SET GVA09.PRECIO = PA.PRECIO_ACTUALIZADO, GVA09.PRECIO_LISTA = PA.PRECIO_ACTUALIZADO --Coloco en el renglon del pedido el Precio más actualizado de la Subquery
FROM GVA09
INNER JOIN GVA08 ON GVA08.N_COTIZ = GVA09.N_COTIZ 
INNER JOIN PreciosActualizados PA ON GVA09.COD_ARTICU = PA.COD_ARTICU AND GVA08.NRO_DE_LIS = PA.NRO_DE_LIS
WHERE GVA08.ESTADO = '3'
END



/* Actualiza los renglones de los pedidos con el precio más actualizado de la tabla de Precios de Venta*/
CREATE PROCEDURE ActualizarPrecios
AS
BEGIN
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
WHERE GVA21.ESTADO IN ('1','2') --Filtro por los pedidos "Ingresados" y "Aprobados", solo esos afectará.
AND GVA03.CANT_PEN_F <> '0.0000000' --Solo va a actualizar renglones de pedidos con cantidades pendientes de facturación.
END
