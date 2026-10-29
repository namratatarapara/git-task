-- SQL TASK 05: BASIC SALES SUMMARY
-- Calculate total orders, revenue, average order value, highest sale and lowest sale.
use DataAnalystpractice;
go

-- 1. Count the total number of sales records
select count(*) as TotalOrders
from dbo.Sales;

-- 2. Calculate total sales revenue
-- Revenue = Quantity * Price
select sum(Quantity * price) as TotalRevenue
from dbo.Sales;
	
-- 3. Calculate the average sale value per record
select AVG(cast(Quantity * price as decimal(12,2)))
	as AverageOrderValue
from dbo.Sales;

-- 4. Find the highest sale value
select max(Quantity * price) as HighestSale
from dbo.Sales;

-- 5. Find the lowest sale value
select min(Quantity * price) as LowestSale
from dbo.Sales;

-- 6. Generate a complete sales summary in one result
-- Includes total records, revenue, average, highest and lowest sale
select
    count(*) as TotalOrders,
    sum(Quantity * price) as TotalRevenue,
    cast(avg(Quantity * price) as decimal(12,2))
        as AverageOrderValue,
    max(Quantity * price) as HighestSale,
    min(Quantity * price) as LowestSale
from dbo.Sales;

