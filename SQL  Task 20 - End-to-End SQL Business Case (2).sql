-- SQL task 20

use SQL20_BusinessCase;
go

-- Step 6:Remove Duplicate Records Safely
-- Find duplicate records
select
    OrderID,
    CustomerID,
    ProductID,
    OrderDate,
    Quantity,
    UnitPrice,
    Discount,
    COUNT(*) as DuplicateCount
from dbo.OrdersDetail_Backup
group by
    OrderID,
    CustomerID,
    ProductID,
    OrderDate,
    Quantity,
    UnitPrice,
    Discount
having COUNT(*) > 1;

-- Create duplicate test data
if OBJECT_ID('dbo.Duplicate_Practice', 'U') IS NOT NULL
    drop table dbo.Duplicate_Practice;
go

create table dbo.Duplicate_Practice (
    RecordID int identity(1,1) primary key,
    OrderID int,
    CustomerID int,
    Amount decimal(10,2)
);

insert into dbo.Duplicate_Practice
    (OrderID, CustomerID, Amount)
values
    (1001, 1, 500),
    (1002, 2, 700),
    (1002, 2, 700),
    (1003, 3, 900);

select *
from dbo.Duplicate_Practice;

-- Identify duplicates using ROW_NUMBER()

with DuplicateCheck as (
    select *,
        ROW_NUMBER() over (
            partition by OrderID, CustomerID, Amount
            order by RecordID
        ) as RowNum
    from dbo.Duplicate_Practice
)
select *
from DuplicateCheck
where RowNum > 1;

-- Remove only the extra copy
-- Delete using RecordID
select *
from dbo.Duplicate_Practice
where OrderID = 1002
  AND CustomerID = 2
  AND Amount = 700
order by RecordID;

delete from dbo.Duplicate_Practice
where RecordID = 3;

select *
from dbo.Duplicate_Practice;

--  step-7 Validate Returns and Calculate Return Impact
-- View all returned items
select
    r.ReturnID,
    r.OrderLineID,
    o.OrderID,
    o.ProductID,
    o.Quantity as PurchasedQuantity,
    r.ReturnQuantity,
    r.ReturnDate
from dbo.ReturnsDetail as r
inner join dbo.OrdersDetail as o
    on r.OrderLineID = o.OrderLineID
order by r.ReturnDate

-- Find returns exceeding purchased quantities
select 
    o.OrderLineID,
    o.Quantity as PurchasedQuantity,
    SUM(r.ReturnQuantity) as TotalReturned
from dbo.OrdersDetail as o
inner join dbo.ReturnsDetail as r
    on o.OrderLineID = r.OrderLineID
group by
    o.OrderLineID,
    o.Quantity
having SUM(r.ReturnQuantity) > o.Quantity;

-- Calculate total returned units
select
    SUM(ReturnQuantity) as TotalReturnedUnits,
    COUNT(*) as TotalReturnRecords
from dbo.ReturnsDetail;

-- Calculate revenue by product
select
    SUM(o.Quantity * o.UnitPrice * (1 - o.Discount))
        as RevenueBeforeReturns,

    SUM(
        COALESCE(r.ReturnQuantity, 0)
        * o.UnitPrice * (1 - o.Discount)
    ) as ReturnedSalesValue,

    SUM(
        (o.Quantity - COALESCE(r.ReturnQuantity, 0))
        * o.UnitPrice * (1 - o.Discount)
    ) as EstimatedRevenueAfterReturns

from dbo.OrdersDetail AS o

left join (
    select
        OrderLineID,
        SUM(ReturnQuantity) as ReturnQuantity
    from dbo.ReturnsDetail
    group by OrderLineID
) as r
    on o.OrderLineID = r.OrderLineID;

-- Step 8:Monthly Sales Trend Analysis
-- Calculate monthly sales
select
    YEAR(OrderDate) as SalesYear,
    MONTH(OrderDate) as SalesMonth,
    COUNT(distinct OrderID) as TotalOrders,
    SUM(Quantity) as TotalUnitsSold,
    SUM(Quantity * UnitPrice) as GrossRevenue,
    SUM(Quantity * UnitPrice * (1 - Discount)) as NetRevenue
from dbo.OrdersDetail
group by
    YEAR(OrderDate),
    MONTH(OrderDate)
order by
    SalesYear,
    SalesMonth;

