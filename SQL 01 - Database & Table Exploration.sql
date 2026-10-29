-- SQL TASK 01: DATABASE & TABLE EXPLORATION
-- Create a new database for SQL practice
create database DataAnalystpractice;
go

-- Select the database for further operations
use DataAnalystpractice;
go

-- Display the name of the current database
select DB_NAME() As CurrentDatabase;

-- Create the Sales table with appropriate data types
create table Sales(
	OrderID int primary key,
	ProductName varchar(50),
	Category varchar(30),
	Quantity int,
	price decimal(10,2),
	Region varchar(30)
);
go

-- Display all records from the Sales table
select * from Sales;

-- Insert sample sales records into the Sales table
insert into Sales(OrderID, ProductName, Category, Quantity,price,Region)
Values
(1,'Laptop','Electronics',2,50000,'West'),
(2,'Mouse','Accessories',3,1500,'South'),
(3,'Monitor', 'Electronics',5,30000,'East'),
(4,'Keyboard','Accessories',3,1200,'West'),
(5, 'Laptop', 'Electronics', 1, 50000, 'North');
GO

-- Display all inserted sales records
select * from Sales;

-- Calculate total revenue for each product
-- Revenue = Quantity * Price
Select 
	ProductName,
	SUM(Quantity * price) As TotalRevenue
	from Sales
	Group by ProductName
	Order by TotalRevenue desc;

select * from Sales;

-- Calculate total revenue for each region
select
    Region,
    SUM(Quantity * Price) as TotalRevenue
from Sales
group by Region
order by TotalRevenue desc;

-- Calculate total revenue for each category
Select
	Category,
	Sum(Quantity * price) As TotalRevenue
from Sales
Group by Category
Order by TotalRevenue desc;