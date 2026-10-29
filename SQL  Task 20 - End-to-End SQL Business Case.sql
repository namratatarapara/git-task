
-- SQL 20 - End-to-End SQL Business Case
-- SQL 20: step-1

create database SQL20_BusinessCase;
go

use SQL20_BusinessCase;
go

-- step-2 Create tables
-- 1. Customers table
Create table CustomersDetails (
    CustomerID int primary key,
    CustomerName varchar(100),
    City varchar(50),
    SignupDate date
);
go

-- 2. Products table
create table ProductsDetails (
    ProductID int primary key,
    ProductName varchar(100),
    Category varchar(50),
    UnitCost decimal(10,2)
);
go

-- 3. Orders table: one row per product line
create table OrdersDetail (
    OrderLineID int primary key,
    OrderID int,
    CustomerID int,
    ProductID int,
    OrderDate date,
    Quantity int,
    UnitPrice decimal(10,2),
    Discount decimal(5,2),
    foreign key (CustomerID)
        references CustomersDetails(CustomerID),
    foreign key (ProductID)
        references ProductsDetails(ProductID)
);
go

-- 4. Returns table
create table ReturnsDetail (
    ReturnID int primary key,
    OrderLineID int,
    ReturnDate date,
    ReturnQuantity int,
    foreign key (OrderLineID)
        references OrdersDetail(OrderLineID)
);
go

select TABLE_NAME
from INFORMATION_SCHEMA.TABLES
where TABLE_TYPE = 'BASE TABLE'
order by TABLE_NAME;


-- Step 3: Insert 15 customers
insert into CustomersDetails
    (CustomerID, CustomerName, City, SignupDate)
    values
        (1,'Aarav Patel','Rajkot','2025-01-10'),
        (2,'Diya Shah','Ahmedabad','2025-02-15'),
        (3,'Riya Mehta','Surat','2025-03-20'),
        (4,'Krish Joshi','Rajkot','2025-04-05'),
        (5,'Anaya Desai','Ahmedabad','2025-05-12'),
        (6,'Vivaan Trivedi','Ahmedabad','2025-06-18'),
        (7,'Mira Patel','Surat','2025-07-22'),
        (8,'Arjun Shah','Rajkot','2025-08-14'),
        (9,'Kavya Mehta','Gandhinagar','2025-09-03'),
        (10,'Ishaan Dave','Bhavnagar','2025-09-17'),
        (11,'Sara Modi','Jamnagar','2025-10-01'),
        (12,'Reyansh Parmar','Morbi','2025-10-12'),
        (13,'Myra Thakkar','Anand','2025-11-08'),
        (14,'Dev Patel','Junagadh','2025-12-02'),
        (15,'Kiara Shah','Rajkot','2025-12-20');

-- Step 3: Insert 8 products
insert into ProductsDetails
    (ProductID, ProductName, Category, UnitCost)
    values
        (101,'Laptop','Electronics',35000),
        (102,'Smartphone','Electronics',15000),
        (103,'Headphones','Accessories',800),
        (104,'Office Chair','Furniture',3000),
        (105,'Study Table','',4500),
        (106,'Keyboard','Accessories',500),
        (107,'Monitor','Electronics',7000),
        (108,'Mouse','Accessories',250);

