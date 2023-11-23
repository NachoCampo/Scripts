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


/*Se actualiza el script y se coloca una validación de fecha y hora para el pedido*/

/*Identificación de Precios Actualizados:
Primero de todo, busca los precios más recientes de los artículos en la tabla de precios, considerando la lista de precios y la fecha de actualización.

Actualización de Precios en Pedidos:
Luego de esto, actualiza automáticamente los precios en los renglones de pedidos con los precios más recientes identificados en el paso anterior.

Condiciones de Actualización:
La actualización se aplica a pedidos en estados "Ingresado" o "Aprobado”. Si el pedido ya se facturo y también se remitió por completo tendrá el estado “Cumplido” y no se actualizará el precio, para los siguientes estados del pedido también influirá.
Se considera la fecha de emisión de la cotización y la fecha del pedido para determinar si la actualización es necesaria:
-	Si la cotización se genera una fecha distinta a la del pedido, el precio del pedido se actualiza sin respetar los 30 minutos.
-	Si la cotización se emitió el mismo día que el pedido y ha pasado más de 30 minutos desde la emisión de la cotización.
*/

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
    --AND GVA03.CANT_PEN_F <> '0.0000000' --Afecta aquellos pedidos que tengan cantidades pendientes de facturar. Si tenemos un pedido que no se facturo completamente, se actualizará el valor de esa unidad pendiente.
    AND (
        -- Caso 1: La cotización se hizo en un día distinto al de la fecha del pedido
        GVA08.FECHA_ALTA <> GVA21.FECHA_PEDI 
        OR 
        -- Caso 2: La cotización y el pedido son del mismo día, pero han pasado más de 30 minutos
        (GVA08.FECHA_ALTA = GVA21.FECHA_PEDI 
		AND DATEDIFF(MINUTE, CONVERT(DATETIME, GVA21.FECHA_PEDI + ' ' + STUFF(STUFF(GVA21.HORA, 5, 0, ':'), 3, 0, ':'), 120),
        GETDATE() -- Hora y fecha actual
    ) >= 30 )
	);