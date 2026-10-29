/* SQL 19 - Profitability Investigation
Investigate why revenue may rise while profit falls using costs, discounts, returns and product mix.*/

use DataAnalystpractice
go

/* Exercise 1 — Calculate revenue, cost, and profit */

with SalesData as (
    select *
    from (values
        ('Laptop',   10, 50000.0, 35000.0,  5.0),
        ('Mouse',   100,   500.0,   300.0, 10.0),
        ('Monitor',  20, 25000.0, 20000.0, 15.0)
    ) as S(ProductName, Quantity, UnitPrice, UnitCost, DiscountPercent)
)
select
    ProductName,
    Quantity,
    UnitPrice,
    UnitCost,
    DiscountPercent,
    Quantity * UnitPrice as GrossRevenue,
    Quantity * UnitPrice * DiscountPercent / 100.0 as DiscountAmount,
    Quantity * UnitPrice * (1 - DiscountPercent / 100.0) as NetRevenue,
    Quantity * UnitCost as TotalCost,
    Quantity * UnitPrice * (1 - DiscountPercent / 100.0)
        - Quantity * UnitCost as Profit
from SalesData;

/*Exercise 2: Why Revenue Rises but Profit Falls */

with SalesData as (
    select *
    from (values
        ('January', 100, 1000.0, 600.0,  0.0),
        ('February',120, 1000.0, 850.0, 10.0)
    ) as S(MonthName, Quantity, UnitPrice, UnitCost, DiscountPercent)
)
select
    MonthName,
    Quantity,
    Quantity * UnitPrice as GrossRevenue,
    Quantity * UnitPrice * DiscountPercent / 100.0 as DiscountAmount,
    Quantity * UnitPrice * (1 - DiscountPercent / 100.0) as NetRevenue,
    Quantity * UnitCost as TotalCost,
    Quantity * UnitPrice * (1 - DiscountPercent / 100.0)
        - Quantity * UnitCost as Profit
from SalesData;

/* Exercise 3: Investigate How Returns Reduce Profit */
with SalesData as (
    select *
    from (values
        ('Laptop',  10, 50000.0, 35000.0, 2),
        ('Monitor', 20, 25000.0, 18000.0, 5),
        ('Mouse',  100,   500.0,   300.0, 10)
    ) as S(ProductName, Quantity, UnitPrice, UnitCost, ReturnedQty)
)
select
    ProductName,
    Quantity,
    ReturnedQty,
    (Quantity - ReturnedQty) * UnitPrice as NetRevenue,
    (Quantity - ReturnedQty) * UnitCost as RemainingCost,
    (Quantity - ReturnedQty) * (UnitPrice - UnitCost) as Profit
from SalesData;

/* Exercise 4: Analyze Product Mix and Profit Margin */
with SalesData as (
    select *
    from (values
        ('Laptop',  10, 50000.0, 35000.0),
        ('Monitor', 20, 25000.0, 20000.0),
        ('Mouse',  100,   500.0,   400.0)
    ) as S(ProductName, Quantity, UnitPrice, UnitCost)
)
select
    ProductName,
    Quantity,
    Quantity * UnitPrice as Revenue,
    Quantity * UnitCost as TotalCost,
    Quantity * (UnitPrice - UnitCost) as Profit,
    CAST(
        (UnitPrice - UnitCost) * 100.0
        / NULLIF(UnitPrice, 0)
        as decimal(10,2)
    ) as ProfitMarginPercent
from SalesData
order by Profit desc;

/* Exercise 5: Complete Profitability Investigation Report */
with SalesData as (
    select *
    from (Values
        ('Laptop',  10, 50000.0, 35000.0, 5.0, 2),
        ('Monitor', 20, 25000.0, 18000.0, 10.0, 5),
        ('Mouse',  100,   500.0,   300.0, 15.0, 10)
    ) as S(ProductName, Quantity, UnitPrice, UnitCost,
           DiscountPercent, ReturnedQty)
),
Report as (
    SELECT
        ProductName,
        Quantity,
        ReturnedQty,
        Quantity * UnitPrice as GrossRevenue,
        Quantity * UnitPrice * DiscountPercent / 100.0 as DiscountAmount,
        (Quantity - ReturnedQty) * UnitPrice
            * (1 - DiscountPercent / 100.0) as NetRevenue,
        (Quantity - ReturnedQty) * UnitCost as TotalCost
    from SalesData
)
select
    ProductName,
    GrossRevenue,
    DiscountAmount,
    NetRevenue,
    TotalCost,
    NetRevenue - TotalCost as Profit,
    CAST(
        (NetRevenue - TotalCost) * 100.0
        / NULLIF(NetRevenue, 0)
        as decimal(10,2)
    ) as ProfitMarginPercent
from Report
order by Profit desc;