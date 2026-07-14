SELECT 
    COUNT(DISTINCT o.CustomerID) AS TotalCustomers,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    -- Financial
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS NetSales,
    ROUND(SUM(od.UnitPrice * od.Quantity * od.Discount), 2) AS TotalDiscountInUSD,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) / COUNT(DISTINCT o.OrderID), 2) AS AverageTicketValue,
    -- Logistics
    COUNT(DISTINCT o.ShipCountry) AS CountriesReached,
    AVG(CAST(od.Quantity AS FLOAT)) AS AverageUnitsPerOrder,
    COUNT(DISTINCT od.ProductID) AS SKUsSold
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID;