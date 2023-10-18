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
    CTA02.ESTADO AS [Estado],
    CTA02.NRO_SUCURS AS [Nro. de Sucursal],
    -- Cálculo del saldo corriente
    SUM(
        CASE 
            -- Si es una 'FAC', suma el importe, si es 'N/C' o 'REC', resta el importe. En otros casos, suma 0.
            WHEN CTA02.T_COMP = 'FAC' THEN ISNULL(IMPORTE, 0)
            WHEN CTA02.T_COMP IN ('N/C', 'REC') THEN ISNULL(-1 * IMPORTE, 0)
            ELSE 0
        END
    ) + 
    -- Suma el saldo inicial acumulado para este cliente y sucursal si existe en el CTE SaldoInicial
    SUM(
        CASE 
            WHEN SaldoInicial.SaldoInicial IS NOT NULL THEN SaldoInicial.SaldoInicial
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
    CTA02.T_COMP, CTA02.N_COMP, CTA02.FECHA_EMIS, CTA02.COD_CLIENT, CTA02.ESTADO, CTA02.NRO_SUCURS, SaldoInicial.SaldoInicial
-- Ordena los resultados según ciertos campos
ORDER BY 
    CTA02.COD_CLIENT,
    CTA02.NRO_SUCURS,
    CTA02.FECHA_EMIS,
    CTA02.T_COMP,
    CTA02.N_COMP;
