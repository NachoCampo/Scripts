# Documentación del Repositorio de SQL
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
- Nombre del SP: `nombre_del_sp_1`

#### Descripción:
- Este SP realiza [descripción de lo que hace el SP 1].

#### Parámetros:
- Parámetro 1: [Descripción del parámetro 1].
- Parámetro 2: [Descripción del parámetro 2].
- ...

#### Uso:
- [Instrucciones sobre cómo usar el SP 1 y qué resultados esperar].

### SP 2:

#### Nombre:
- Nombre del SP: `nombre_del_sp_2`

#### Descripción:
- Este SP realiza [descripción de lo que hace el SP 2].

#### Parámetros:
- Parámetro 1: [Descripción del parámetro 1].
- Parámetro 2: [Descripción del parámetro 2].
- ...

#### Uso:
- [Instrucciones sobre cómo usar el SP 2 y qué resultados esperar].

### SP 3:

#### Nombre:
- Nombre del SP: `nombre_del_sp_3`

#### Descripción:
- Este SP realiza [descripción de lo que hace el SP 3].

#### Parámetros:
- Parámetro 1: [Descripción del parámetro 1].
- Parámetro 2: [Descripción del parámetro 2].
- ...

#### Uso:
- [Instrucciones sobre cómo usar el SP 3 y qué resultados esperar].

## Contribución:
Si deseas contribuir a este repositorio, por favor sigue estas instrucciones:
- Clona el repositorio.
- Realiza tus cambios en una rama separada.
- Abre una solicitud de extracción para revisión.

## Problemas y Sugerencias:
Si encuentras algún problema o tienes alguna sugerencia, por favor abre un issue en este repositorio para que podamos abordarlo.

## Licencia:
Este proyecto está bajo la Licencia [Tipo de Licencia].
