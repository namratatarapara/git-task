-- SQL 16 - Ranking & Top-N Analysis
-- Find top 3 products per category and top customers per region; handle ties appropriately.

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
	group by 
		P.ProductName,
		P.Category
),
RankedProducts as (
	select 
		ProductName,
		Category,
		TotalRevenue,
		ROW_NUMBER() over (
			partition by Category
			order by TotalRevenue desc,ProductName 
			) as ProductRank
		from ProductRevenue
)
select *
from RankedProducts
where ProductRank <= 3
order by Category,ProductRank,ProductName;


with PracticeRevenue as (
    select 'Laptop' as ProductName, 'Electronics' as Category, 50000 as TotalRevenue
    union all
    select 'Monitor', 'Electronics', 25000
    union all
    select 'Webcam', 'Electronics', 15000
    union all
    select 'Headphones', 'Electronics', 15000
    union all
    select 'Mouse', 'Accessories', 1500
    union all
    select 'Keyboard', 'Accessories', 1200
),
RankedProducts as (
    select
        ProductName,
        Category,
        TotalRevenue,
        RANK() over (
            partition by Category
            order by TotalRevenue desc
        ) as ProductRank
    from PracticeRevenue
)
select
    ProductName,
    Category,
    TotalRevenue,
    ProductRank
from RankedProducts
where ProductRank <= 3
order by Category, ProductRank, ProductName;


with RegionRevenue as (
	select 
		Region,
		SUM(Quantity * price) as TotalRevenue
	from dbo.Sales
	group by Region
)
select 
	Region,
	TotalRevenue,
	RANK() over (
		order by TotalRevenue desc
	) as RegionRank
from RegionRevenue
order by RegionRank;


with CustomerRevenue as (
    select 'Asha' as CustomerName, 'West' as Region, 51200 as TotalSpent
    union all
    select 'Jay', 'West', 50000
    union all
    select 'Riya', 'West', 15000
    union all
    select 'Ramesh', 'East', 25000
    union all
    select 'Neha', 'East', 25000
    union all
    select 'Kiran', 'East', 10000
),
RankedCustomers as (
    select
        CustomerName,
        Region,
        TotalSpent,
        RANK() over (
            partition by Region
            order by TotalSpent desc
        ) as CustomerRank
    from CustomerRevenue
)
select
    CustomerName,
    Region,
    TotalSpent,
    CustomerRank
from RankedCustomers
order by Region, CustomerRank, CustomerName;