-- Step 4: Insert 50 order-line records
insert into OrdersDetail
    (OrderLineID, OrderID, CustomerID, ProductID,
         OrderDate, Quantity, UnitPrice, Discount)
    values
        (1,1001,1,101,'2026-01-05',1,42000,0.05),
        (2,1001,1,103,'2026-01-05',null,1200,0.00),
        (3,1002,2,102,'2026-01-10',2,20000,0.10),
        (4,1003,null,104,'2026-01-15',1,4500,0.00),
        (5,1004,4,107,'2026-02-02',2,9500,0.05),
        (6,1005,5,105,'2026-02-08',1,6500,0.10),
        (7,1006,6,106,'2026-02-14',3,900,0.00),
        (8,1007,7,101,'2026-03-01',-1,42000,0.15),
        (9,1008,8,108,'2026-03-05',-4,450,0.00),
        (10,1009,2,103,'2026-03-12',3,1200,0.05),
        (11,1010,3,102,'2026-03-20',-1,20000,0.00),
        (12,1011,1,104,'2026-04-02',2,4500,0.10),
        (13,1012,4,105,'2026-04-10',2,6500,0.05),
        (14,1013,5,107,'2026-04-18',1,9500,0.00),
        (15,1014,6,102,'2026-05-03',2,20000,0.05),
        (16,1015,7,106,'2026-05-11',5,900,0.10),
        (17,1016,8,101,'2026-05-20',1,42000,0.00),
        (18,1017,2,104,'2026-06-01',1,4500,0.00),
        (19,1018,3,107,'2026-06-12',2,9500,0.10),
        (20,1019,5,103,'2026-06-20',4,1200,0.00),
        (21,1020,1,102,'2026-07-02',1,20000,0.05),
        (22,1021,2,108,'2026-07-05',3,450,0.00),
        (23,1022,3,101,'2026-07-08',1,42000,0.10),
        (24,1023,4,103,'2026-07-12',2,1200,0.05),
        (25,1024,5,107,'2026-07-16',1,9500,0.00),
        (26,1025,6,104,'2026-07-20',2,4500,0.10),
        (27,1026,7,105,'2026-07-23',1,6500,0.05),
        (28,1027,8,106,'2026-07-27',4,900,0.00),
        (29,1028,9,108,'2026-08-01',5,450,0.00),
        (30,1029,10,101,'2026-08-04',1,42000,0.15),
        (31,1030,11,104,'2026-08-07',1,4500,0.00),
        (32,1031,12,102,'2026-08-10',2,20000,0.05),
        (33,1032,13,103,'2026-08-13',3,1200,0.10),
        (34,1033,14,107,'2026-08-16',2,9500,0.00),
        (35,1034,15,106,'2026-08-19',6,900,0.05),
        (36,1035,9,105,'2026-08-22',1,6500,0.00),
        (37,1036,10,101,'2026-09-01',1,42000,0.05),
        (38,1037,11,104,'2026-09-04',2,4500,0.00),
        (39,1038,12,108,'2026-09-07',4,450,0.00),
        (40,1039,13,107,'2026-09-10',1,9500,0.10),
        (41,1040,14,102,'2026-09-13',1,20000,0.00),
        (42,1041,15,103,'2026-09-16',2,1200,0.05),
        (43,1042,9,104,'2026-09-19',1,4500,0.00),
        (44,1043,10,101,'2026-09-22',1,42000,0.10),
        (45,1044,11,105,'2026-10-01',2,6500,0.05),
        (46,1045,12,106,'2026-10-05',3,900,0.00),
        (47,1046,13,102,'2026-10-09',2,20000,0.10),
        (48,1047,14,108,'2026-10-13',5,450,0.00),
        (49,1048,15,101,'2026-10-18',1,42000,0.05),
        (50,1049,6,107,'2026-10-22',2,9500,0.00);

-- Step 5: Insert 6 return records
insert into ReturnsDetail
    (ReturnID, OrderLineID, ReturnDate, ReturnQuantity)
    values
        (1,3,'2026-01-18',1),
        (2,5,'2026-02-10',1),
        (3,9,'2026-03-12',2),
        (4,14,'2026-04-25',1),
        (5,23,'2026-07-15',1),
        (6,32,'2026-08-20',1);


-- Step 4: Data Quality Validation
-- Verify row counts
select 'CustomersDetails' as TableName, COUNT(*) as TotalRows
from CustomersDetails
union all
select 'ProductsDetails', COUNT(*) from ProductsDetails
union all
select 'OrdersDetail', COUNT(*) from OrdersDetail
union all
select 'ReturnsDetail', COUNT(*) from ReturnsDetail;

--Find missing and invalid values
select *
from CustomersDetails
where CustomerName is null
   OR City is null
   OR SignupDate is null;

select *
from ProductsDetails
where ProductName is null
   OR Category is null
   OR UnitCost is null
   OR UnitCost < 0;

select *
from OrdersDetail
where CustomerID is null
   OR ProductID is null
   OR OrderDate is null
   OR Quantity is null
   OR Quantity <= 0
   OR UnitPrice is null
   OR UnitPrice < 0
   OR Discount is null
   OR Discount < 0
   OR Discount > 1;

select *
from ReturnsDetail
where ReturnDate is null
   OR ReturnQuantity is null
   OR ReturnQuantity <= 0;

