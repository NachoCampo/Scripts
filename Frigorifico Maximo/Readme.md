# Documentación del Repositorio de SQL para "Frigorífico Máximo".
Este repositorio contiene un trigger y tres stored procedures (SP) desarrollados en SQL.

## Trigger:

### Nombre:
- Nombre del trigger: `InsertarRenglonAdicional`

### Descripción:
- Este trigger se dispara cuando se graba el pedido.

### Funcionalidad:
-  Esta credo en la GVA21 y cuando termina de grabar el pedido le agrega un Cod. Artícu = "A000001" en la GVA03 como "Servicio de Envio".
-  Este artículo va a servir para que siempre el pedido quede pendiente de ser facturado. A la noche se cierra por medio de un SP.
-  Las cantidades las graba en 1.000000 y el precio en 0.00001.
-  Se tiene que tener en cuenta el Talonario del Pedido y los ID_UNIDAD_MEDIDA_STOCK de la base de datos.

## Stored Procedures (SP):

### SP 1:

#### Nombre:
- Nombre del SP: `ActualizarCantidades`

#### Descripción:
- Este SP actualiza la GVA03 en el artículo A000001 colocandolo en '1.0000000' si falta algún artículo otro artículo facturarse en GVA53 para el NRO_PEDIDO. Es decir, compara COD_ARTICU de GVA53 y GVA03. Si hay un artículo que no se facturo, cambia las cantidades pendientes en la GVA03.

#### Uso:
- Cada 1,2,3 o 4 minutos, según como se crea la tarea de Windows, el SP se corre contra la base de datos. Este SP actualiza cantidades dejando pendiente el "Servicio de Envio" para que se pueda volver a facturar el pedido. Como usan un sistema de pedidos con balanza, se hacen pedidos mediante WhatsApp, se cargan en el sistema y luego mediante la balanza se pesan. Eso genera que la referencia en el pedido se pierda con el artículo y se tenga que volver a cargar.
- Este SP va actualizando las cantidades pendientes.

### SP 2:

#### Nombre:
- Nombre del SP: `ActualizarEstadoPedido.sql`

#### Descripción:
- Este SP realiza el cambio de estados del pedido. A las 10 PM, todos los pedidos que al menos tengan un solo registro facturado (relación con la GVA55) cambia al estado "Cerrado". Si el pedido no se facturo ni un renglón, ese mismo no interviene en este SP. El estado del Pedido **Cerrado** es el "4" en Tango.

#### Uso:
- Se ejecuta todas las noches a las 10PM en todas las bases de datos y en la consulta de "Circuito de Pedidos" que le armamos, van a ver los pedidos cerrados.

### SP 3:

#### Nombre:
- Nombre del SP: `CambiarEstadoPedidosSinFacturar`

#### Descripción:
- Este SP realiza el cambio de estado de los pedidos que estén "Pendientes" (Aprobados) sin ningún renglón facturado (no hay relación con la GVA55) y lleven más de dos días desde que se genero el pedido.
- En este caso el pedido pasa a estado "Cerrado".
- Se ejecuta todos los días a las 11 PM.

#### Uso:
- Se ejecuta todas las noches a las 11PM en todas las bases de datos y en la consulta de "Circuito de Pedidos" que le armamos, van a ver los pedidos cerrados.

## Contribución:

## Problemas y Sugerencias:

## Licencia:
Este proyecto está bajo la Licencia [Punto-Gestion].
