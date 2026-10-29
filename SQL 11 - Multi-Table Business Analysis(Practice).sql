-- SQL TASK 11: MULTI-TABLE BUSINESS ANALYSIS
-- Join customers, orders, order_items and products to produce a detailed sales report without double-counting.
use DataAnalystpractice
go

-- 1. Explore columns and data types across the training tables
-- Check the structure of Customers, CustomerOrders, Orders,
-- OrderItems, Products, and Sales
select 
	TABLE_NAME,
	COLUMN_NAME,
	DATA_TYPE
from INFORMATION_SCHEMA.COLUMNS
where TABLE_SCHEMA = 'dbo'
	and TABLE_NAME in (
		'Customers',
		'CustomerOrders',
		'Orders',
		'OrderItems',
		'Products',
		'Sales'
)
order by TABLE_NAME,ORDINAL_POSITION;

-- 2. Combine customer, order, and product information
-- Match customers using CustomerID
-- Match products using ProductID
Select 
    C.CustomerName,
    O.OrderID,
    O.ProductID,
    P.ProductName,
    P.Category,
    P.ProductID,
    O.Amount
from dbo.Customers as C
inner join dbo.CustomerOrders as O
    on C.CustomerID = O.CustomerID
inner join dbo.Products as P
    on O.ProductID = P.ProductID;

-- 3. Calculate order rows and total revenue for each product
-- Group results by product name and category
-- Sort products from highest to lowest revenue
select 
	P.ProductName,
	P.Category,
	COUNT(O.OrderID) as OrderRows,
	SUM(O.Amount) as TotalRevenue
from dbo.Products as P
inner join dbo.CustomerOrders as O
	on P.ProductID = O.ProductID
group by 
	P.ProductName,
	P.Category
Order by TotalRevenue desc;

-- 4. Validate product IDs between CustomerOrders and Products
-- Compare the product names and IDs in both tables
select 
	O.OrderID,
	O.ProductName as OrderProduct,
	O.ProductID as OrderProductID,
	P.ProductName as ProductTableName,
	P.ProductID as ProductTableID,
	O.Amount
from dbo.CustomerOrders as O
inner join dbo.Products as P
	on O.ProductID = P.ProductID
order by O.OrderID;

-- 5. Correct ProductID values based on product names
-- Laptop = 1, Keyboard = 2, Mouse = 3, Monitor = 4
update dbo.CustomerOrders
set ProductID = case ProductName
    when 'Laptop' then 1
    when 'Keyboard' then 2
    when 'Mouse' then 3
    when 'Monitor' then 4
end;

-- 6. Verify that product IDs now match the Products table
select
    O.OrderID,
    O.ProductName as OrderProduct,
    O.ProductID as OrderProductID,
    P.ProductName as ProductTableName,
    P.ProductID as ProductTableID,
    O.Amount
from dbo.CustomerOrders as O
INNER JOIN dbo.Products as P
    on O.ProductID = P.ProductID
order by O.OrderID;

-- 7. Calculate revenue and order-row counts by product
-- Identify the products generating the most recorded revenue
select
    P.ProductName,
    P.Category,
    COUNT(O.OrderID) as OrderRows,
    SUM(O.Amount) as TotalRevenue
from dbo.Products as P
INNER JOIN dbo.CustomerOrders as O
    on P.ProductID = O.ProductID
group by P.ProductName, P.Category
order by TotalRevenue desc;
