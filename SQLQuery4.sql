WITH RFMModel AS (
    SELECT 
        o.CustomerID,
        DATEDIFF(day, MAX(o.OrderDate), (SELECT MAX(OrderDate) FROM Orders)) AS Recency,
        COUNT(DISTINCT o.OrderID) AS Frequency, 
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS Monetary
    FROM Orders o
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY o.CustomerID
),
GlobalSalesTotal AS (
    -- Calculate total sales once globally
    SELECT SUM(Monetary) AS GrandTotal FROM RFMModel
),
MonetaryRanking AS (
    SELECT 
        b.*,
        PERCENT_RANK() OVER (ORDER BY b.Monetary) AS CalcPercentile,
        (b.Monetary / (SELECT GrandTotal FROM GlobalSalesTotal)) * 100 AS SalesPercentage
    FROM RFMModel b
),
AuxiliaryCalc AS (
    SELECT 
        AVG(CAST(Frequency AS FLOAT)) AS AvgFreq,
        AVG(CAST(Recency AS FLOAT)) AS AvgRec
    FROM MonetaryRanking
    WHERE CalcPercentile >= 0.8
)
SELECT 
    b.CustomerID,
    b.Recency,
    b.Frequency,
    b.Monetary,
    CAST(b.SalesPercentage AS DECIMAL(10,2)) AS [Sales_Share_Pct],
    CASE 
        WHEN b.Recency > (SELECT AvgRec FROM AuxiliaryCalc) AND b.Frequency > (SELECT AvgFreq FROM AuxiliaryCalc) 
            THEN 'Potential Churn'
        WHEN b.Recency > (SELECT AvgRec * 1.5 FROM AuxiliaryCalc) 
            THEN 'Lost'
        ELSE 'Active'
    END AS Churn_Status
FROM MonetaryRanking b
WHERE b.CalcPercentile >= 0.8 -- Filtering the top 20%
ORDER BY b.Monetary DESC;