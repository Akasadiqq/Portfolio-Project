---##...Initial

SELECT *
FROM medical_customers mc 
INNER JOIN medical_transactions mt 


---##...Remove Duplicates:

DELETE FROM medical_transactions
WHERE TransactionID IN (
    SELECT TransactionID
    FROM (
        SELECT TransactionID, COUNT(*) as cnt
        FROM medical_transactions 
        GROUP BY TransactionID
        HAVING cnt > 1
    ) as duplicates
);

DELETE FROM medical_customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM (
        SELECT CustomerID, COUNT(*) as cnt
        FROM medical_customers
        GROUP BY CustomerID
        HAVING cnt > 1
    ) as duplicates
);



---##...Handle Missing Values:

UPDATE medical_transactions
SET Satisfaction_Score = COALESCE(Satisfaction_Score, 3); -- Assuming 3 as a neutral score

UPDATE medical_customers 
SET Age = COALESCE(Age, (SELECT AVG(Age) FROM medical_customers)); -- Fill missing age with average age



---##...Customer purchase frequency by insurance type:

SELECT Insurance_Type, COUNT(*) as purchase_count
FROM medical_customers mc 
JOIN medical_transactions mt ON mc.CustomerID = mt.CustomerID
GROUP BY Insurance_Type;



---##...High-value customer segments:

SELECT mc.Location,
AVG(mt.Amount) as avg_transaction
FROM medical_customers mc
JOIN medical_transactions mt ON mc.CustomerID = mt.CustomerID
GROUP BY mc.Location;



---##...Identify High-Value Segments:

SELECT Age, Insurance_Type, Location,
       AVG(Total_Spent) as Avg_Spent,
       AVG(Purchase_Frequency) as Avg_Frequency
FROM (
    SELECT mc.CustomerID, mc.Age, mc.Insurance_Type, mc.Location,
           SUM(mt.Amount) as Total_Spent,
           COUNT(mt.TransactionID) as Purchase_Frequency
    FROM medical_customers mc
    JOIN medical_transactions mt ON mc.CustomerID = mt.CustomerID
    GROUP BY mc.CustomerID, mc.Age, mc.Insurance_Type, mc.Location
) as customer_summary
GROUP BY Age, Insurance_Type, Location
ORDER BY Avg_Spent DESC, Avg_Frequency DESC;



---##Calculate Total Spending and Purchase Frequency:

SELECT mc.CustomerID, mc.Age, mc.Insurance_Type, mc.Location,
       SUM(mt.Amount) as Total_Spent,
       COUNT(mt.TransactionID) as Purchase_Frequency
FROM medical_customers mc
JOIN medical_transactions mt ON mc.CustomerID = mt.CustomerID
GROUP BY mc.CustomerID, mc.Age, mc.Insurance_Type, mc.Location;



---##...Key Findings:

SELECT 
mt.Product_category,
count(*) AS Total_Sales,
AVG (mt.Satisfaction_Score) AS Avg_satisfaction,
COUNT(*) Transaction_Count
FROM medical_customers mc
JOIN medical_transactions mt ON mc.CustomerID = mt.CustomerID
GROUP BY mt.Product_Category ;


---##...
