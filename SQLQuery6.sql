SELECT 
    OrderID,
    CustomerID,
    OrderDate,
    ShippedDate,
    DATEDIFF(DAY, OrderDate, ShippedDate) AS ProcessingDays
FROM Orders
-- Cleaning filter:
WHERE ShippedDate IS NOT NULL 
  AND ShippedDate >= OrderDate;