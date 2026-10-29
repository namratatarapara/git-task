--  SQL TASK 01: DATABASE & TABLE EXPLORATION
-- Research databases, tables, rows, columns, data types, primary keys and foreign keys. Explore the training schema.
-- Create the DataAnalystpractice database
-- Select the database for SQL practice
-- Check the current database name
select name
from sys.databases
order by name;

USE DataAnalystpractice;
GO

select table_name
from INFORMATION_SCHEMA.TABLES
Where TABLE_TYPE = 'Base Table';

-- Create the Sales table with columns and data types
-- Set OrderID as the Primary Key
Select 
	column_name,
	data_type,
	is_nullable
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'Sales'
order by ORDINAL_POSITION;

select 
	constraint_name,
	column_name
from INFORMATION_SCHEMA.KEY_COLUMN_USAGE
where TABLE_NAME = 'Sales'
AND OBJECTPROPERTY(
	OBJECT_ID(CONSTRAINT_NAME),
	'IsPrimaryKey'
) = 1;

select 
	name as ForeignKeyName,
	OBJECT_NAME(parent_object_id) as TableName
from sys.foreign_keys;

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_SCHEMA, TABLE_NAME;

select 
	count(*) as TotalRows
from dbo.Sales;

exec sp_help 'dbo.Sales';