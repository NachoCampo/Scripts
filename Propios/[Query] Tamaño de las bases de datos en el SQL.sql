SELECT 
    DB_NAME(A.database_id) AS 'Nombre de la base de datos',
    CONVERT(decimal(12, 2), SUM(size) * 8.0 / 1024) AS 'Tama�o (MB)',
    create_date AS 'Fecha de creaci�n'
FROM sys.master_files A join sys.databases B on
B.database_id = A.database_id
GROUP BY A.database_id, create_date
Order by [Tama�o (MB)]

