# Documentación del Repositorio de SQL para "Sanitarios El Aguila".
Este repositorio un SP llamado: PreciosActualizados que cada 2 minutos se ejecuta mediante las Tareas de Windows.

## Stored Procedures (SP):

### SP 1:

#### Nombre:
- Nombre del SP: `PreciosActualizados`

#### Descripción:
- Este SP actualiza la GVA03.PRECIO colocando el precio más actualizado de la GVA17.PRECIO de la lista de precios en la cual llega la orden y posteriormente esta generado el pedido.
- Primero de todo, arma una query para traer el precio más actualizado del artículo que se esta consultando.
- Una vez que toma el precio de esa lista de precios y artículos más nuevo en la tabla, lo actualiza en la GVA03.PRECIO.

Tiene dos condiciones:
* Filtro por los pedidos "Ingresados" y "Aprobados", solo esos afectará.
* Afecta aquellos pedidos que tengan cantidades pendientes de facturar. Si tenemos un pedido que no se facturo completamente, se actualizará el valor de esa unidad pendiente.
* Caso 1: La cotización se hizo en un día distinto al de la fecha del pedido
* Caso 2: La cotización y el pedido son del mismo día, pero han pasado más de 6 horas.
#### Uso:
- Cada 2 minutos se ejecuta contra las dos bases de datos de Sanitarios El Aguila.

## Contribución:

## Problemas y Sugerencias:

## Licencia:
Este proyecto está bajo la Licencia [Punto-Gestion].
