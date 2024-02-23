/*Selects para identificar que artículos tienen Cod. Proveedor en la Desc. Adicional*/
--Tienen numeros en Descripcion Adicional
Select cod_Articu, DESC_ADIC, SINONIMO from STA11 where SINONIMO = '' 
and PATINDEX('%[0-9]%', DESC_ADIC) > 0

--No tienen numeros en Descripcion Adicional
Select cod_Articu, DESC_ADIC, SINONIMO from STA11 where SINONIMO = '' 
and PATINDEX('%[0-9]%', DESC_ADIC) = 0


/*Select para identificar longitudes del Cod. Proveedor a pasar al Sinonimo (15 caracteres maximo)*/
--Longitudes del Dato para pasar a Sinonimo.
SELECT cod_articu, desc_adic,
    SUBSTRING(DESC_ADIC, PATINDEX('%[0-9]%', DESC_ADIC), LEN(DESC_ADIC)) AS [Dato],
    LEN(SUBSTRING(DESC_ADIC, PATINDEX('%[0-9]%', DESC_ADIC), LEN(DESC_ADIC))) AS [LongitudDato]
FROM STA11
WHERE PATINDEX('%[0-9]%', DESC_ADIC) > 0
ORDER BY [LongitudDato] DESC --4949



/*Update para pasar Cod. Proveedor al STA11.SINONIMO y al CPA15.COD_SINONI*/
Begin Tran
UPDATE STA11
SET SINONIMO = SUBSTRING(DESC_ADIC, PATINDEX('%[0-9]%', DESC_ADIC), 15)
WHERE PATINDEX('%[0-9]%', DESC_ADIC) > 0
    AND LEN(SUBSTRING(DESC_ADIC, PATINDEX('%[0-9]%', DESC_ADIC), LEN(DESC_ADIC))) <= 15 
--Commit
Rollback

Begin Tran
UPDATE CPA15
SET COD_SINONI = SUBSTRING(STA11.DESC_ADIC, PATINDEX('%[0-9]%', STA11.DESC_ADIC), 15)
FROM STA11
WHERE PATINDEX('%[0-9]%', STA11.DESC_ADIC) > 0
    AND LEN(SUBSTRING(STA11.DESC_ADIC, PATINDEX('%[0-9]%', STA11.DESC_ADIC), LEN(STA11.DESC_ADIC))) <= 15
    AND CPA15.COD_ARTICU = STA11.COD_ARTICU
--Commit
Rollback



/*Blanquear los datos del Campo Adicional a vacios*/
Update STA11 set CAMPOS_ADICIONALES = '
<CAMPOS_ADICIONALES>
  <CA_TIPO></CA_TIPO>
  <CA_SECCION></CA_SECCION>
  <CA_MARCA></CA_MARCA>
</CAMPOS_ADICIONALES>
' --(7335 rows affected)



