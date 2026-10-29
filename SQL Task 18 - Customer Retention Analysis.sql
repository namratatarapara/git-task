-- SQL 18 - Customer Retention Analysis
-- Identify first-time and repeat customers, returning customers and retention trends.

use DataAnalystpractice
go

select 
	CustomerID,
	COUNT(*) as TotalOrders,
	MIN(OrderDate) as FirstOrderDate,
	MAX(OrderDate) as LastOrderDate,
	case 
		when COUNT(*) = 1 then 'First-Time  Customer'
		else 'Repeat Customer'
	end as CustomerType
from dbo.Orders
group by CustomerID
order by TotalOrders desc;


with CustomerOrderCount as (
	select
		CustomerID,
		COUNT(*) as TotalOrders
		from dbo.Orders
		group by CustomerID
)
select 
	COUNT(*) as TotalCustomers,
	SUM(case 
		when TotalOrders > 1 then 1
		else 0
		end) as RepeatCustomers,
	CONCAT(
	CAST(
		SUM(case
			when TotalOrders > 1 then 1.0
			else 0  
			end) * 100.0 /NULLIF(COUNT(*),0)
			as decimal(10,2)
			),
			'%'
		) as RepeatCustomerRate
from CustomerOrderCount;


with CustomerOrderDates as (
    select
        CustomerID,
        OrderID,
        OrderDate,
        ROW_NUMBER() over (
            partition by CustomerID
            Order by OrderDate, OrderID
        ) as OrderNumber
    from dbo.Orders
)
select
    CustomerID,
    OrderID,
    OrderDate as ReturningOrderDate
from CustomerOrderDates
where OrderNumber = 2
order by CustomerID;


with SampleOrders as (
    select *
    from (values
        (101, 1, CAST('2026-01-05' as date)),
        (102, 2, CAST('2026-01-10' as date)),
        (103, 1, CAST('2026-02-05' as date)),
        (104, 3, CAST('2026-02-12' as date)),
        (105, 1, CAST('2026-03-05' as date)),
        (106, 2, CAST('2026-03-10' as date))
    ) as O(OrderID, CustomerID, OrderDate)
),
CustomerFirstOrder as (
    SELECT *,
        MIN(OrderDate) over (
            partition by CustomerID
        ) as FirstOrderDate
    from SampleOrders
)
select
    YEAR(OrderDate) as SalesYear,
    MONTH(OrderDate) as SalesMonth,
    COUNT(distinct CustomerID) as ActiveCustomers,
    COUNT(distinct case
        when YEAR(OrderDate) = YEAR(FirstOrderDate)
         and MONTH(OrderDate) = MONTH(FirstOrderDate)
        then CustomerID
    end) as NewCustomers,
    COUNT(distinct CustomerID) -
    COUNT(distinct case
        when YEAR(OrderDate) = YEAR(FirstOrderDate)
         and MONTH(OrderDate) = MONTH(FirstOrderDate)
        then CustomerID
    end) as ReturningCustomers
from CustomerFirstOrder
group by YEAR(OrderDate), MONTH(OrderDate)
order by SalesYear, SalesMonth;


with SampleOrders as (
    select *
    from (values
        (101, 1, CAST('2026-01-05' as date)),
        (102, 2, CAST('2026-01-10' as date)),
        (103, 1, CAST('2026-02-05' as date)),
        (104, 3, CAST('2026-02-12' as date)),
        (105, 1, CAST('2026-03-05' as date)),
        (106, 2, CAST('2026-03-10' as date))
    ) as O(OrderID, CustomerID, OrderDate)
),
MonthlyCustomers as (
    select distinct
        YEAR(OrderDate) as SalesYear,
        MONTH(OrderDate) as SalesMonth,
        CustomerID
    from SampleOrders
)
select
    C.SalesYear,
    C.SalesMonth,
    COUNT(*) as ActiveCustomers,
    SUM(case when P.CustomerID is not null
        then 1 
        else 0 
        end) as RetainedCustomers,
    CONCAT(
        CAST(
            SUM(case 
                when P.CustomerID is not null then 1.0 
                else 0 
                end) * 100.0 / NULLIF(COUNT(*), 0)
            as decimal(5,2)
        ), '%'
    ) as RetentionRate
from MonthlyCustomers C
left join MonthlyCustomers P
    on C.CustomerID = P.CustomerID
    and DATEFROMPARTS(C.SalesYear, C.SalesMonth, 1)
        = DATEADD(MONTH, 1,
            DATEFROMPARTS(P.SalesYear, P.SalesMonth, 1))
group by C.SalesYear, C.SalesMonth
order by C.SalesYear, C.SalesMonth;