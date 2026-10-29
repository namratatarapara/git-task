-- SQL 17 - Monthly Sales & Growth
-- Calculate monthly revenue, order counts, average order value and month-over-month growth.
use DataAnalystpractice
go


with MonthlySales as (
    select
        YEAR(OrderDate) as SalesYear,
        MONTH(OrderDate) as SalesMonth,
        COUNT(*) as OrderCount,
        SUM(Quantity * price) as TotalRevenue
    from dbo.Sales
    group by
        YEAR(OrderDate),
        MONTH(OrderDate)
)
select
    SalesYear,
    SalesMonth,
    OrderCount,
    TotalRevenue,
    CAST(
        TotalRevenue * 1.0 / OrderCount
        as decimal(12, 2)
    ) as AverageOrderValue
from MonthlySales
order by SalesYear, SalesMonth;


with MonthlySales as (
    select
        YEAR(OrderDate) as SalesYear,
        MONTH(OrderDate) as SalesMonth,
        SUM(Quantity * price) as TotalRevenue
    from dbo.Sales
    group by
        YEAR(OrderDate),
        MONTH(OrderDate)
),
MonthlyComparison as (
    select
        SalesYear,
        SalesMonth,
        TotalRevenue,
        LAG(TotalRevenue) over (
            order by SalesYear, SalesMonth
        ) as PreviousMonthRevenue
    from MonthlySales
)
select
    SalesYear,
    SalesMonth,
    TotalRevenue,
    PreviousMonthRevenue,
    CONCAT(
    CAST(
        (TotalRevenue - PreviousMonthRevenue) * 100.0
        / NULLIF(PreviousMonthRevenue, 0)
        as decimal(10, 2)
    ), 
    '%'
    ) as MoMGrowthPercent
from MonthlyComparison
order by SalesYear, SalesMonth;