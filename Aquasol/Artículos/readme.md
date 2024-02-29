# Documentación del Repositorio de SQL para "Aquasol".
Este repositorio contiene un SP (Store Procedure) desarrollado en SQL.

## Stored Procedures (SP):

### SP 1:

#### Nombre:
- Nombre del SP: `Habilita_Escalas`

#### Descripción:
- Este SP actualiza la STA11 en aquellos artículos que se hayan inhabilitado durante el día para su uso. A las 00.01 hs, mediante una Tarea Programada de Windows se corre el SP y de esa manera se vuelve a habilitar todo para el día siguiente.

#### Uso:
- Todos los días a las 00.01 hs, según se creó la tarea de Windows, el SP se corre contra la base de datos. Este SP actualiza el perfil del Artículo de "N" a "V" habilitandolo para su nuevo uso y también completando las "Unidades de Medida" de AFIP que se borran al ser deshabilitado.

## Contribución:

## Problemas y Sugerencias:

## Licencia:
Este proyecto está bajo la Licencia [Punto-Gestion].
