/*Se crea una vista contra la "Master" del SQL que apunta contra las cuatro bases de datos. Esta query trae todos los pedidos inconsistentes que no tienen el "Servicio de Envio" en todas las bases de datos*/
Create View PedidosInconsistentes AS (
SELECT   
    [Base de Datos],  
    NRO_PEDIDO AS [Número de Pedido inconsistente],  
    FECHA_PEDI AS [Fecha Pedido],  
    CASE ESTADO 
        WHEN 1 THEN 'Ingresado'
        WHEN 2 THEN 'Aprobado'
        WHEN 3 THEN 'Cumplido'
        WHEN 4 THEN 'Cerrado'
		WHEN 5 THEN 'Anulado'
		WHEN 6 THEN 'Revisado'
		WHEN 4 THEN 'Desaprobado'
        ELSE 'Estado Desconocido'
    END AS [Estado del Pedido]  
FROM (  
    SELECT   
        'Maxivalenti Srl' AS [Base de Datos],  
        GVA21.NRO_PEDIDO,  
        FECHA_PEDI,  
        ESTADO  
    FROM   
        MAXIVALENTI_SRL.dbo.Gva03  
    JOIN   
        MAXIVALENTI_SRL.dbo.Gva21 ON Gva21.NRO_PEDIDO = Gva03.NRO_PEDIDO  
    WHERE   
        Gva03.NRO_PEDIDO NOT IN (  
            SELECT Gva03.NRO_PEDIDO  
            FROM MAXIVALENTI_SRL.dbo.Gva03  
            WHERE Gva03.COD_ARTICU = 'A000001'  
        )  --Acá termina MAXIVALENTI_SRL
    UNION ALL  
    SELECT   
        'Pruebas Maximo' AS [Base de Datos],  
        GVA21.NRO_PEDIDO,  
        FECHA_PEDI,  
        ESTADO  
    FROM   
        PRUEBAS_MAXIMO.dbo.Gva03  
    JOIN   
        PRUEBAS_MAXIMO.dbo.Gva21 ON Gva21.NRO_PEDIDO = Gva03.NRO_PEDIDO  
    WHERE   
        Gva03.NRO_PEDIDO NOT IN (  
            SELECT Gva03.NRO_PEDIDO  
            FROM PRUEBAS_MAXIMO.dbo.Gva03  
            WHERE Gva03.COD_ARTICU = 'A000001'  
        ) --Acá termina PRUEBAS_MAXIMO
    UNION ALL  
    SELECT   
        'Vizmaxval Carnicerias SRL' AS [Base de Datos],  
        GVA21.NRO_PEDIDO,  
        FECHA_PEDI,  
        ESTADO  
    FROM   
        VIZMAXVAL_CARNICERIAS_SRL.dbo.Gva03  
    JOIN   
        VIZMAXVAL_CARNICERIAS_SRL.dbo.Gva21 ON Gva21.NRO_PEDIDO = Gva03.NRO_PEDIDO  
    WHERE   
        Gva03.NRO_PEDIDO NOT IN (  
            SELECT Gva03.NRO_PEDIDO  
            FROM VIZMAXVAL_CARNICERIAS_SRL.dbo.Gva03  
            WHERE Gva03.COD_ARTICU = 'A000001'  
        )  --Acá termina VIZMAXVAL_CARNICERIAS_SRL
    UNION ALL  
    SELECT   
        'Prod Frigorificos Jo Al Duar' AS [Base de Datos],  
        Gva21.NRO_PEDIDO,  
        FECHA_PEDI,  
        ESTADO  
    FROM   
        PROD_FRIGORIFICOS_JO_AL_DUAR_SA.dbo.Gva03  
    JOIN   
        PROD_FRIGORIFICOS_JO_AL_DUAR_SA.dbo.Gva21 ON Gva21.NRO_PEDIDO = Gva03.NRO_PEDIDO  
    WHERE   
        Gva03.NRO_PEDIDO NOT IN (  
            SELECT Gva03.NRO_PEDIDO  
            FROM PROD_FRIGORIFICOS_JO_AL_DUAR_SA.dbo.Gva03  
            WHERE Gva03.COD_ARTICU = 'A000001'  
        )  --Acá termina PROD_FRIGORIFICOS_JO_AL_DUAR_SA
) AS Subquery  
GROUP BY   
    [Base de Datos],  
    NRO_PEDIDO,  
    FECHA_PEDI,  
    ESTADO
)
