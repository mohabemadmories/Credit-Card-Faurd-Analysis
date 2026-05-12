SELECT
	Class,
	COUNT(*) AS Total_transactions,
	SUM (Amount) AS Total_Amount,
	AVG (Amount) AS Average_Amount
FROM dbo.creditcardTransactions
GROUP BY Class;

SELECT 
	CAST(Floor(TIME/3600) AS int) % 24 AS Hour_Of_Day,
	COUNT (*) AS Fraud_Count
FROM dbo.creditcardTransactions
WHERE class=1
GROUP BY CAST(Floor(TIME/3600) AS int) % 24
Order BY Fraud_Count DESC;


SELECT 
	CASE
		WHEN Amount <5 THEN 'Low (0-5)'
		WHEN Amount BETWEEN 5 AND 50 THEN 'Medium (5-50)'
		WHEN Amount BETWEEN 50 AND 500 THEN 'High (50-500)'
		ELSE 'Very High (500+)'
	END AS Transactions_Category,
	COUNT (*) AS Fraud_Count
FROM dbo.creditcardTransactions
WHERE Class = 1
Group BY 
	CASE 
			WHEN Amount <5 THEN 'Low (0-5)'
			WHEN Amount BETWEEN 5 AND 50 THEN 'Medium (5-50)'
			WHEN Amount BETWEEN 50 AND 500 THEN 'High (50-500)'
			ELSE 'Very High (500+)'
	END
ORDER BY Fraud_Count DESC;

SELECT 
    Time, Amount, Class, COUNT(*) AS Duplicate_Count
FROM dbo.creditcardTransactions
GROUP BY Time, Amount, Class
HAVING COUNT(*) > 1
ORDER BY Duplicate_Count DESC;


WITH CTE AS(
	SELECT*,
	ROW_NUMBER() OVER(PARTITION BY Time ,Amount,Class, V1,V2 
	Order by Time)	AS RowNum
	FROM dbo.creditcardTransactions
	)
	DELETE FROM CTE WHERE RowNum > 1;