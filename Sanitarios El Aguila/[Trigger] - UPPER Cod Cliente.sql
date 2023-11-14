/*Este trigger lo que hace es hacer un UPPER de los codigos de cliente que se dan de alta en el sistema en minusculas.. Se corre luego de que el alta fue hecha.*/


--Se crea el trigger de la GVA14 > ABM de Clientes
Create TRIGGER GVA14_UpperCod
ON GVA14
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Actualizar COD_CLIENT con UPPER
    UPDATE GVA14
    SET COD_CLIENT = UPPER(i.COD_CLIENT),
		COD_GVA14 = UPPER(i.COD_GVA14)
    FROM GVA14
    INNER JOIN inserted i ON GVA14.ID_GVA14 = i.ID_GVA14;
END;

--Se crea el trigger de DIRECCION_ENTREGA > Direcciones de Entrega
Create TRIGGER DIRECCION_ENTREGA_UpperCod
ON DIRECCION_ENTREGA
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Actualizar COD_CLIENTE con UPPER
    UPDATE DIRECCION_ENTREGA
    SET COD_CLIENTE = UPPER(i.COD_CLIENTE)
    FROM DIRECCION_ENTREGA
    INNER JOIN inserted i ON DIRECCION_ENTREGA.ID_GVA14 = i.ID_GVA14;
END;


--Se crea el trigger de la GVA14ITC > Clasificador
Create TRIGGER GVA14ITC_UpperCod
ON GVA14ITC
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Actualizar CODE con UPPER
    UPDATE GVA14ITC
    SET CODE = UPPER(i.CODE),
        CODEA = UPPER(i.CODEA)
    FROM GVA14ITC
    INNER JOIN inserted i ON GVA14ITC.ID_GVA14 = i.ID_GVA14;
END;


-- Se crea el trigger de la GVA27 > Contactos
Create TRIGGER GVA27_UpperCod
ON GVA27
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Actualizar COD_CLIENT con UPPER
    UPDATE GVA27
    SET COD_CLIENT = UPPER(i.COD_CLIENT)
    FROM GVA27
    INNER JOIN inserted i ON GVA27.ID_GVA14 = i.ID_GVA14;
END;
