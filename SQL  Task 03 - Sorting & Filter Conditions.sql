-- SQL TASK 03: SORTING & FILTER CONDITIONS
-- Practice ORDER BY, AND, OR, NOT, IN, BETWEEN and LIKE with sales/customer data.

-- 1. Display products sorted by price from highest to lowest
SELECT ProductName, Price
FROM dbo.Sales
ORDER BY Price DESC;

-- 2. Find Electronics products with a price above 10000
select * 
from dbo.Sales
where Category = 'Electronics'
	and price > 10000;

-- 3. Find sales from either the West or North region
select * 
from dbo.Sales
where Region = 'West'
	or Region= 'North';

-- 4. Display products that are not in the Electronics category
select * 
from dbo.Sales
where not Category = 'Electronics';

-- 5. Exclude Electronics products using the not-equal operator
select * 
from dbo.Sales
where Category <> 'Electronics';

-- 6. Display sales records outside the West region
select *
from dbo.Sales
where not Region = 'West';

-- 7. Find sales from the West or North regions using IN
select * 
from dbo.Sales
where Region in ('West','North');

-- 8. Find products priced between 1000 and 30000, inclusive
select *
from dbo.Sales
where Price BETWEEN 1000 AND 30000;

-- 9. Find product names that start with the letter M
select *
from dbo.Sales
where ProductName like 'M%';

-- 10. Find products priced below 10000, sorted lowest first
select * 
from dbo.Sales
where price < 10000
order by price asc;

-- 11. Find Electronics products with quantity greater than 1
select *
from dbo.Sales
where Category = 'Electronics' 
	and Quantity > 1;

-- 12. Find sales from either the East or West region using OR
select * 
from dbo.Sales
where Region = 'East' 
	or Region = 'West';

-- 13. Find sales from East or West using IN
Select *
from dbo.Sales
where Region IN ('East', 'West');

-- 14. Find product names containing the word 'top'
select *
from dbo.Sales
where ProductName like '%top%';	

-- 15. Find products priced outside the range 1000 to 20000
select *
from dbo.Sales
where price not between 1000 and 20000;