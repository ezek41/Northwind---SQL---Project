SELECT 
    'Incoherent Dates' AS ErrorType,
    COUNT(*) AS RecordCount
FROM Orders
WHERE ShippedDate < OrderDate -- Shipping date cannot precede the purchase date

UNION ALL

SELECT 
    'Orders Missing Shipping Date (NULL)' AS ErrorType,
    COUNT(*) AS RecordCount
FROM Orders
WHERE ShippedDate IS NULL;