SELECT TOP 10
    c.Country,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    AVG(DATEDIFF(DAY, o.OrderDate, o.ShippedDate)) AS AvgProcessingDays,
    MIN(DATEDIFF(DAY, o.OrderDate, o.ShippedDate)) AS MinDays,
    MAX(DATEDIFF(DAY, o.OrderDate, o.ShippedDate)) AS MaxDays,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS TotalSales
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE o.ShippedDate IS NOT NULL 
  AND o.ShippedDate >= o.OrderDate
GROUP BY c.Country
ORDER BY TotalSales DESC;