/*Se crea la vista partiendo desde Compras e Importaciones | Consultas | Contabilidad | Detalle por subauxiliar, agregando: "CPA47.COD_CONCEP", "CPA45.DESC_CONCE".
Luego se agrega en una vista y se filtra por fecha para que puedan ver aquellos comprobantes de Compras.
*/

CREATE VIEW SubaxiliarNCM AS (  
    SELECT   
        CPA04.FECHA_CONT, -- Agrega esta columna a la vista  
        dbo.TLMostrarCodigoDescripcion(SUBAUXILIAR.COD_SUBAUXILIAR, SUBAUXILIAR.DESC_SUBAUXILIAR) AS [Subauxiliar],  
        TIPO_AUXILIAR.COD_TIPO_AUXILIAR AS [Tipo de auxiliar],  
        TIPO_AUXILIAR.DESC_TIPO_AUXILIAR AS [Desc. tipo de auxiliar],  
        CPA47.COD_CONCEP AS [Cod. Concepto de Compra],  
        CPA45.DESC_CONCE AS [Desc. Concepto de Compra],  
        SUM(CASE WHEN ASIENTO_CP.D_H = 'D' THEN SUBAUXILIAR_ASIENTO_CP.IMPORTE_RENGLON_BASE_CP ELSE 0.0 END) AS [Debe (CTE)],  
        SUM(CASE WHEN ASIENTO_CP.D_H = 'H' THEN SUBAUXILIAR_ASIENTO_CP.IMPORTE_RENGLON_BASE_CP ELSE 0.0 END) AS [Haber (CTE)],  
        SUM(CASE WHEN ASIENTO_CP.D_H = 'D' THEN SUBAUXILIAR_ASIENTO_CP.IMPORTE_RENGLON_BASE_CP ELSE 0.0 END - CASE WHEN ASIENTO_CP.D_H = 'H' THEN SUBAUXILIAR_ASIENTO_CP.IMPORTE_RENGLON_BASE_CP ELSE 0.0 END) AS [Saldo (CTE)],  
        SUBAUXILIAR.COD_SUBAUXILIAR AS [Cód. subauxiliar]   
    FROM   
        ASIENTO_CP   
    LEFT JOIN AUXILIAR_ASIENTO_CP ON ASIENTO_CP.ID_ASIENTO_CP = AUXILIAR_ASIENTO_CP.ID_ASIENTO_CP   
    INNER JOIN CUENTA ON CUENTA.ID_CUENTA = ASIENTO_CP.ID_CUENTA   
    LEFT JOIN AUXILIAR ON AUXILIAR.ID_AUXILIAR = AUXILIAR_ASIENTO_CP.ID_AUXILIAR   
    INNER JOIN TIPO_AUXILIAR ON TIPO_AUXILIAR.ID_TIPO_AUXILIAR = AUXILIAR.ID_TIPO_AUXILIAR   
    LEFT JOIN SUBAUXILIAR_ASIENTO_CP ON AUXILIAR_ASIENTO_CP.ID_ASIENTO_CP = SUBAUXILIAR_ASIENTO_CP.ID_ASIENTO_CP AND AUXILIAR_ASIENTO_CP.ID_AUXILIAR = SUBAUXILIAR_ASIENTO_CP.ID_AUXILIAR   
    INNER JOIN SUBAUXILIAR ON SUBAUXILIAR.ID_SUBAUXILIAR = SUBAUXILIAR_ASIENTO_CP.ID_SUBAUXILIAR   
    INNER JOIN ASIENTO_COMPROBANTE_CP ON ASIENTO_COMPROBANTE_CP.ID_ASIENTO_COMPROBANTE_CP = ASIENTO_CP.ID_ASIENTO_COMPROBANTE_CP   
    JOIN CPA04 ON ASIENTO_COMPROBANTE_CP.NCOMP_IN_C = CPA04.NCOMP_IN_C AND CPA04.TCOMP_IN_C <> 'OP'   
    JOIN CPA47 ON CPA47.NCOMP_IN_C = CPA04.NCOMP_IN_C AND CPA47.TCOMP_IN_C = CPA04.TCOMP_IN_C  
    JOIN CPA45 ON CPA45.COD_CONCEP = CPA47.COD_CONCEP  
    JOIN CONCEPTO_CP ON CONCEPTO_CP.ID_CPA45 = CPA45.ID_CPA45 AND CONCEPTO_CP.ID_CUENTA = CUENTA.ID_CUENTA  
    WHERE   
        TIPO_AUXILIAR.USA_SUBAUXILIARES_CONTABLES = 'S'  
    GROUP BY   
        CPA04.FECHA_CONT,  
        dbo.TLMostrarCodigoDescripcion(SUBAUXILIAR.COD_SUBAUXILIAR, SUBAUXILIAR.DESC_SUBAUXILIAR),  
        TIPO_AUXILIAR.COD_TIPO_AUXILIAR,  
        TIPO_AUXILIAR.DESC_TIPO_AUXILIAR,  
        CPA47.COD_CONCEP,  
        CPA45.DESC_CONCE,  
        SUBAUXILIAR.COD_SUBAUXILIAR  
)  


/*En base a esto es la consulta externa con las fechas incluidas*/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET DATEFORMAT DMY 
SET DATEFIRST 7 
SET DEADLOCK_PRIORITY -8;
-- Define tus fechas acá
DECLARE @FechaInicio datetime = '2023-09-01T00:00:00.000';
DECLARE @FechaFin datetime = '2023-09-30T23:59:59.999';
SELECT * FROM SubaxiliarNCM WHERE FECHA_CONT BETWEEN @FechaInicio AND @FechaFin
