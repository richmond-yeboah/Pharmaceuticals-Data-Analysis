-- First get rid of the 0 values in the table under the quantity column

DELETE FROM pharma
WHERE quantity = 0;

-- Note: Under the quantity and sales columns, there are negatives values in there showing that the purchase did not happen in the end

-- Retreive all columns for all records in the dataset

SELECT * FROM pharma;


-- Find the total quantity sold for the ' Antibiotics' product class.

SELECT SUM(Quantity) AS Total_Quantity_Antibiotics
FROM Pharma 
WHERE ProductClass = 'Antibiotics' and Quantity > 0;

-- Calculate the total sales for each year.

SELECT Year,
       (SELECT FORMAT(SUM(Sales), 2)) as Yearly_Sales
FROM pharma
Where Sales > 0
GROUP BY Year
ORDER BY Year ASC;

-- Find the customer with the highest total sales value.

SELECT CustomerName,
       (SELECT FORMAT(SUM(Sales), 2)) as Total_Sales
FROM pharma
WHERE Sales > 0
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- Get the names of all Sales Reps who are managed by 'James Goodwill'.

SELECT DISTINCT(SalesRep) AS Reps,
       Manager
FROM pharma
WHERE Manager = 'James Goodwill';

-- Retrieve the top 5 cities with the highest sales.

SELECT City,
       Country,
       (SELECT FORMAT(SUM(Sales), 2)) as Top_Cities_Sales
FROM pharma
WHERE Sales > 0
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 5;

-- Calculate the average price of products sold to each sub-channel(Sector)

SELECT SubChannel,
       avg(Price) as average_price
FROM pharma
WHERE Sales > 0
GROUP BY SubChannel
ORDER BY average_price DESC;

-- Calculate the total sales made by sales rep

SELECT SalesRep,
       (SELECT FORMAT(SUM(Sales), 2)) as Total_sales_by_rep
FROM pharma
WHERE Sales > 0
GROUP BY 1
ORDER BY 2 DESC;

-- Retrieve all sales made by Sales representatives to Barton Ltd Pharm in the year 2018.

SELECT SalesRep,
       CustomerName,
       Sales,
       Year
FROM pharma
WHERE CustomerName = 'Barton Ltd Pharm' and Year = 2018 and Sales > 0;

-- Summary of the total sales for each product class in 2020

SELECT ProductClass,
       Sum(Sales) as Yearly_sales,
       Year
FROM pharma
WHERE Year = 2020 and Sales > 0
GROUP BY 1,3
ORDER BY 2 DESC;


-- Find the top 3 sales reps with the highest total sales in 2019.

SELECT SalesRep,
       Sum(Sales) as Sales_made_by_rep,
       Year
FROM pharma
WHERE Year = 2019 and Sales > 0
GROUP BY 1,3
ORDER BY 2 DESC
LIMIT 3;

-- Create a summary report that includes the total sales, average price, and total quantity sold for each product class.

SELECT ProductClass,
       SUM(Sales) AS Total_Sales, 
       AVG(Price) AS Average_Price,
       SUM(Quantity) AS Total_Quantity
FROM pharma
WHERE Sales > 0 and Quantity > 0
GROUP BY 1;

-- What is the total sales each manager made for the pharmaceutical company, in descending order

SELECT Manager,
       SUM(Sales) as Total_sales
FROM pharma
WHERE Sales>0
GROUP BY Manager
ORDER BY Total_sales DESC;


-- How many sales representatives work under each manager

SELECT Manager,
       COUNT(DISTINCT SalesRep) as Number_of_reps
FROM pharma
GROUP BY Manager;

-- Rank the Sales Teams based on their percentage contrbution to total sales

With PercentageCTE AS (SELECT SalesTeam,
                       SUM(Sales) as Total_Sales
      FROM pharma
      WHERE Sales>0
	  GROUP BY SalesTeam
      ORDER BY Total_Sales DESC)
      
SELECT SalesTeam,
       Round((Total_Sales / (SELECT SUM(Total_Sales) FROM PercentageCTE)), 2) * 100 AS Percentage_Sales
FROM PercentageCTE
GROUP BY 1
ORDER BY 2 DESC;

-- 18. Compare the total sales made by Distributors to the average sales for all Distributors, indicate if they are above average or below average

with DistCTE AS (SELECT Distributor,
	   SUM(Sales) as Total_Sales FROM pharma
WHERE Sales > 0
GROUP BY Distributor
ORDER BY Total_Sales)

SELECT Distributor,
       Total_Sales,
       (SELECT AVG(Total_Sales) FROM DistCTE),
       CASE 
          WHEN Total_Sales > (SELECT AVG(Total_Sales) FROM DistCTE) THEN 'Above Average'
          WHEN Total_Sales < (SELECT AVG(Total_Sales) FROM DistCTE) THEN 'Below Average'
	   END AS Sales_Status	
FROM DistCTE
GROUP BY Distributor;

-- Which Distributor supplied highest total quantity

SELECT Distributor,
       SUM(Quantity) as Total_Quantity_Supplied
FROM pharma
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- What are the Top 5 most sold products and what class are each from

SELECT ProductName,
       ProductClass,
       SUM(Quantity) as Quantities_Sold
FROM pharma
WHERE Quantity > 0
GROUP BY ProductName, ProductClass
ORDER BY Quantities_Sold DESC
LIMIT 5;

-- What is the total quantity of products that were returned and how much did the company lose to that

SELECT (SELECT FORMAT(SUM(Quantity), 2)) as quantity_returned,
       (SELECT FORMAT(SUM(Sales), 2)) as loss_in_sales
FROM pharma
WHERE Quantity < 0 and Sales < 0;



       




-- 


       



