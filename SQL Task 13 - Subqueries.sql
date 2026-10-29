-- SQL 13 - Subqueries
-- Find orders above average value, customers spending above average and products priced above category average.
use DataAnalystpractice
go

select 
	OrderID,
	ProductName,
	Amount
from dbo.CustomerOrders
where Amount > (
	select AVG(Amount)
	from dbo.CustomerOrders
)
order by Amount desc;

select * from CustomerOrders;

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
select 
	CustomerID,
	CustomerName,
	TotalSpent
from CustomerSpending
where TotalSpent > (
	select avg(TotalSpent)
	from CustomerSpending
)
order by TotalSpent desc;

select 
	S.ProductName,
	S.Category,
	S.price
from dbo.Sales as S
where price > (
	select AVG(S2.price) 
	from dbo.Sales as S2
	where S2.Category = S.Category
)
order by S.Category,S.price desc;
