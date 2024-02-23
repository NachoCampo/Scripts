# Documentación del Repositorio de SQL para "Grupo Tiri".
Este repositorio contiene un Trigger llamado: *InsertarEnSTA19* que ante cada alta un artículo lo que hace es agregar un registro en la STA19 con saldo en '0.000000'. 

## Trigger:

### Trigger 1:

#### Nombre:
- Nombre del Trigger: `InsertarEnSTA19`

#### Descripción:
- Este trigger agrega un registro en la STA19 con el Saldo del Artículo apenas se crea en Tango. 
- Tiene distintas condiciones:
Verificar si el artículo no existe en STA19 y tiene STOCK igual a '1' (Lleva Stock).
Se tiene que revisar en que deposito se va a agregar el registro.

#### Uso:
- Es un trigger que se ejecuta directamente apenas se termina de grabar el artículo en la base de datos.

## Contribución:

## Problemas y Sugerencias:

## Licencia:
Este proyecto está bajo la Licencia [Punto-Gestion].
