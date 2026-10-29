 -- SQL TASK 10: LEFT JOIN & MISSING RELATIONSHIPS
 -- Identify customers with no orders and products with no sales; explain unmatched records.
 use DataAnalystpractice
 go

-- 1. Display all customers and their matching orders
-- LEFT JOIN keeps customers even if they have no orders
 select 
    C.CustomerName,
    O.OrderID
from dbo.Customers as C
left join dbo.CustomerOrders as O
    on C.CustomerID = O.CustomerID;

-- 2. Find customers who have not placed any orders
-- NULL OrderID means no matching order was found
select 
    C.CustomerName,
    C.CustomerID,
    C.City
from dbo.Customers as C
left join dbo.CustomerOrders as O
    on C.CustomerID = O.CustomerID
where OrderID is null;

-- 3. Find products that have never been ordered
-- Products without a matching order have NULL OrderID
select 
    P.ProductID,
    P.ProductName,
    P.Category
from dbo.Products as P
left join dbo.CustomerOrders as O
    on P.ProductID = O.ProductID
where OrderID is null;

-- 4. Display all records from the CustomerOrders table
select * from CustomerOrders;

-- 5. Count orders for every customer, including customers with zero orders
-- COUNT(O.OrderID) ignores NULL values from unmatched rows
-- Sort customers from the fewest orders to the most
select 
    C.CustomerID,
    C.CustomerName,
    COUNT(O.OrderID) as TotalOrders
from dbo.Customers as C
left join dbo.CustomerOrders as O
    on  C.CustomerID = O.CustomerID
group by 
    C.CustomerID,
    C.CustomerName
order by TotalOrders asc;