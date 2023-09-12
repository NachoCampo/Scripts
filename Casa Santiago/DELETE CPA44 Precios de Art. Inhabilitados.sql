/*CPA44: Precios por Proveedor*/
--SELECT:
Select CPA44.COD_ARTICU, STA11.DESCRIPCIO from CPA44 
	Join STA11 on
		CPA44.COD_ARTICU = STA11.COD_ARTICU
Where STA11.PERFIL = 'N' --93

--DELETE
Begin tran
DELETE FROM CPA44
WHERE EXISTS (
    SELECT 1
    FROM STA11
    WHERE CPA44.COD_ARTICU = STA11.COD_ARTICU
    AND STA11.PERFIL = 'N')
commit 