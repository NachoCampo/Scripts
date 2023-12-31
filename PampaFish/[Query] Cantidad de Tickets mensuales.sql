/*Cantidad de tickets mensuales*/

--Select a la vista
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET DATEFORMAT DMY 
SET DATEFIRST 7 
SET DEADLOCK_PRIORITY -8
Select * from CantidadTicketMensual


--Creación de la vista de Cantidad de Tickets Mensual
Create View CantidadTicketMensual as (
SELECT 
	1 AS [Registro],
	TOTALES.T_COMP AS [Tipo comprobante] ,
	TOTALES.N_COMP AS [Nro. comprobante] ,
	TOTALES.COD_CLIENT AS [Cód. cliente] ,
	CASE TOTALES.COD_CLIENT  WHEN '000000' THEN 'OCASIONAL'  ELSE TOTALES.RAZON_SOCI END AS [Razón social] ,
	TOTALES.COD_VENDED AS [Cód. vendedor] ,
	CASE TOTALES.COD_VENDED  WHEN '**' THEN 'Carga inicial'  ELSE TOTALES.NOMBRE_VEN END AS [Nombre Vendedor] ,
	TOTALES.FECHA AS [Fecha de emisión] ,
	SUM(TOTALES.TOTAL)/ SUM(TOTALES.TICKETS) AS [Ticket promedio] ,
	SUM(TOTALES.TOTALSINIMPUESTOS)/SUM(TOTALES.TICKETS) AS [Ticket promedio (sin impuestos)] 
FROM 
  (SELECT   COUNT(ID_GVA12) TICKETS,    SUM (CASE WHEN GVA15.TIPO_COMP = 'C' THEN GVA12.IMPORTE * (-1) ELSE GVA12.IMPORTE END) TOTAL,   SUM (CASE WHEN GVA15.TIPO_COMP = 'C' THEN GVA12.IMPORTE_GR * (-1) ELSE GVA12.IMPORTE_GR END) TOTALSINIMPUESTOS,   GVA12.FECHA_EMIS FECHA,   	GVA12.COD_CLIENT ,  	CASE GVA12.COD_CLIENT  WHEN '000000' THEN 'OCASIONAL'  ELSE RAZON_SOCI END AS [RAZON_SOCI] ,  	GVA12.COD_VENDED ,  	CASE GVA12.COD_VENDED  WHEN '**' THEN 'Carga inicial'  ELSE NOMBRE_VEN END AS [NOMBRE_VEN] ,  	GVA12.T_COMP ,  	GVA12.N_COMP   FROM GVA12    JOIN GVA15 ON (GVA15.IDENT_COMP = GVA12.T_COMP)    JOIN GVA01 ON GVA12.COND_VTA = GVA01.COND_VTA     
LEFT JOIN GVA14 ON (GVA12.COD_CLIENT = GVA14.COD_CLIENT)      
LEFT JOIN GVA23 ON GVA12.COD_VENDED = GVA23.COD_VENDED      WHERE    GVA12.COD_VENDED <> '**'   AND GVA01.CONTADO = 'N'    AND GVA12.ESTADO <> 'ANU'   AND	GVA12.T_COMP <> 'REC' AND GVA15.VENT_ART = 'S'   GROUP BY GVA12.T_COMP,   GVA12.N_COMP, GVA12.FECHA_EMIS , GVA12.COD_CLIENT, GVA14. RAZON_SOCI, GVA12.COD_VENDED, GVA23.NOMBRE_VEN,  GVA12.T_COMP  ,	GVA12.N_COMP       UNION      SELECT    ((COUNT(DISTINCT(GVA12.ID_GVA12)))) TICKETS,   (SUM (CASE WHEN GVA15.TIPO_COMP = 'C' THEN SBA05.MONTO * (-1) ELSE SBA05.MONTO END)) TOTAL,   (SUM (CASE WHEN GVA15.TIPO_COMP = 'C' THEN GVA12.IMPORTE_GR * (-1) ELSE GVA12.IMPORTE_GR END)) TOTALSINIMPUESTOS,   GVA12.FECHA_EMIS FECHA,   	GVA12.COD_CLIENT ,  	CASE GVA12.COD_CLIENT  WHEN '000000' THEN 'OCASIONAL'  ELSE RAZON_SOCI END AS [RAZON_SOCI] ,  	GVA12.COD_VENDED ,  	CASE GVA12.COD_VENDED  WHEN '**' THEN 'Carga inicial'  ELSE NOMBRE_VEN END AS [NOMBRE_VEN] ,  	GVA12.T_COMP ,  	GVA12.N_COMP     FROM GVA12    JOIN  GVA15 ON (GVA15.IDENT_COMP = GVA12.T_COMP)     
LEFT JOIN SBA04 ON GVA12.N_COMP = SBA04.N_COMP AND GVA12.T_COMP = SBA04.COD_COMP    JOIN SBA05 ON SBA04.N_COMP  = SBA05.N_COMP AND SBA04.COD_COMP = SBA05.COD_COMP  AND  SBA04.BARRA = SBA05.BARRA    JOIN SBA01 ON SBA05.COD_CTA = SBA01.COD_CTA    JOIN MONEDA ON SBA01.ID_MONEDA = MONEDA.ID_MONEDA    
LEFT JOIN GVA14 ON (GVA12.COD_CLIENT = GVA14.COD_CLIENT)     
LEFT JOIN GVA23 ON GVA12.COD_VENDED = GVA23.COD_VENDED    WHERE    GVA12.COD_VENDED <> '**' AND	   GVA12.ESTADO <> 'ANU' AND	GVA12.T_COMP <> 'REC' AND GVA15.VENT_ART = 'S'   AND SBA01.FONDO = 1   GROUP BY GVA12.FECHA_EMIS,  GVA12.COD_CLIENT, GVA14. RAZON_SOCI, GVA12.COD_VENDED, GVA23.NOMBRE_VEN, GVA12.T_COMP, GVA12.N_COMP) TOTALES   
LEFT JOIN GVA14(NOLOCK) ON TOTALES.COD_CLIENT = GVA14.COD_CLIENT   
LEFT JOIN GVA15(NOLOCK) ON TOTALES.T_COMP = GVA15.IDENT_COMP   
LEFT JOIN GVA23(NOLOCK) ON TOTALES.COD_VENDED = GVA23.COD_VENDED 


WHERE 
  GVA23.COD_VENDED IN ( '04' , '05' , '06' , '07' ) 


GROUP BY 
	TOTALES.T_COMP , TOTALES.N_COMP , TOTALES.COD_CLIENT , CASE TOTALES.COD_CLIENT  WHEN '000000' THEN 'OCASIONAL'  ELSE TOTALES.RAZON_SOCI END , TOTALES.COD_VENDED , CASE TOTALES.COD_VENDED  WHEN '**' THEN 'Carga inicial'  ELSE TOTALES.NOMBRE_VEN END , TOTALES.FECHA
)