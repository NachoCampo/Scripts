--Este script que armamos cambia la "A" por una "a" en los comprobantes del Punto de Venta "00008". Solamente hay que poner el prefijo anterior y el nuevo.
DECLARE @OldPrefix NVARCHAR(20) = 'A';
DECLARE @NewPrefix NVARCHAR(20) = 'a';
DECLARE @StartNumber NVARCHAR(20) = '0000800000016'; -- Número de comprobante de inicio
DECLARE @EndNumber NVARCHAR(20) = '0000800004880';   -- Número de comprobante final

-- Actualizar las tablas excepto GVA12
UPDATE HISTORIAL_CUENTAS_CORRIENTES
SET N_COMP = REPLACE(N_COMP, @OldPrefix, @NewPrefix)
WHERE N_COMP BETWEEN CONCAT(@OldPrefix, @StartNumber) AND CONCAT(@OldPrefix, @EndNumber);

UPDATE HISTORIAL_CUENTAS_CORRIENTES
SET N_COMP_CAN = REPLACE(N_COMP_CAN, @OldPrefix, @NewPrefix)
WHERE N_COMP_CAN BETWEEN CONCAT(@OldPrefix, @StartNumber) AND CONCAT(@OldPrefix, @EndNumber);

UPDATE GVA42
SET N_COMP = REPLACE(N_COMP, @OldPrefix, @NewPrefix)
WHERE N_COMP BETWEEN CONCAT(@OldPrefix, @StartNumber) AND CONCAT(@OldPrefix, @EndNumber);

UPDATE GVA_AUDITORIA_BAJA_COMPROBANTES
SET N_COMP = REPLACE(N_COMP, @OldPrefix, @NewPrefix)
WHERE N_COMP BETWEEN CONCAT(@OldPrefix, @StartNumber) AND CONCAT(@OldPrefix, @EndNumber);

UPDATE GVA131
SET N_COMP = REPLACE(N_COMP, @OldPrefix, @NewPrefix)
WHERE N_COMP BETWEEN CONCAT(@OldPrefix, @StartNumber) AND CONCAT(@OldPrefix, @EndNumber);

UPDATE STA14
SET N_COMP = REPLACE(N_COMP, @OldPrefix, @NewPrefix)
WHERE N_COMP BETWEEN CONCAT(@OldPrefix, @StartNumber) AND CONCAT(@OldPrefix, @EndNumber);

UPDATE GVA63
SET N_COMP = REPLACE(N_COMP, @OldPrefix, @NewPrefix)
WHERE N_COMP BETWEEN CONCAT(@OldPrefix, @StartNumber) AND CONCAT(@OldPrefix, @EndNumber);

UPDATE GVA53
SET N_COMP = REPLACE(N_COMP, @OldPrefix, @NewPrefix)
WHERE N_COMP BETWEEN CONCAT(@OldPrefix, @StartNumber) AND CONCAT(@OldPrefix, @EndNumber);

UPDATE GVA54
SET N_COMP = REPLACE(N_COMP, @OldPrefix, @NewPrefix)
WHERE N_COMP BETWEEN CONCAT(@OldPrefix, @StartNumber) AND CONCAT(@OldPrefix, @EndNumber);

-- Actualizar GVA12
UPDATE GVA12
SET N_COMP = CONCAT(@NewPrefix, RIGHT(N_COMP, LEN(N_COMP) - 1))
WHERE N_COMP BETWEEN CONCAT(@OldPrefix, @StartNumber) AND CONCAT(@OldPrefix, @EndNumber);
