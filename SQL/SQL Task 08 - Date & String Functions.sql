-- SQL TASK 08: DATE & STRING FUNCTIONS
-- Extract month/year, format dates, standardize text and find records within date ranges.
use DataAnalystpractice
go

-- 1. Extract the year and month from each order date
select 
	OrderID,
	ProductName,
	year(OrderDate) as SalesYear,
	month(OrderDate) as SalesMonth
from dbo.Sales;

select * from dbo.Sales;

-- 2. Convert the order date into DD-MM-YYYY format
select 
	OrderID,
	CONVERT(varchar(10), OrderDate, 105) as FormattedDate
from dbo.Sales;

-- 3. Convert product names to uppercase and regions to lowercase
-- Remove leading and trailing spaces from product names
select 
	ProductName,
	UPPER(ProductName) as UppercaseName,
	LOWER(Region) as LowercaseRegion,
	LTRIM(RTRIM(ProductName)) as CleanProductName
from dbo.Sales;

-- 4. Retrieve sales records from January 2026
select *
from dbo.Sales
where OrderDate >= '2026-01-01'
	and OrderDate < '2026-02-01';

-- 5. Calculate monthly sales count and total revenue
-- Group records by year and month
select 
	YEAR(OrderDate) as SalesYear,
	MONTH(OrderDate) as SalesMonth,
	COUNT(*) as SalesCount,
	sum(Quantity * price) as TotalRevenue
from dbo.Sales
group by YEAR(OrderDate), MONTH(OrderDate)
Order by SalesYear,SalesMonth;

-- 6. Find product names containing the text 'top'
select * 
from dbo.Sales
where ProductName like '%top%';

-- 7. Display uppercase product names, formatted dates, and date parts
-- Filter sales from January and February 2026
-- Sort records by order date from oldest to newest
SELECT
    OrderID,
    UPPER(ProductName) AS ProductName,
    CONVERT(VARCHAR(10), OrderDate, 105) AS FormattedDate,
    YEAR(OrderDate) AS SalesYear,
    MONTH(OrderDate) AS SalesMonth
FROM dbo.Sales
WHERE OrderDate >= '20260101'
  AND OrderDate < '20260301'
ORDER BY OrderDate ASC;
