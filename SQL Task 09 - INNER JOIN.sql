-- SQL 09 - INNER JOIN
-- Combine related customer, order and product data. Explain the join keys used.
use DataAnalystpractice;
go

-- Explore the tables available in the database
select TABLE_SCHEMA, TABLE_NAME
from INFORMATION_SCHEMA.TABLES
where TABLE_TYPE = 'BASE TABLE';

use DataAnalystpractice;
go
 
-- Create the Customers table 
create table dbo.Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    City VARCHAR(50)
);

-- Insert the first three customer records
insert into dbo.Customers
    (CustomerID, CustomerName, City)
values
    (101, 'Asha', 'Rajkot'),
    (102, 'Riya', 'Ahmedabad'),
    (103, 'Neha', 'Surat');

-- Insert two additional customer records
insert into dbo.Customers
    (CustomerID, CustomerName, City)
VALUES
    (104, 'Jay', 'Rajkot'),
    (105, 'Ramesh', 'Ahmedabad');

 -- Display all customer records
select * from dbo.Customers;

-- Create the CustomerOrders table
create table dbo.CustomerOrders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    ProductName VARCHAR(50),
    Amount DECIMAL(10,2)
);

-- Insert the first four order records
insert into dbo.CustomerOrders
    (OrderID, CustomerID, ProductName, Amount)
VALUES
    (1, 101, 'Laptop', 50000),
    (2, 102, 'Mouse', 1500),
    (3, 101, 'Keyboard', 1200),
    (4, 105, 'Monitor', 25000);

-- Insert an additional order for customer 104
insert into dbo.CustomerOrders
    (OrderID, CustomerID, ProductName, Amount)
VALUES
    (5, 104, 'Laptop', 50000);

-- Display all customer order records
select * from dbo.CustomerOrders;

-- Display order details with customer names and cities
-- INNER JOIN returns only matching customer and order records
select 
    O.OrderID,
    C.CustomerName,
    C.City,
    O.ProductName,
    O.Amount
from dbo.CustomerOrders as O
inner join dbo.Customers as C
    on O.CustomerID = C.CustomerID;
 
 -- Find customers who have placed more than one order
select 
    C.CustomerID,
    C.CustomerName,
    COUNT(O.OrderID) as TotalOrders
from dbo.Customers as C
inner join dbo.CustomerOrders as O
    on C.CustomerID = O.CustomerID
group by 
    C.CustomerID,
    C.CustomerName
having COUNT(O.OrderID) > 1;

-- Create the Products table 
create table Products(
    ProductID int primary key,
    ProductName varchar(50),
    Category varchar(50)
);

-- Insert product names and their categories
insert into dbo.Products
    (ProductID,ProductName,Category)
values
    (1,'Laptop','Electronics'),
    (2,'Keyboard','Accessories'),
    (3,'Mouse','Accessories'),
    (4,'Monitor','Electronics');

-- Verify that the Products table exists
select TABLE_NAME
from INFORMATION_SCHEMA.TABLES
where TABLE_NAME = 'Products';

USE DataAnalystpractice;
GO

-- Display the structure of the CustomerOrders table
EXEC sp_help 'dbo.CustomerOrders';

alter table dbo.CustomerOrders
add ProductID int;

-- Assign ProductID values based on product names
update dbo.CustomerOrders
set ProductID = case ProductName
    when 'Laptop' then 1
    when 'Keyboard' then 2
    when 'Monitor' then 3
    when 'Mouse' then 4
end;

-- Display updated order records with ProductID
Select * from dbo.CustomerOrders;

-- Combine customer, order and product details
-- Join using CustomerID and ProductID
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

-- Display order IDs, customer IDs, products, product IDs and amounts
select OrderID,CustomerID,ProductName,ProductID,Amount
from dbo.CustomerOrders;

-- Display detailed customer and product information
-- Sort the output by OrderID
select
    C.CustomerID,
    C.CustomerName,
    O.OrderID,
    P.ProductName,
    P.ProductID,
    P.Category,
    O.Amount
from Customers as C
inner join dbo.CustomerOrders as O
    on C.CustomerID = O.CustomerID
inner join dbo.Products as P
    on O.ProductID = P.ProductID
order by OrderID;

-- Calculate total orders and revenue for each customer
-- Display customers with the highest revenue first
select 
    C.CustomerID,
    C.CustomerName,
    COUNT(O.OrderID) as TotalOrders,
    SUM(O.Amount) as TotalRevenue
from dbo.Customers as C
inner join dbo.CustomerOrders as O
    on C.CustomerID = O.CustomerID
group by 
    C.CustomerID,
    C.CustomerName
order by TotalRevenue desc;
 