-- Check repeated order-line IDs
select OrderLineID, COUNT(*) as DuplicateCount
from OrdersDetail
group by OrderLineID
having COUNT(*) > 1;

-- Check repeated return IDs
select ReturnID, COUNT(*) as DuplicateCount
from ReturnsDetail
group by ReturnID
having COUNT(*) > 1;

-- Validate returns against order quantities

select
    o.OrderLineID,
    o.Quantity as PurchasedQuantity,
    SUM(r.ReturnQuantity) as TotalReturned
from OrdersDetail as o
join ReturnsDetail as r
    on o.OrderLineID = r.OrderLineID
group by o.OrderLineID, o.Quantity
having SUM(r.ReturnQuantity) > o.Quantity;

select *
from OrdersDetail;

-- Find missing and invalid orders
select
    OrderLineID,
    OrderID,
    CustomerID,
    ProductID,
    Quantity,
    UnitPrice,
    case
        when CustomerID is null
            then 'Missing Customer ID'
        when Quantity is null
            then 'Missing Quantity'
        when Quantity <= 0
            then 'Invalid Quantity'
        when UnitPrice is null
            then 'Missing Unit Price'
        when UnitPrice < 0
            then 'Invalid Unit Price'
        else 'Check Other Fields'
    end as DataQualityIssue
from OrdersDetail
where CustomerID is null
   OR Quantity is null
   OR Quantity <= 0
   OR UnitPrice is null
   OR UnitPrice < 0;

-- prctice cleaning data
SELECT *
INTO OrdersDetail_Backup
FROM OrdersDetail;

-- Example only: replace NULL with 2
-- ONLY if source records confirm quantity = 2.
-- -- Clean missing quantity
select *
from OrdersDetail_Backup
where Quantity is null;

update OrdersDetail_Backup
set Quantity = 2
where OrderID = 1001
  AND Quantity is null;

select *
from OrdersDetail_Backup;

-- Clean missing customer ID
select *
from OrdersDetail_Backup
where CustomerID IS NULL;

-- Handle negative quantities
select *
from OrdersDetail_Backup
where Quantity < 0;

-- Verify your cleaned backup
select *
from OrdersDetail_Backup
order by OrderLineID;

-- Find negative quantities
select *
from dbo.OrdersDetail_Backup
where CustomerID IS NULL;

-- List available customers
select *
from CustomersDetails
order by CustomerID;

select *
from dbo.OrdersDetail_Backup
where Quantity IS NULL
   OR Quantity <= 0
   OR CustomerID IS NULL
   OR UnitPrice IS NULL
   OR UnitPrice < 0;

-- Add a status in the query only
select
    OrderLineID,
    OrderID,
    Quantity,
    case
        when Quantity < 0 then 'Invalid Quantity'
        else 'Valid'
    end as DataQualityStatus
from dbo.OrdersDetail_Backup;

--step-5 Business KPI Analysis
-- Overall business performance
select
    COUNT(distinct OrderID) as TotalOrders,
    COUNT(*) as TotalOrderLines,
    SUM(Quantity) as TotalUnitsSold,
    SUM(Quantity * UnitPrice) as GrossRevenue,
    SUM(Quantity * UnitPrice * Discount)
        as TotalDiscount,
    SUM(Quantity * UnitPrice * (1 - Discount))
        as NetRevenue
from dbo.OrdersDetail;

-- Calculate estimated profit
select
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
    on o.ProductID = p.ProductID;

-- Find top-performing products
select
    p.ProductName,
    SUM(
        o.Quantity * o.UnitPrice * (1 - o.Discount)
    ) as NetRevenue,
    SUM(o.Quantity * p.UnitCost) as TotalCost,
    SUM(
        o.Quantity * o.UnitPrice * (1 - o.Discount)
        - o.Quantity * p.UnitCost
    ) as EstimatedProfit
from dbo.OrdersDetail as o
join dbo.ProductsDetails as p
    on o.ProductID = p.ProductID
group by p.ProductName
order by EstimatedProfit desc;

-- Revenue by category
select
    p.Category,
    SUM(
        o.Quantity * o.UnitPrice * (1 - o.Discount)
    ) as NetRevenue

from dbo.OrdersDetail as o
join dbo.ProductsDetails as p
    on o.ProductID = p.ProductID
group by p.Category
order by NetRevenue desc;


