-- SQL TASK 02: SELECT & FILTERING
-- Practice SELECT, WHERE, DISTINCT and LIMIT. Retrieve records matching business conditions.
use DataAnalystpractice
go

-- 1. Display all columns and rows from the Sales table
select * 
	from dbo.Sales;

-- 2. Display only ProductName and price columns
select ProductName,price 
from dbo.Sales;

-- 3. Find products with a price greater than 10000
select ProductName,price 
from dbo.Sales
Where price > 10000;

-- 4. Display sales records from the East region
select * 
from dbo.Sales
where Region = 'East';

-- 5. Find products priced between 1000 and 20000 (inclusive)
select ProductName,price 
from dbo.Sales
where price between 1000 and 20000;

-- 6. Display unique product categories
select distinct Category
from dbo.Sales;

-- 7. Display any 3 rows from the Sales table
select top 3 *
from dbo.Sales;

-- 8. Display the 3 highest-priced records
select top 3 ProductName,price 
from dbo.Sales
order by price desc;

-- 9. Find Electronics products priced above 10000
-- Sort the results from highest to lowest price
select ProductName,price,Category
from dbo.Sales
where Category = 'Electronics'
	and price > 10000
order by price desc;

-- 10. Display each order ID and its region
select OrderID,Region
from dbo.Sales;

-- 11. Find sales records where quantity is greater than 2
select * 
from dbo.Sales
where Quantity > 2;


-- 12. Display unique regions
select distinct Region
from dbo.Sales;

-- 13. Display all Electronics sales records
select *
from dbo.Sales
where Category = 'Electronics';

-- 14. Find products priced below 30000
select * 
from dbo.Sales
where price < 30000;

-- 15. Display the 2 lowest-priced records
select top 2 *
from dbo.Sales
order by price asc; 