/*Este procedure lo que hace es cambiar el estado de los pedidos a "Cerrados" de todos aquellos que esten con estado "Pendiente" (Estado = 2), no se hayan facturado y haya pasado dos dias al menos de la generación del pedido*/
CREATE PROCEDURE CambiarEstadoPedidosSinFacturar
AS
BEGIN
    SET NOCOUNT ON;

    -- Cambiar el estado de los pedidos que cumplan las condiciones
    UPDATE GVA21
    SET ESTADO = 4
    WHERE ESTADO <> 4 -- Evitar actualizar los que ya tengan el estado 4
    AND DATEDIFF(DAY, FECHA_PEDI, GETDATE()) >= 2 -- Han pasado al menos 2 días desde la fecha de pedido
    AND NRO_PEDIDO NOT IN (SELECT NRO_PEDIDO FROM GVA55); -- No está en la tabla de pedidos facturados

    -- Mostrar mensaje de éxito
    SELECT 'Se han actualizado los estados de los pedidos según las condiciones especificadas.';
END;


--Ejecuta el Procedure
EXEC CambiarEstadoPedidosSinFacturar;