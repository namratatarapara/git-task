-- SQL TASK 04: AGGREGATE FUNCTIONS
-- Use COUNT, SUM, AVG, MIN and MAX to summarize orders and sales.

-- 1. Count the total number of sales records
select count(*) as TotalOrders 
from dbo.Sales;

-- 2. Calculate total quantity sold and total revenue
-- Revenue = Quantity * Price
select 
	sum(Quantity) as TotalQuantity,
	sum(Quantity * price) as TotalRevenue
from dbo.Sales;

-- 3. Calculate the average product price and average quantity
select 
	AVG(price) as AveragePrice,
	AVG(cast(Quantity as decimal(10,2))) as AverageQuantity
from dbo.Sales;

-- 4. Find the lowest and highest product prices
select 
	MIN(price) as LowestPrice,
	MAX(price) as HighestPrice
from dbo.Sales;