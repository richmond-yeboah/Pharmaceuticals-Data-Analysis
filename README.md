# Pharmaceuticals-Data-Analysis

## Project Overview

In this project, I dive into the data of a big pharma company to reveal insights, trends and patterns hidden inside the data. The data contains information about distributors, products, customers, managers, sales teams and a whole lot leading to this project having 5 dashboards at the end of the analysis and visualization.

## Dataset and Data Source

Foresight Pharmaceuticals is one of the leading Pharmaceutical manufacturing companies with a global presence. Their markets are divided into different regions across the world. One of those regions manages the German and Polish markets. But the company does not sell directly to customers. Instead, they work with a couple of distributors in all their regions. They have an agreement with each of the distributors to share their sales data with them. This enables them to gain insights up to the retail level.

The dataset is sourced from each distributor. It contains Pharmaceutical Manufacturing Company’s, Wholesale-Retail Data. The field description of the raw data is given below. The raw dataset pharma_data.csv can be downloaded from [here](https://foresightbi.com.ng/practice-data/3-datasets-for-your-portfolio/).


|Field	               |Description                                       | 
|----------------------|--------------------------------------------------|
|Distributor	         |Name of Wholesaler                                |
|                      |                                                  |
|Customer Name	       |Name of customer                                  |
|                      |                                                  |
|City	                 |Customer's city                                   |
|                      |                                                  |
|Country	             |Customer's country                                |
|                      |                                                  |
|Latitude	             |Customer's Geo Latitude                           |
|                      |                                                  |
|Longitude	           |Customer's Geo Longitude                          |
|                      |                                                  |
|Channel	             |Class of buyer (Hospital, Pharmacy)               |
|                      |                                                  |
|Sub-channel	         |Sector of the buyer (Government, Private, etc.)   |
|                      |                                                  |
|Product Name	         |Name of Drug                                      |
|                      |                                                  |
|Product Class	       |Class of Drug (Antibiotics, etc.)                 |
|                      |                                                  |
|Quantity	             |Quantity purchased                                |
|                      |                                                  |
|Price	               |Price product was sold for                        |
|                      |                                                  |
|Sales	               |Amount made from sale                             |
|                      |                                                  |
|Month	               |Month sale was made                               |
|                      |                                                  |
|Year	                 |Year sale was made                                |
|                      |                                                  |
|Name of Sales Rep	   |Name of the Sales rep who facilitated the sale    |
|                      |                                                  |
|Manager	             |Sales rep's Manager Name                          |
|                      |                                                  |
|Sales Team	           |Sale rep's team                                   |
|                      |                                                  |

## Tools Used
- MySQL for Data Querying
- Power Query for Data Cleaning and Transformation
- Power BI for creating reports and Dashboards

## Data Cleaning and Preparation

After importing the csv file into Power Query, I formatted the columns appropriately changing the data types of some columns (Price, Sales). I then filtered out zeros under the quantity column and went ahead to click 'close and apply' to apply the changes. There wasn't much to clean as the data was quite tidy already.

## Exploratory Data Analysis

EDA involved exploring the data to answer key questions like;

- What is the sales trend over the years?
- What is the sales team perfomance?
- Which product class generated the highest revenue?

## Data Querying(sql), DAX and visualization(Power BI)

The data was analyzed in both sql and power bi. Some business questions were answered in power bi with the help of visualizations, while some were answered in sql by querying. Other questions were answered in both, showing the same results from both, which depicts an accurate and consistent analysis of the data.

some of the questions I answered in sql by data querying are as follows;

```sql
-- Calculate the total sales for each year.

SELECT Year,
       (SELECT FORMAT(SUM(Sales), 2)) as Yearly_Sales
FROM pharma
Where Sales > 0
GROUP BY Year
ORDER BY Year ASC;
```


I had to make use of subqueries and common table expressions during some of the queries


```sql
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
```


some of the business questions could only be answered making use of subqueries, common table and expressions and conditional logic


```sql
-- Compare the total sales made by Distributors to the average sales for all Distributors, indicate if they are above average or below average

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
```


Due to the huge nature of numbers in the dataset, I had to make use the format() method so separate thousands for some queries 


```sql
-- What is the total quantity of products that were returned and how much did the company lose to that

SELECT (SELECT FORMAT(SUM(Quantity), 2)) as quantity_returned,
       (SELECT FORMAT(SUM(Sales), 2)) as loss_in_sales
FROM pharma
WHERE Quantity < 0 and Sales < 0;
```


An sql file has been added to view the queries made to answer some business questions







