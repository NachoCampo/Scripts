--Remitos TOCAS SALDO DE STOCK STA19

Disable Trigger [After_insert_sta14] On Sta14
Go

Delete From sta14
Where  fecha_mov < '2021-05-01'
   And tcomp_in_s = 'RE'
Go

Disable Trigger [After_insert_sta20] On Sta20
Go

Delete From sta20
Where  Not Exists ( Select *
                From   sta14
                Where  sta14.ncomp_in_s = sta20.ncomp_in_s
                   And sta14.tcomp_in_s = sta20.tcomp_in_s )
Go


Enable Trigger [After_insert_sta14] On Sta14
Go

Enable Trigger [After_insert_sta20] On Sta20
Go