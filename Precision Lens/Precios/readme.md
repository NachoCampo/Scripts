# Documentación del Repositorio de SQL para "Precision Lens  ".
Este repositorio un SP llamado: ActualizarPrecios que cada 2 minutos se ejecuta mediante el SQL Agent

## Stored Procedures (SP):

### SP 1:

#### Nombre:
- Nombre del SP: `ActualizarPrecios`

#### Descripción:
- Este SP actualiza la GVA03.PRECIO colocando el precio más actualizado de la GVA17.PRECIO de la lista de precios en la cual llega la orden y posteriormente esta generado el pedido.

#### Uso:
- Cada 15 minutos se ejecuta contra las dos bases de datos, tanto Precision Lens y Precision Lens 2.
- Lo ejecuta el SQL Agent de forma desatendida.

## Contribución:

## Problemas y Sugerencias:

## Licencia:
Este proyecto está bajo la Licencia [Punto-Gestion].
