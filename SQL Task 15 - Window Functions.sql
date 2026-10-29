-- SQL 15 - Window Functions
-- Practice ROW_NUMBER, RANK, DENSE_RANK, LAG and LEAD for ranking and period comparisons.
use DataAnalystpractice
go

with ProductRevenue as (
	select
		P.ProductName,
		P.Category,
		SUM(I.Quantity * I.UnitPrice) as TotalRevenue
		from dbo.OrderItems as I
		inner join dbo.Products as P
			on I.ProductID = P.ProductID
		group by P.ProductName,P.Category
)
select 
	ProductName,
	Category,
	TotalRevenue,
	ROW_NUMBER() over (
		order by TotalRevenue desc
	) as RowNumber
from ProductRevenue;

with ProductRevenue as (
	select
		P.ProductName,
		SUM(I.Quantity * I.UnitPrice) as TotalRevenue
		from dbo.OrderItems as I
		inner join dbo.Products as P
			on I.ProductID = P.ProductID
		group by P.ProductName
)
select 
	ProductName,
	TotalRevenue,
	RANK() over (
		order by TotalRevenue desc
	) as RevenueRank,
	DENSE_RANK() over (
		order by TotalRevenue desc
	) as DenseRevenueRank
from ProductRevenue
order by TotalRevenue;

with ProductRevenue as (
    select 'Laptop' as ProductName, 50000 as TotalRevenue
    union all
    select 'Monitor', 25000
    union all
    select 'Keyboard', 25000
    union all
    select 'Mouse', 1500
)
select
    ProductName,
    TotalRevenue,
    RANK() over (
        order by TotalRevenue desc
    ) AS RevenueRank,
    DENSE_RANK() over (
        order by TotalRevenue desc
    ) as DenseRevenueRank
from ProductRevenue
order by TotalRevenue desc, ProductName;

select 
	OrderId,
	CONVERT(VARCHAR(10), OrderDate, 105) as OrderDate,
	ProductName,
	Region,
	Quantity * price as SalesAmount,
	LAG(Quantity * price) over (
		Order by OrderId,OrderDate
	) as PreviousSalesAmount
from dbo.Sales
order by OrderId,OrderDate;

select 
	OrderID,
	CONVERT(VARCHAR(10), OrderDate, 105) as OrderDate,
	ProductName,
	Region,
	Quantity * price as SalesAmount,
	LEAD(Quantity * price) over (
		order by OrderID,OrderDate
	) as NextSalesAmount
from dbo.Sales
order by OrderID,OrderDate;

SELECT
    OrderID,
	CONVERT(VARCHAR(10), OrderDate, 105) as OrderDate,
    ProductName,
    Quantity * price AS SalesAmount,
    LAG(Quantity * price) OVER (
        ORDER BY OrderDate, OrderID
    ) AS PreviousSales,
    LEAD(Quantity * price) OVER (
        ORDER BY OrderDate, OrderID
    ) AS NextSales
FROM dbo.Sales
ORDER BY OrderID,OrderDate;