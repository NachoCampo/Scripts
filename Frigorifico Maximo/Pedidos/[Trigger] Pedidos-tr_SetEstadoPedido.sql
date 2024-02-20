/*El trigger lo que hace es cambiar el estado del pedido a 2 para evitar que nazca en 3*/
CREATE TRIGGER tr_SetEstadoPedido
ON GVA21
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Actualizar el estado a '2' después de cada inserción en GVA21
    UPDATE GVA21
    SET ESTADO = '2'
    WHERE NRO_PEDIDO IN (SELECT NRO_PEDIDO FROM INSERTED);

END;
