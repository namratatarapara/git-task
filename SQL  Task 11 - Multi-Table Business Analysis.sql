USE DataAnalystpractice;
GO

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME IN ('Orders', 'OrderItems');

CREATE TABLE dbo.Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE,
    FOREIGN KEY (CustomerID)
        REFERENCES dbo.Customers(CustomerID)
);

CREATE TABLE dbo.OrderItems (
    OrderItemID INT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID)
        REFERENCES dbo.Orders(OrderID),
    FOREIGN KEY (ProductID)
        REFERENCES dbo.Products(ProductID)
);

INSERT INTO dbo.Orders
    (OrderID, CustomerID, OrderDate)
VALUES
    (101, 101, '2026-10-01'),
    (102, 102, '2026-10-02'),
    (103, 101, '2026-10-03'),
    (104, 103, '2026-10-04');

INSERT INTO dbo.OrderItems
    (OrderItemID, OrderID, ProductID, Quantity, UnitPrice)
VALUES
    (1, 101, 1, 1, 50000),
    (2, 101, 3, 2, 500),
    (3, 102, 2, 1, 1200),
    (4, 103, 4, 1, 25000),
    (5, 104, 3, 1, 500);

SELECT
    C.CustomerName,
    O.OrderID,
    O.OrderDate,
    P.ProductName,
    P.Category,
    I.Quantity,
    I.UnitPrice,
    I.Quantity * I.UnitPrice AS ItemRevenue
FROM dbo.Customers AS C
INNER JOIN dbo.Orders AS O
    ON C.CustomerID = O.CustomerID
INNER JOIN dbo.OrderItems AS I
    ON O.OrderID = I.OrderID
INNER JOIN dbo.Products AS P
    ON I.ProductID = P.ProductID
ORDER BY O.OrderID, I.OrderItemID;

SELECT
    P.ProductName,
    P.Category,
    SUM(I.Quantity) AS UnitsSold,
    SUM(I.Quantity * I.UnitPrice) AS TotalRevenue
FROM dbo.OrderItems AS I
INNER JOIN dbo.Products AS P
    ON I.ProductID = P.ProductID
GROUP BY
    P.ProductName,
    P.Category
ORDER BY TotalRevenue DESC;