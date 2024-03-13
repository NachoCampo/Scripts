/*Al momento de generar una Factura en referencia a un Remito, por más de que ese remito se facture parcialmente, se cambian todas las cantidades pendientes a 0.000000 y el estado del remito pasa a ser "F" = Finalizado.. Dejando inutilizable el remito en cuestión*/
CREATE TRIGGER Tr_CerrarRemito
ON GVA54
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    -- Actualizar el estado del remito a 'F' y la cantidad pendiente a 0 en STA14 y STA20
    UPDATE STA14
    SET ESTADO_MOV = 'F'
    FROM STA14
    INNER JOIN inserted AS i ON STA14.NCOMP_IN_S = i.NCOMP_IN_S 
    WHERE STA14.TCOMP_IN_S = 'RE';

    UPDATE STA20
    SET CANT_PEND = 0.0000000
    FROM STA20
    INNER JOIN inserted AS i ON STA20.NCOMP_IN_S = i.NCOMP_IN_S
    WHERE STA20.TCOMP_IN_S = 'RE';
END;
