SELECT TOP 15
    c.Country,
    c.CompanyName,
    COUNT(o.OrderID) AS TotalShippedOrders,
    -- Processing time (order date vs. shipping date)
    AVG(DATEDIFF(DAY, o.OrderDate, o.ShippedDate)) AS AvgProcessingDays,
    -- Worst-case scenarios
    MAX(DATEDIFF(DAY, o.OrderDate, o.ShippedDate)) AS MaxProcessingDays,
    -- Total billing for this ranking
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS TotalSales
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE o.ShippedDate IS NOT NULL -- Only orders with a shipping date
  AND o.ShippedDate >= o.OrderDate -- Filter out incoherent dates
GROUP BY c.Country, c.CompanyName
ORDER BY TotalSales DESC; -- Ranked by total purchase amount