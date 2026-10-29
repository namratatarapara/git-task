-- -- SQL TASK 07: HAVING & AGGREGATE FILTERS
-- Filter grouped results, such as categories with revenue above a target or customers with multiple orders.

use DataAnalystpractice;
go

select * from dbo.Sales;

-- 1. Find categories with total revenue greater than 100000
select Category,	
	SUM(Quantity * price) as TotalRevenue
from dbo.Sales
group by Category
having SUM(Quantity * price) > 100000;

-- 2. Find regions with more than one sales record
select Region,
	Count(*) as OrderCount
from dbo.Sales
group by Region
having Count(*) > 1;

-- 3. Find products with total quantity sold greater than 2
select ProductName,	
	SUM(Quantity) as TotalQuantity
from dbo.Sales
group by ProductName
having SUM(Quantity) > 2;

-- 4. Find Electronics products with revenue greater than 100000
-- WHERE filters rows before grouping
-- HAVING filters grouped results after aggregation
select
    ProductName,
    SUM(Quantity * Price) as TotalRevenue
from dbo.Sales
where Category = 'Electronics'
group by ProductName
having SUM(Quantity * Price) > 100000;

-- 5. Find products with total revenue below 50000
-- Sort qualifying products from highest to lowest revenue
select
    ProductName,
    SUM(Quantity * Price) as TotalRevenue
from dbo.Sales
group by ProductName
having SUM(Quantity * Price) < 50000
order by TotalRevenue desc;	



	