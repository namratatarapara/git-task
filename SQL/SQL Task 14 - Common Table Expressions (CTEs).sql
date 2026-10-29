-- SQL 14 - Common Table Expressions (CTEs)
-- Rewrite a multi-step analysis using WITH clauses and explain each step.
use DataAnalystpractice
go

with CustomerSpending as (
	select 
		C.CustomerID,
		C.CustomerName,
		SUM(O.Amount) as TotalSpent
	from dbo.Customers as C
	inner join dbo.CustomerOrders as O
		on C.CustomerID = O.CustomerID
	group by
		C.CustomerID,
		C.CustomerName
)
select * 
from CustomerSpending;

with CustomerSpending as (
	select
		C.CustomerID,
		C.CustomerName,
		SUM(O.Amount) as TotalSpent
	from dbo.Customers as C
	inner join dbo.CustomerOrders as O
		on C.CustomerID = O.CustomerID
	group by
		C.CustomerID,
		C.CustomerName
),
AverageSpending as (
	select AVG(TotalSpent) as AverageSpent
	from CustomerSpending
)
select 
	CS.CustomerID,
	CS.CustomerName,
	CS.TotalSpent,
	A.AverageSpent
from CustomerSpending as CS
cross join AverageSpending as A
where CS.TotalSpent > A.AverageSpent
order by CS.TotalSpent desc;

with ProductRevenue as (
    select
        P.ProductID,
        P.ProductName,
        P.Category,
        SUM(I.Quantity * I.UnitPrice) as TotalRevenue
    from dbo.OrderItems as I
    inner join dbo.Products as P
        on I.ProductID = P.ProductID
    group by
        P.ProductID,
        P.ProductName,
        P.Category
),
AverageRevenue as (
    select AVG(TotalRevenue) as AvgRevenue
    from ProductRevenue
)
select
    PR.ProductName,
    PR.Category,
    PR.TotalRevenue,
    AR.AvgRevenue
from ProductRevenue as PR
cross join AverageRevenue as AR
where PR.TotalRevenue > AR.AvgRevenue
order by PR.TotalRevenue desc;

