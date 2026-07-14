WITH OrderTotals AS (
    SELECT 
        o.CustomerID,
        o.OrderID,
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS OrderAmount
    FROM Orders o
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY o.CustomerID, o.OrderID
)
SELECT TOP 10
    c.CustomerID,
    c.CompanyName,
    COUNT(ot.OrderID) AS TotalOrders,
    SUM(ot.OrderAmount) AS TotalSalesAmount,
    AVG(ot.OrderAmount) AS AverageOrderValue
FROM Customers c
JOIN OrderTotals ot ON c.CustomerID = ot.CustomerID
GROUP BY c.CustomerID, c.CompanyName
ORDER BY TotalSalesAmount DESC;