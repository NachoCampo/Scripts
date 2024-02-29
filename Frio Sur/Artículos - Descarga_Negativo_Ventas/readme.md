# Documentación del Repositorio de SQL para "Frio Sur".
Este repositorio contiene un SP (Store Procedure) desarrollado en SQL.

## Stored Procedures (SP):

### SP 1:

#### Nombre:
- Nombre del SP: `ActualizarDescargaNegativoVentas`

#### Descripción:
- Este SP actualiza la `dbo.STA11` y cambia el `DESCARGA_NEGATIVO_VENTAS` de 0 a 1.

#### Uso:
- Cada 10 minutos este SP se ejecuta contra la base de datos y modifica el `DESCARGA_NEGATIVO_VENTAS` de 0 a 1 a todos aquellos artículos que arrancan con estos códigos: `F00%` y `C00%` sobre la base de datos que permite facturar en negativo.

## Contribución:

## Problemas y Sugerencias:

## Licencia:
Este proyecto está bajo la Licencia [Punto-Gestion].
