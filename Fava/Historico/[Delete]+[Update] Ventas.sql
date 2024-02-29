/* Primero de todo, hay un asiento inconsistente en la tabla ASIENTO_COMPROBANTE_GVque hay que eliminar para que funcione la "Generación de Asientos"*/
delete from ASIENTO_COMPROBANTE_GV where NCOMP_IN_V like '%1.57659e+006%'

/*Luego de hacer el Pasaje a Historico de todos los comprobantes del 01/01/2013 al 30/04/2022, van a quedar 23 comprobantes sin pasar.. 
Con esos 23 comprobantes, lo que podemos hacer facilmente es:
* Cambiar la Fecha de Cierre del módulo Ventas, Stock y Tesoreria al 01-01-2010
* Hacer Recomposición de Saldos al 01-01-2010 modificando fecha de cierre saldos.
* Cambiar la Fecha de Cierre de Cuentas Corrientes al 01-01-2010.

* Luego de esto, cambiar esos 23 comprobantes que no pasan en las tablas:
- GVA12 = Contabiliz = '0', CONTFISCAL = '0'
*/

UPDATE GVA12 
SET CONTFISCAL = '0', CONTABILIZ = '0' WHERE ID_GVA12 IN (
sELECT ID_GVA12 FROM GVA12 WHERE FECHA_EMIS >= '01/01/2013 00:00:00' And  FECHA_EMIS <= '30/04/2022 00:00:00' AND ESTADO = '***')

/* Luego de esto, cambiar los datos en "Asiento_Comprobante_GV":
 CONTABILIZADO = 'N', TRANSFERIDO_CN = 'N' de esos mismos NCOMP_IN_V de arriba
 */
 
 -- Desde Anulación de Comprobantes eliminar esos 23 comprobantes que quedaron del Pasaje a Historico.
 
 -- Volver a colocar los valores correspondientesn Fecha de Cierre, Recomposición de Saldos y Cierre de Cuentas Corrientes.
 
 /*De esta manera queda depurado el módulo de Ventas al 30/04/2022*/
 