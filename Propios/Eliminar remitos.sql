/*Fava Depuracion 2023*/
Select * from STA14 where TCOMP_IN_S = 'RE' and ESTADO_MOV in ('A' , 'P') order by FECHA_MOV --Tienen 1729 remitos "Anulados" y "Pendientes" desde 02-05-2020 al 20-07-2023
Select * from sta14 where TCOMP_IN_S = 'RE' and ESTADO_MOV = 'F' order by FECHA_MOV --Tienen 341.360 remitos "Facturados" desde el 02-05-2020 al 20-07-2023

--Se deshabilitan los triggers y se eliminan remitos. También con esto tocas SALDO DE STOCK (STA19)
Disable Trigger [After_insert_sta14] On Sta14
Go

Delete From sta14
Where  fecha_mov < '2021-05-01'
   And tcomp_in_s = 'RE' --Hay que agregar estado de los remitos a eliminar.
Go

Disable Trigger [After_insert_sta20] On Sta20
Go

Delete From sta20
Where  Not Exists ( Select *
                From   sta14
                Where  sta14.ncomp_in_s = sta20.ncomp_in_s
                   And sta14.tcomp_in_s = sta20.tcomp_in_s )
Go --Acá se eliminan renglones de stock huerfanos, es decir que no tienen encabezado de stock y que se eliminaron arriba.


Enable Trigger [After_insert_sta14] On Sta14
Go

Enable Trigger [After_insert_sta20] On Sta20
Go