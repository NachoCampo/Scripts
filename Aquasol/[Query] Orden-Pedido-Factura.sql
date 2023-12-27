--Se crea la Vista "Circuito Completo" con todos los datos de la orden, pedido, factura.. Sus respectivas fechas de emisión y también si el QR y/o Factura esta impresa
Create View CircuitoCompleto As (
SELECT 
 Npo.ORDER_NRO_TIENDA AS [Nro. de Orden],  --Número de Orden de Tiendas
 Npo.NUMERO_PEDIDO AS [Nro. Pedido],  --Número de Pedido en Tango
A.NComp AS [Nro. Factura], --Nro. de Factura de Venta.
Gva12.FECHA_EMIS AS [Fecha Factura], --Fecha de la emisión de la Factura de Venta.
Format (NPO.FECHA_ORDEN, 'dd/MM/yyyy') AS [Fecha Orden], --Fecha de la Emisión de la Orden de Tiendas
NPD.FECHA_ENTREGA AS [Fecha de Ingreso al Parque], --Fecha de Ingreso al Parque.
LOWER(A.Email) AS [Dirección Correo], --Dirección de correo de la persona que hizo la compra.
CASE WHEN A.EmailSent = 1 THEN 'Se envió correctamente' ELSE 'No se envió' END AS [Se envió Correo QR/Reserva], --Si se envío el QR.
CASE WHEN A.EmailSent != 0 THEN 'Se envió correctamente' ELSE 'No se envió' END AS [Se envió Factura x Correo] --Si se envío la Factura desde Tango.
FROM 
 Gva12 
 JOIN [WSC_AQUASOL].[dbo].[Qrs] A ON A.NComp = Gva12.N_COMP COLLATE Modern_Spanish_CI_AI
 JOIN Gva55 ON Gva55.N_COMP = Gva12.N_COMP AND Gva55.T_COMP = Gva12.T_COMP
 JOIN NEXO_PEDIDOS_ORDEN NPO ON NPO.NUMERO_PEDIDO = Gva55.NRO_PEDIDO COLLATE Modern_Spanish_CI_AI
JOIN NEXO_PEDIDOS_DIRECCIONES NPD ON NPO.ID_NEXO_PEDIDOS_ORDEN = NPD.ID_NEXO_PEDIDOS_ORDEN
WHERE 
 A.CreatedBy = 'Web' --Filtra unicamente los que son Web.
 --AND CAST(CreatedOn AS DATE) = CAST(GETDATE() AS DATE)
GROUP BY 
 Npo.ORDER_NRO_TIENDA, 
 npo.NUMERO_PEDIDO, 
 A.NComp, 
 A.EmailSent, 
 A.Email,
	NPO.FECHA_ORDEN,
	Gva12.FECHA_EMIS,
	NPD.FECHA_ENTREGA
)


--Se hace el SELECT a la vista correspondiente.
Set dateformat DMY
Select * from CircuitoCompleto



--Se hacen modificaciones agregando la Reserva.
Alter View CircuitoCompleto As (    
SELECT   
 Npo.ORDER_NRO_TIENDA AS [Nro. de Orden],   
 Npo.NUMERO_PEDIDO AS [Nro. Pedido],   
A.NComp AS [Nro. Factura],  
Gva12.FECHA_EMIS AS [Fecha Factura],  
Format (NPO.FECHA_ORDEN, 'dd/MM/yyyy') AS [Fecha Orden],  
NPD.FECHA_ENTREGA AS [Fecha de Ingreso al Parque],  
LOWER(A.Email) AS [Dirección Correo],  
CASE WHEN A.EmailSent = 1 THEN 'Se envió correctamente' ELSE 'No se envió' END AS [Se envió Correo QR/Reserva],  
CASE WHEN GVA12.CANT_MAIL != 0 THEN 'Se envió correctamente' ELSE 'No se envió' END AS [Se envió Factura x Correo],
CASE WHEN GVA12.ULT_MAIL = '1800-01-01 00:00:00.000' THEN 'Sin datos' ELSE GVA12.ULT_MAIL END AS [Hora de Envio Factura],
R.Code AS NroReserva
FROM   
 Gva12   
 JOIN [WSC_AQUASOL].[dbo].[Qrs] A ON A.NComp = Gva12.N_COMP COLLATE Modern_Spanish_CI_AI  
 LEFT JOIN [WSC_AQUASOL].[dbo].[Reservas] R ON R.Id = A.ReservaId --Se agrega un LEFT porque en algunos casos no tiene IdReserva, entonces no aparecia en la consulta por tener NULL.
 JOIN Gva55 ON Gva55.N_COMP = Gva12.N_COMP AND Gva55.T_COMP = Gva12.T_COMP  
 JOIN NEXO_PEDIDOS_ORDEN NPO ON NPO.NUMERO_PEDIDO = Gva55.NRO_PEDIDO COLLATE Modern_Spanish_CI_AI  
 JOIN NEXO_PEDIDOS_DIRECCIONES NPD ON NPO.ID_NEXO_PEDIDOS_ORDEN = NPD.ID_NEXO_PEDIDOS_ORDEN  
WHERE   
 A.CreatedBy = 'Web'   
 --AND CAST(CreatedOn AS DATE) = CAST(GETDATE() AS DATE)  
GROUP BY   
 Npo.ORDER_NRO_TIENDA,   
 npo.NUMERO_PEDIDO,   
 A.NComp,   
 A.EmailSent,
 Gva12.CANT_MAIL,
 A.Email,  
 NPO.FECHA_ORDEN,  
 Gva12.FECHA_EMIS,  
 NPD.FECHA_ENTREGA,
 Gva12.ULT_MAIL,
 R.Code
 )
