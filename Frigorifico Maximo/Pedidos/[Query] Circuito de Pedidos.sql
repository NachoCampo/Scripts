Create View CircuitoPedidos AS (
SELECT 
    CASE 
        WHEN GVA21.FECHA_ENTR <> '01/01/1800' THEN GVA21.FECHA_ENTR  
        ELSE CASE WHEN TEMP.FECHA_MINIMA <> '01/01/1800' THEN TEMP.FECHA_MINIMA ELSE NULL END 
    END AS [Fecha Entrega] ,
    GVA21.Nro_Pedido AS [Nro. Pedido] ,
    GVA21.COD_CLIENT AS [Cód. cliente] ,
    CASE GVA21.COD_CLIENT 
        WHEN '000000' THEN 'OCASIONAL' 
        ELSE GVA14.RAZON_SOCI 
    END AS [Razón social] ,
    CASE GVA21.COD_CLIENT 
        WHEN '000000' THEN 'OCASIONAL' 
        ELSE NOM_COM 
    END AS [Nombre comercial] ,
    GVA21.FECHA_PEDI AS [Fecha Pedido] ,
    CASE 
        WHEN GVA21.ESTADO = 1 THEN 'INGRESADO' 
        WHEN GVA21.ESTADO = 2 THEN Estado.Estado --El GVA21.ESTADO = 2 tiene tres subestados: Pendiente, Parcial o Totalmente Facturado.
        WHEN GVA21.ESTADO = 3 THEN 'CUMPLIDO' 
        WHEN GVA21.ESTADO = 4 THEN 'CERRADO' 
        WHEN GVA21.ESTADO = 5 THEN 'ANULADO' 
        WHEN GVA21.ESTADO = 6 THEN 'REVISADO'	
        WHEN GVA21.ESTADO = 7 THEN 'DESAPROBADO' 
        ELSE 'OTRO' -- Manejar cualquier otro valor de estado como "OTRO"
    END AS [Estado]
FROM 
    GVA21  
INNER JOIN (
    SELECT 
        GVA21.NRO_PEDIDO,
CASE 
        WHEN GVA55.NRO_PEDIDO IS NULL THEN 'PENDIENTE'
        ELSE 
            CASE 
                WHEN SUM(
                    CASE 
                        WHEN GVA03.CANT_PEN_F != '0.0000000' AND GVA03.COD_ARTICU != 'A000001' THEN 1 --Si la suma de la "Cantidad Pendiente de Facturar" es = '0.0000000' menos el artículo de "Servicio de Envio" sería "Totalmente Facturado".
                        ELSE 0 
                    END
                ) = 0 THEN 'TOTALMENTE FACTURADO'
                WHEN SUM(
                    CASE 
                        WHEN GVA03.CANT_PEN_F != '0.0000000' AND GVA03.COD_ARTICU != 'A000001' THEN 1  --Si la suma de la "Cantidad Pendiente de Facturar" es mayor a "0.000000" menos el artículo de "Servicio de Envio" sería "Parcial".
                        ELSE 0 
                    END
                ) > 0 THEN 'PARCIAL'
            END
        END AS Estado
    FROM 
        GVA03
    LEFT JOIN 
        GVA55 ON GVA03.NRO_PEDIDO = GVA55.NRO_PEDIDO
    JOIN GVA21 ON GVA21.NRO_PEDIDO = GVA03.NRO_PEDIDO
    GROUP BY 
        GVA21.NRO_PEDIDO, GVA55.NRO_PEDIDO
) AS Estado ON Estado.NRO_PEDIDO = GVA21.NRO_PEDIDO
INNER JOIN (
    SELECT 
        GVA21.TALON_PED, 
        GVA21.NRO_PEDIDO,             
        SUM (
            (
                (
                    CASE GVA10.MON_CTE 
                        WHEN 1 THEN GVA03.PRECIO 
                        ELSE (GVA03.PRECIO * GVA21.Cotiz) 
                    END
                ) * (1 - (GVA03.DESCUENTO) / 100)
            ) * (GVA03.Cant_Pen_F)
        ) TOTAL_SIN_DESCUENTO             
    FROM 
        GVA21             
    INNER JOIN 
        GVA10	ON GVA21.N_Lista = GVA10.Nro_de_Lis             
    INNER JOIN	
        GVA03 ON (GVA21.TALON_PED = GVA03.TALON_PED AND  GVA21.NRO_PEDIDO = GVA03.NRO_PEDIDO)             
    GROUP BY 
        GVA21.TALON_PED, GVA21.NRO_PEDIDO
) AS TEMP2 ON GVA21.TALON_PED = TEMP2.TALON_PED AND GVA21.NRO_PEDIDO = TEMP2.NRO_PEDIDO  
LEFT JOIN (
    SELECT 
        TALON_PED, 
        NRO_PEDIDO, 
        MIN(FEC_ENTREG) AS FECHA_MINIMA 
    FROM 
        GVA126  
    GROUP BY 
        TALON_PED, NRO_PEDIDO 
) AS TEMP ON GVA21.TALON_PED = TEMP.TALON_PED  AND GVA21.NRO_PEDIDO = TEMP.NRO_PEDIDO  
LEFT JOIN (
    SELECT 
        DISTINCT COND_VTA, DESC_COND 
    FROM 
        GVA01
) AS COND  ON COND.COND_VTA = GVA21.COND_VTA  
INNER JOIN GVA23 ON GVA21.COD_VENDED = GVA23.COD_VENDED  
LEFT JOIN GVA81 ON GVA81.COD_CLASIF = GVA21.COD_CLASIF 
INNER JOIN GVA24 ON GVA21.COD_TRANSP = GVA24.COD_TRANSP  
LEFT JOIN GVA14 ON GVA21.COD_CLIENT = GVA14.COD_CLIENT  
LEFT JOIN GVA05 ON GVA14.COD_ZONA = GVA05.COD_ZONA  
LEFT JOIN GVA18 ON GVA14.COD_PROVIN = GVA18.COD_PROVIN  
LEFT JOIN GVA133 ON GVA18.COD_PAIS = GVA133.COD_PAIS  
INNER JOIN GVA43 ON GVA43.TALONARIO = GVA21.TALON_PED  
INNER JOIN STA22 ON GVA21.COD_SUCURS = STA22.COD_SUCURS  
LEFT JOIN DIRECCION_ENTREGA ON GVA21.ID_DIRECCION_ENTREGA = DIRECCION_ENTREGA.ID_DIRECCION_ENTREGA 
LEFT JOIN (
    SELECT 
        gva03.nro_pedido, 
        gva03.talon_ped                   
    FROM 
        gva03                    
    LEFT JOIN 
        STA11 ON STA11.COD_ARTICU = GVA03.COD_ARTICU              
    WHERE 
        (
            (
                (Sta11.ID_MEDIDA_STOCK = STA11.ID_MEDIDA_CONTROL_STOCK) and (gva03.cant_pen_f > 0)
            ) OR (
                (Sta11.ID_MEDIDA_STOCK <> STA11.ID_MEDIDA_CONTROL_STOCK) and(gva03.cant_pen_f_2 > 0)
            )
        ) AND (
            (
                (Sta11.ID_MEDIDA_STOCK = STA11.ID_MEDIDA_CONTROL_STOCK) and (gva03.cant_pen_d <> gva03.cant_pedid)
            ) OR (
                (Sta11.ID_MEDIDA_STOCK <> STA11.ID_MEDIDA_CONTROL_STOCK) and (gva03.cant_pen_d_2 <> gva03.cant_pedid_2)
            )
        ) AND (
            (
                (Sta11.ID_MEDIDA_STOCK = STA11.ID_MEDIDA_CONTROL_STOCK) and (gva03.cant_pen_f > gva03.cant_pen_d)
            ) OR (
                (Sta11.ID_MEDIDA_STOCK <> STA11.ID_MEDIDA_CONTROL_STOCK) and (gva03.cant_pen_f_2 > gva03.cant_pen_d_2)
            )
        )                
    GROUP BY 
        GVA03.NRO_PEDIDO, GVA03.TALON_PED
) AS REMITIDO ON REMITIDO.TALON_PED = GVA21.TALON_PED AND REMITIDO.NRO_PEDIDO = GVA21.NRO_PEDIDO        
LEFT JOIN (
    SELECT 
        gva03.NRO_PEDIDO, 
        GVA03.TALON_PED,                     
        SUM (
            CASE 
                WHEN STA11.ID_MEDIDA_CONTROL_STOCK = STA11.ID_MEDIDA_STOCK_2 AND GVA03.CANT_PEN_F_2 > 0 THEN GVA03.CANT_PEN_F_2
                WHEN STA11.ID_MEDIDA_CONTROL_STOCK = STA11.ID_MEDIDA_STOCK   AND GVA03.CANT_PEN_F   > 0 THEN GVA03.CANT_PEN_F
            END
        ) AS CANTIDAD_PENDIENTE_FACTURAR                   
    FROM 
        GVA03                   
    INNER JOIN STA11 ON GVA03.COD_ARTICU = STA11.COD_ARTICU                
    GROUP BY 
        GVA03.NRO_PEDIDO, GVA03.TALON_PED
) AS PEDIDO_PENDIENTE ON PEDIDO_PENDIENTE.NRO_PEDIDO = GVA21.NRO_PEDIDO AND PEDIDO_PENDIENTE.TALON_PED = GVA21.TALON_PED 
LEFT JOIN GVA38 ON gva21.NRO_PEDIDO=gva38.N_COMP and gva38.T_COMP='PED'  
LEFT JOIN GVA18 PROV_OCASIONAL ON PROV_OCASIONAL.COD_PROVIN = GVA38.COD_PROVIN 
WHERE 
    EXISTS ( 
        SELECT TOP 1 GVA03.NRO_PEDIDO 
        FROM GVA03 
        WHERE GVA03.Talon_Ped = GVA21.Talon_Ped 
        AND GVA03.Nro_Pedido = GVA21.Nro_Pedido 
        AND PEDIDO_PENDIENTE.CANTIDAD_PENDIENTE_FACTURAR > 0
    ) 
GROUP BY 
    CASE 
        WHEN GVA21.FECHA_ENTR <> '01/01/1800' THEN GVA21.FECHA_ENTR  
        ELSE CASE WHEN TEMP.FECHA_MINIMA <> '01/01/1800' THEN TEMP.FECHA_MINIMA ELSE NULL END 
    END,
    GVA21.Nro_Pedido,
    GVA21.COD_CLIENT,
    CASE GVA21.COD_CLIENT 
        WHEN '000000' THEN 'OCASIONAL' 
        ELSE GVA14.RAZON_SOCI 
    END,
    CASE GVA21.COD_CLIENT 
        WHEN '000000' THEN 'OCASIONAL' 
        ELSE NOM_COM 
    END,
    GVA21.FECHA_PEDI,
    Estado.Estado,
	GVA21.ESTADO
)