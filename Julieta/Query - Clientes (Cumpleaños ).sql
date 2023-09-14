/*Consulta que devuelve los clientes que cumplen los años ese día*/
SELECT COD_CLIENT [COD. CLIENTE], RAZON_SOCI [NOMBRE Y APELLIDO],  FORMAT(CAST(CUMPLEANIO AS DATE), 'dd/MM/yyyy') AS [FECHA DE CUMPLEAÑOS], GVA14.TELEFONO_1 AS [TELEFONO]
FROM GVA14
WHERE FORMAT(CUMPLEANIO, 'dd-MM') = FORMAT(GETDATE(), 'dd-MM')
AND CUMPLEANIO IS NOT NULL;

/*Clientes que cumplen los años esta semana*/
-- Definir el formato de fecha deseado
SET DATEFORMAT DMY;

-- Obtener el primer día de la semana (lunes)
DECLARE @PrimerDiaSemana DATE = DATEADD(DAY, -DATEDIFF(DAY, 0, GETDATE()) % 7, GETDATE());

-- Obtener el último día de la semana (domingo)
DECLARE @UltimoDiaSemana DATE = DATEADD(DAY, 6, @PrimerDiaSemana);

-- Consulta para encontrar cumpleaños en la semana actual (solo día y mes)
SELECT
    COD_CLIENT AS [COD. CLIENTE],
    RAZON_SOCI AS [NOMBRE Y APELLIDO],
    FORMAT(CAST(CUMPLEANIO AS DATE), 'dd/MM/yyyy') AS [FECHA DE CUMPLEAÑOS],
    GVA14.TELEFONO_1 AS [TELEFONO]
FROM GVA14
WHERE
    (DAY(CUMPLEANIO) >= DAY(@PrimerDiaSemana) AND DAY(CUMPLEANIO) <= DAY(@UltimoDiaSemana)) AND
    (MONTH(CUMPLEANIO) = MONTH(@PrimerDiaSemana) OR MONTH(CUMPLEANIO) = MONTH(@UltimoDiaSemana)) AND
    CUMPLEANIO IS NOT NULL
ORDER BY [FECHA DE CUMPLEAÑOS] ASC;


