
-- Cambiar Condición de Venta y Talonario para que pasen a Central
--Update GVA12 set COND_VTA = '1', TALONARIO = '10'  where N_COMP like '9999999999%'

-- CTE para calcular el saldo inicial para los clientes que tienen comprobantes especiales 'FAC' con números que comienzan por '999999999999%'
WITH SaldoInicial AS (
    SELECT 
        COD_CLIENT,
        NRO_SUCURS,
		SUM(
            CASE 
                -- Si es una 'FAC' especial, suma el importe, si no, suma 0
                WHEN T_COMP = 'FAC' AND N_COMP LIKE '999999999999%' THEN ISNULL(IMPORTE, 0)
                ELSE 0
            END
        ) AS SaldoInicial
    FROM CTA02
    WHERE COD_CLIENT <> '000000' AND (T_COMP = 'FAC' AND N_COMP LIKE '999999999999%')
    GROUP BY COD_CLIENT, NRO_SUCURS
)

-- Consulta principal para calcular el saldo corriente con el saldo inicial acumulado
SELECT 
    -- Tipos de comprobante y detalles
    CTA02.T_COMP AS [Tipo de Comprobante],
    CTA02.N_COMP AS [Nro. Comprobante],
    CTA02.FECHA_EMIS AS [Fecha],
    CTA02.COD_CLIENT AS [Cód. cliente],
	CTA02.NOMBRE_CLI AS [Razón Social],
    CTA02.ESTADO AS [Estado],
    CTA02.NRO_SUCURS AS [Nro. de Sucursal],
    -- Cálculo del saldo corriente
    SUM(
        CASE 
            -- Si es una 'FAC', suma el importe, si es 'N/C' o 'REC', resta el importe. En otros casos, suma 0.
            WHEN CTA02.T_COMP = 'FAC'  THEN ISNULL(IMPORTE, 0)
            WHEN CTA02.T_COMP IN ('N/C', 'REC') THEN ISNULL(-1 * IMPORTE, 0)
            ELSE 0
        END
    ) - 
    -- Resta el monto del REC imputado a una FAC si existe imputación
    ISNULL(
        (SELECT SUM(ISNULL(IMPORTE, 0)) 
         FROM CTA02 AS Imputaciones 
         WHERE Imputaciones.T_COMP_IMPUTADO = 'FAC' 
         AND Imputaciones.N_COMP_IMPUTADO = CTA02.N_COMP collate Modern_Spanish_CI_AI
         AND Imputaciones.COD_CLIENT = CTA02.COD_CLIENT 
         AND Imputaciones.NRO_SUCURS = CTA02.NRO_SUCURS 
         AND Imputaciones.T_COMP = 'REC'
         ), 0
    ) +
    -- Suma el saldo inicial acumulado para este cliente y sucursal si existe en el CTE SaldoInicial
    SUM(
        CASE 
            WHEN SaldoInicial.SaldoInicial IS NOT NULL AND N_COMP NOT LIKE '999999999999%' THEN SaldoInicial.SaldoInicial
            ELSE 0
        END
    ) OVER (PARTITION BY CTA02.COD_CLIENT, CTA02.NRO_SUCURS ORDER BY CTA02.FECHA_EMIS, CTA02.T_COMP, CTA02.N_COMP) AS [Saldo Mon. Corriente]
FROM 
    CTA02
-- Une con el CTE SaldoInicial basado en COD_CLIENT y NRO_SUCURS
LEFT JOIN 
    SaldoInicial ON CTA02.COD_CLIENT = SaldoInicial.COD_CLIENT AND CTA02.NRO_SUCURS = SaldoInicial.NRO_SUCURS
-- Filtra los registros para excluir clientes ocasionales y estados 'ANU'
WHERE 
    CTA02.COD_CLIENT <> '000000' AND CTA02.ESTADO <> 'ANU' 
-- Agrupa los resultados por ciertos campos para evitar duplicados
GROUP BY 
    CTA02.T_COMP, CTA02.N_COMP, CTA02.FECHA_EMIS, CTA02.COD_CLIENT, CTA02.NOMBRE_CLI ,CTA02.ESTADO, CTA02.NRO_SUCURS, SaldoInicial.SaldoInicial
-- Ordena los resultados según ciertos campos
ORDER BY 
    CTA02.COD_CLIENT,
    CTA02.NRO_SUCURS,
    CTA02.FECHA_EMIS,
    CTA02.T_COMP,
    CTA02.N_COMP;









--
--
--
--
--
--
--Centralización de Saldos en Tiribelli v2

-- CTE para calcular el saldo inicial para los clientes que tienen comprobantes especiales 'FAC' con números que comienzan por '999999999999%'
WITH SaldoInicial AS (
    SELECT 
        COD_CLIENT,
        NRO_SUCURS,
        SUM(
            CASE 
                -- Si es una 'FAC' especial, suma el importe, si no, suma 0
                WHEN T_COMP = 'FAC' AND N_COMP LIKE '999999999999%' THEN ISNULL(IMPORTE, 0)
                ELSE 0
            END
        ) AS SaldoInicial
    FROM CTA02
    WHERE COD_CLIENT <> '000000' AND (T_COMP = 'FAC' AND N_COMP LIKE '999999999999%')
    GROUP BY COD_CLIENT, NRO_SUCURS
)

-- Consulta principal para calcular el saldo corriente con el saldo inicial acumulado
SELECT 
    -- Tipos de comprobante y detalles
    CTA02.T_COMP AS [Tipo de Comprobante],
    CTA02.N_COMP AS [Nro. Comprobante],
    CTA02.FECHA_EMIS AS [Fecha],
    CTA02.COD_CLIENT AS [Cód. cliente],
	CTA02.NOMBRE_CLI AS [Razón Social],
    CTA02.ESTADO AS [Estado],
    CTA02.NRO_SUCURS AS [Nro. de Sucursal],
	SUCURSAL.DESC_SUCURSAL AS [Descripción Sucursal],
    CASE 
        WHEN CTA02.T_COMP = 'FAC' THEN ISNULL(IMPORTE, 0) 
        WHEN CTA02.T_COMP IN ('N/C', 'REC') THEN ISNULL(-1 * IMPORTE, 0)
        ELSE 0
    END AS [Importe Cte.]
FROM 
    CTA02
-- Une con el CTE SaldoInicial basado en COD_CLIENT y NRO_SUCURS
LEFT JOIN 
    SaldoInicial ON CTA02.COD_CLIENT = SaldoInicial.COD_CLIENT AND CTA02.NRO_SUCURS = SaldoInicial.NRO_SUCURS
JOIN 
	SUCURSAL ON CTA02.NRO_SUCURS = SUCURSAL.NRO_SUCURSAL
-- Filtra los registros para excluir clientes ocasionales y estados 'ANU'
WHERE 
    CTA02.COD_CLIENT <> '000000' 
    AND CTA02.ESTADO <> 'ANU' 
-- Agrupa los resultados por ciertos campos para evitar duplicados
GROUP BY 
    CTA02.T_COMP, CTA02.N_COMP, CTA02.FECHA_EMIS, CTA02.COD_CLIENT, CTA02.NOMBRE_CLI ,CTA02.ESTADO, CTA02.NRO_SUCURS, CTA02.IMPORTE, SaldoInicial.SaldoInicial, SUCURSAL.DESC_SUCURSAL
-- Ordena los resultados según ciertos campos
ORDER BY 
    CTA02.FECHA_EMIS,
    CTA02.COD_CLIENT,
    CTA02.NRO_SUCURS,
    CTA02.T_COMP,
    CTA02.N_COMP;