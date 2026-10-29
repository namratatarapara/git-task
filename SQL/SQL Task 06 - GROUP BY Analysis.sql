-- SQL 06 - GROUP BY Analysis
-- Analyze revenue and order counts by region, category, product and month.

use DataAnalystpractice;
go

-- Update OrderDate using OrderID
-- Updates the order dates for OrderID 1 to 5.
update dbo.Sales 
set orderID = case OrderID
    when 1 then '2026-01-15'
    when 2 then '2026-01-20'
    when 3 then '2026-02-21'
    when 4 then '2026-02-24'
    when 5 then '2026-03-01'
end
WHERE OrderID IN (1, 2, 3, 4, 5);

-- Display dates in DD-MM-YYYY format
-- Displays dates in day-month-year format.
select OrderID, ProductName, OrderDate,
 convert(varchar(10), OrderDate, 105) as OrderDate
from dbo.Sales
order by OrderID;

select * from dbo.Sales;

-- Product-wise sales analysis
-- Finds the number of records and total revenue for each product, from highest to lowest revenue.
select ProductName,
    count(*) as OrderCount,
    sum(Quantity * price) as TotalRevenue
from dbo.Sales
group by ProductName
order by TotalRevenue desc;

-- Category-wise sales analysis
-- Compares order counts and revenue across product categories.
select 
    Category,
    count(*) as OrderCount,
    sum(Quantity * price) as TotalRevenue
from dbo.Sales
group by Category
order by TotalRevenue desc;

-- Region-wise sales analysis
-- Identifies the regions generating the highest revenue.
select Region,
    Count(*) as OrderCount,
    sum(Quantity * price) as TotalRevenue
from dbo.Sales
group by Region
order by TotalRevenue;

-- Monthly sales analysis
-- Calculates monthly order counts and revenue to identify sales trends.
select 
    YEAR(OrderDate) as SalesYear,
    MONTH(orderDate) as SalesMonth,
    count(*)  as OrderCount,
    sum(Quantity * price) as TotalRevenue
from dbo.Sales
group by 
    YEAR(OrderDate),
    MONTH(OrderDate)
order by
    SalesYear,
    SalesMonth;

     