-- Calculate month-over-month revenue growth
with MonthlySales as
(
    select
        DATEFROMPARTS(
            YEAR(OrderDate),
            MONTH(OrderDate),
            1
        ) as SalesMonth,
        SUM(
            Quantity * UnitPrice * (1 - Discount)
        ) as NetRevenue
    from dbo.OrdersDetail
    group by
        YEAR(OrderDate),
        MONTH(OrderDate)
),
SalesGrowth as
(
    select
        SalesMonth,
        NetRevenue,
        LAG(NetRevenue) over (
            order by SalesMonth
        ) as PreviousMonthRevenue
    from MonthlySales
)
select
    SalesMonth,
    NetRevenue,
    PreviousMonthRevenue,
    ROUND(
        (NetRevenue - PreviousMonthRevenue)
        * 100.0
        / NULLIF(PreviousMonthRevenue, 0),
        2
    ) as GrowthPercentage
from SalesGrowth
order by SalesMonth;

-- Find the best and worst months
with MonthlySales as
(
    select
        DATEFROMPARTS(
            YEAR(OrderDate),
            MONTH(OrderDate),
            1
        ) as SalesMonth,
        SUM(
            Quantity * UnitPrice * (1 - Discount)
        ) as NetRevenue
    from dbo.OrdersDetail
    group by
        YEAR(OrderDate),
        MONTH(OrderDate)
),
RankedMonths as
(
    select
        SalesMonth,
        NetRevenue,
        ROW_NUMBER() over (
            order by NetRevenue desc
        ) as BestRank,
        ROW_NUMBER() over (
            order by NetRevenue asc
        ) as WorstRank
    from MonthlySales
)
select
    SalesMonth,
    NetRevenue,
    case
        when BestRank = 1 then 'Best Month'
        when WorstRank = 1 then 'Worst Month'
    end as Performance
from RankedMonths
where BestRank = 1
   OR WorstRank = 1
order by NetRevenue desc;

-- Step 9: Profitability Investigation
-- Calculate profit for each product
select
    p.ProductID,
    p.ProductName,
    SUM(
        o.Quantity * o.UnitPrice * (1 - o.Discount)
    ) as NetRevenue,
    SUM(
        o.Quantity * p.UnitCost
    ) as TotalCost,
    SUM(
        o.Quantity * o.UnitPrice * (1 - o.Discount)
        - o.Quantity * p.UnitCost
    ) as EstimatedProfit
from dbo.OrdersDetail as o
JOIN dbo.ProductsDetails as p
    on o.ProductID = p.ProductID
group by
    p.ProductID,
    p.ProductName
ORDER BY EstimatedProfit desc;

-- Calculate profit margin
select
    p.ProductName,
    FORMAT(
        SUM(o.Quantity * o.UnitPrice * (1 - o.Discount)),
        'N2'
    ) AS NetRevenue,
    FORMAT(
        SUM(
            o.Quantity * o.UnitPrice * (1 - o.Discount)
            - o.Quantity * p.UnitCost
        ),
        'N2'
    ) as EstimatedProfit,
    CONCAT(
        CAST(
        ROUND(
            100.0 * SUM(
                o.Quantity * o.UnitPrice * (1 - o.Discount)
                - o.Quantity * p.UnitCost
            )
            / NULLIF(
                SUM(o.Quantity * o.UnitPrice * (1 - o.Discount)),
                0
            ),
            2
        ) as decimal(10,2)
        ),
        '%'
    ) as ProfitMarginPercentage
from dbo.OrdersDetail as o
join dbo.ProductsDetails as p
    on o.ProductID = p.ProductID
group by p.ProductName
order by
    SUM(
        o.Quantity * o.UnitPrice * (1 - o.Discount)
        - o.Quantity * p.UnitCost
    ) desc;

-- Identify loss-making products
with ProductProfit as
(
    select
        p.ProductID,
        p.ProductName,
        SUM(
            o.Quantity * o.UnitPrice * (1 - o.Discount)
        ) as NetRevenue,
        SUM(
            o.Quantity * o.UnitPrice * (1 - o.Discount)
            - o.Quantity * p.UnitCost
        ) as EstimatedProfit
    from dbo.OrdersDetail as o
    join dbo.ProductsDetails as p
        on o.ProductID = p.ProductID
group by
    p.ProductID,
    p.ProductName
)
select
    ProductID,
    ProductName,
    NetRevenue,
    EstimatedProfit
from ProductProfit
where NetRevenue > 0
  AND EstimatedProfit < 0
order by EstimatedProfit asc;

--Compare Net Revenue, Total Cost, and Estimated Profit by Product
select
    p.ProductName,
    SUM(
        o.Quantity * o.UnitPrice * (1 - o.Discount)
    ) as NetRevenue,
    SUM(
        o.Quantity * p.UnitCost
    ) as TotalCost,
    SUM(
        o.Quantity * o.UnitPrice * (1 - o.Discount)
        - o.Quantity * p.UnitCost
    ) as EstimatedProfit
