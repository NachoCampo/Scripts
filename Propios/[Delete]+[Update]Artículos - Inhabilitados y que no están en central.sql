/**Borra Articulos que ya no existen en la base de datos y están en central*/
begin tran
delete CTA_SALDO_ARTICULO_DEPOSITO where ID_CTA_ARTICULO in (
Select ID_CTA_ARTICULO from CTA_ARTICULO where COD_ARTICULO not in (Select COD_ARTICU from STA11))
delete CTA_ARTICULO where COD_ARTICULO not in (Select cod_articu from STA11)
Commit

/*Coloca en 0.000000 los saldos de los artículos inhabilitados en central*/
begin tran
update CTA_SALDO_ARTICULO_DEPOSITO set CANTIDAD_STOCK = '0.0000000' where id_cta_articulo in  (
Select CSAD.ID_CTA_ARTICULO  from CTA_SALDO_ARTICULO_DEPOSITO CSAD
	JOIN CTA_ARTICULO ON
CTA_ARTICULO.ID_CTA_ARTICULO = CSAD.ID_CTA_ARTICULO 
	join STA11 on
	CTA_ARTICULO.COD_ARTICULO = STA11.COD_ARTICU
WHERE STA11.PERFIL = 'N')
commit
