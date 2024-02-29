/*Se crea un PROCEDURE que todos los días a las 00.01 HS se habilitan nuevamente los artículos para que puedan volver a ser utilizados*/
CREATE PROCEDURE [dbo].[SP_HABILITA_ESCALA]  
AS  
BEGIN  
    -- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.  
    SET NOCOUNT ON;  
  
    -- Actualización de STA11 para habilitar el perfil 'V' y las unidades de medida de AFIP que al inhabilitar se borran.  
    UPDATE STA11  
    SET   
        PERFIL = 'V',  
        AFIP_UM_S = '7',  
        AFIP_UM_V = '7',  
        ID_UNIDAD_MEDIDA_AFIP_UM_S = '8',  
        ID_UNIDAD_MEDIDA_AFIP_UM_V = '8'   
    WHERE   
        /*COD_ARTICU LIKE 'LCKC01%'  
        OR COD_ARTICU LIKE 'LCKG01%'  
        OR COD_ARTICU LIKE 'VSOM01%'  
        OR COD_ARTICU LIKE 'VMCL01%'  
        OR COD_ARTICU LIKE 'AMSOM1%'  
        OR COD_ARTICU LIKE 'AMMSL1%'  
        OR COD_ARTICU LIKE 'AMMCL1%'  
        OR COD_ARTICU LIKE 'AZSOM1%'  
        OR COD_ARTICU LIKE 'AZMSL1%'  
        OR COD_ARTICU LIKE 'AZMCL1%'  
        OR COD_ARTICU LIKE 'MMSL01%'  
        OR COD_ARTICU LIKE 'MMCL01%'  
        OR COD_ARTICU LIKE 'MSOM01%'  
        OR COD_ARTICU LIKE 'NMCL01%'  
        OR COD_ARTICU LIKE 'NSOM01%'  
        OR COD_ARTICU LIKE 'CMT001%'*/  
  STA11.COD_ARTICU LIKE 'LCKG01%'  
  OR STA11.COD_ARTICU LIKE 'LCKC01%'  
  OR STA11.COD_ARTICU LIKE 'VSOM01%'  
  OR STA11.COD_ARTICU LIKE 'VMCL01%'  
  OR STA11.COD_ARTICU LIKE 'AMSOM1%'  
  OR STA11.COD_ARTICU LIKE 'AMMSL1%'  
  OR STA11.COD_ARTICU LIKE 'AMMCL1%'  
  OR STA11.COD_ARTICU LIKE 'AZSOM1%'  
  OR STA11.COD_ARTICU LIKE 'AZMSL1%'  
  OR STA11.COD_ARTICU LIKE 'AZMCL1%'  
  OR STA11.COD_ARTICU LIKE 'MMSL01%'  
  OR STA11.COD_ARTICU LIKE 'MMCL01%'  
  OR STA11.COD_ARTICU LIKE 'MSOM01%'  
  OR STA11.COD_ARTICU LIKE 'NMCL01%'  
  OR STA11.COD_ARTICU LIKE 'NSOM01%'  
  OR STA11.COD_ARTICU LIKE 'CMT001%'  
  OR STA11.COD_ARTICU LIKE 'NMSL01%'  
    
  ;  
END  