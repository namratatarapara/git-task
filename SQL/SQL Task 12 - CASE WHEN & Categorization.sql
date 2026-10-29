-- SQL 12 - CASE WHEN & Categorization
-- Create order-value bands, customer segments and readable status categories with CASE WHEN.
use DataAnalystpractice
go

select 
	OrderID,
	ProductName,
	Amount,
	case 
		when Amount >= 50000 then 'High Value'
		when Amount >= 10000 then 'Medium Value'
		else 'Low Value'
		end as OrderCategory
from dbo.CustomerOrders
order by Amount desc;

select 
	C.CustomerID,
	C.CustomerName,
	SUM(O.Amount) as TotalSpending,
	case 
		when SUM(O.Amount) >= 50000 then 'Premium'
		when SUM(O.Amount) >= 20000 then 'Regular'
		else 'Basic'
	end as CustomerSegment
from dbo.Customers as C
left join dbo.CustomerOrders as O
	on C.CustomerID = O.CustomerID
group by 
	C.CustomerID,
	C.CustomerName
order by TotalSpending desc;

select 
	OrderID,
	ProductName,
	Amount,
	case 
	when Amount is null then 'Missing Amount'
	when Amount <= 0 then 'Invalid Amount'
	when Amount >= 50000 then 'Review High value'
	else 'Normal'
	end as ReviewStatus
from dbo.CustomerOrders;

select
    OrderID,
    ProductName,
    Amount,
    case
        when Amount IS NULL then 'Missing Amount'
        when Amount <= 0 then 'Invalid Amount'
        when Amount >= 50000 then 'High Value'
        when Amount >= 10000 then 'Medium Value'
        else 'Low Value'
    end as OrderCategory,
    case
        when Amount >= 50000 then 'Review Required'
        else 'Normal'
    end as ReviewStatus
from dbo.CustomerOrders
order by Amount desc;