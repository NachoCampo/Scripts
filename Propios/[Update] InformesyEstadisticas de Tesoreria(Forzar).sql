set dateformat dmy
UPDATE SBA01 Set filler=filler where fecha_sald >='01-07-2023'
go
set dateformat dmy
UPDATE SBA04 Set filler=filler where fecha >='01-07-2023'
go
set dateformat dmy
UPDATE SBA14 Set filler=filler
go
set dateformat dmy
UPDATE SBA15 Set filler=filler
go
set dateformat dmy
UPDATE SBA20 Set filler=filler where fecha_cupo >='01-07-2023'
go
set dateformat dmy
UPDATE SBA23 Set filler=filler
go
set dateformat dmy
UPDATE SBA27 Set filler=filler
go
set dateformat dmy
UPDATE SBA33 Set filler=filler
go