from dbo.OrdersDetail as o
JOIN dbo.ProductsDetails as p
    on o.ProductID = p.ProductID
group by p.ProductName
order by EstimatedProfit asc;

--Step 10: Business Performance Validation
-- Validate revenue and profit totals
select
    SUM(o.Quantity * o.UnitPrice)
        as GrossRevenue,
    SUM(o.Quantity * o.UnitPrice * o.Discount)
        as TotalDiscount,
    SUM(o.Quantity * o.UnitPrice * (1 - o.Discount))
        as NetRevenue,
    SUM(o.Quantity * p.UnitCost)
        as TotalCost,
    SUM(
        o.Quantity * o.UnitPrice * (1 - o.Discount)
        - o.Quantity * p.UnitCost
    ) as EstimatedProfit
from dbo.OrdersDetail as o
join dbo.ProductsDetails as p
    on o.ProductID = p.ProductID;

-- Check whether the revenue calculation reconciles
select
    SUM(Quantity * UnitPrice)
      - SUM(Quantity * UnitPrice * Discount)
        as CalculatedNetRevenue,
    SUM(Quantity * UnitPrice * (1 - Discount))
        as DirectNetRevenue,
    SUM(Quantity * UnitPrice)
      - SUM(Quantity * UnitPrice * Discount)
      - SUM(Quantity * UnitPrice * (1 - Discount))
        as Difference
from dbo.OrdersDetail;

-- Step 11: Final Business Findings
-- Create a final product performance report
select
    p.ProductID,
    p.ProductName,
    SUM(
        o.Quantity * o.UnitPrice * (1 - o.Discount)
    ) as NetRevenue,
    SUM(o.Quantity * p.UnitCost) as TotalCost,
    SUM(
        o.Quantity * o.UnitPrice * (1 - o.Discount)
        - o.Quantity * p.UnitCost
    ) as EstimatedProfit,
    CONCAT(
        CAST(
        100.0 * SUM(
            o.Quantity * o.UnitPrice * (1 - o.Discount)
            - o.Quantity * p.UnitCost
        )
        / NULLIF(
            SUM(o.Quantity * o.UnitPrice * (1 - o.Discount)),
            0
        ) as decimal(10,2)
    ),
    '%'
    )
    as ProfitMarginPercentage
from dbo.OrdersDetail as o
join dbo.ProductsDetails as p
    on o.ProductID = p.ProductID
group by
    p.ProductID,
    p.ProductName
order by EstimatedProfit desc;

-- Create a management KPI summary
select
    COUNT(distinct OrderID) as TotalOrders,
    SUM(Quantity) as TotalUnitsSold,
    SUM(
        Quantity * UnitPrice * (1 - Discount)
    ) as NetRevenue,
    SUM(
        Quantity * p.UnitCost
    ) as TotalCost,
    SUM(
        Quantity * UnitPrice * (1 - Discount)
        - Quantity * p.UnitCost
    ) as EstimatedProfit
from dbo.OrdersDetail as o
join dbo.ProductsDetails as p
    on o.ProductID = p.ProductID;

-- Step 12: Final Business Case Report
-- final KPI summary
select
    COUNT(DISTINCT o.OrderID) as TotalOrders,
    SUM(o.Quantity) as TotalUnitsSold,
    SUM(
        o.Quantity * o.UnitPrice
    ) as GrossRevenue,
    SUM(
        o.Quantity * o.UnitPrice * o.Discount
    ) as TotalDiscount,
    SUM(
        o.Quantity * o.UnitPrice * (1 - o.Discount)
    ) as NetRevenue,
    SUM(
        o.Quantity * p.UnitCost
    ) as TotalProductCost,
    SUM(
        o.Quantity * o.UnitPrice * (1 - o.Discount)
        - o.Quantity * p.UnitCost
    ) as EstimatedProfit
from dbo.OrdersDetail as o
join dbo.ProductsDetails as p
    on o.ProductID = p.ProductID;


/*
SQL 20 - END-TO-END BUSINESS CASE
TASK SUMMARY

1. Database and Table Creation
2. Data Insertion
3. Data Quality Validation
4. Data Cleaning Practice
5. Business KPI Analysis
6. Duplicate Detection
7. Returns Analysis
8. Monthly Sales Trend Analysis
9. Product Profitability Analysis
10. KPI Validation
11. Business Findings
12. Final Report and Recommendations

Tools: SQL Server Management Studio (SSMS)
Language: T-SQL
Project Type: Business Data Analysis
*/
