# Pharmaceuticals-Data-Analysis

## Table of content
- [Project Overview](#project-overview)
- [Dataset and Data Source](#dataset-and-data-source)
- [Tools Used](#tools-used)
- [Data Cleaning and Preparation](#data-cleaning-and-preparation)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Data Querying(sql), DAX and visualization(Power BI)](#data-querying(sql),-dax-and-visualization(power-bi))
- [Insights and Recommendations](#insights-and-recommendations)


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


### NB: There are zero values in the quantity column which were deleted, and also negative values in both the quantity and sales column indicating losses which must be considered during the analysis.

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

### sql

```sql
-- Calculate the total sales for each year.

SELECT Year,
       (SELECT FORMAT(SUM(Sales), 2)) as Yearly_Sales
FROM pharma
Where Sales > 0
GROUP BY Year
ORDER BY Year ASC;
```
Output:

![yearly_sales](https://github.com/richmond-yeboah/Pharmaceuticals-Data-Analysis/assets/143017331/511fa900-0df7-4fec-b398-c0df7d0e79f2)


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
Output:

![perc_sales](https://github.com/richmond-yeboah/Pharmaceuticals-Data-Analysis/assets/143017331/5168497b-e281-444b-8ca5-517f054e1608)



some of the business questions could only be answered making use of subqueries, common table and expressions and conditional logic


```sql
-- Compare the total sales made by Distributors to the average sales for all Distributors,
-- indicate if they are above average or below average

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
Output:

![dist_ave](https://github.com/richmond-yeboah/Pharmaceuticals-Data-Analysis/assets/143017331/9eec4197-c2fd-4469-b85a-728bf6167168)



Due to the huge nature of numbers in the dataset, I had to make use the format() method so separate thousands for some queries 


```sql
-- What is the total quantity of products that were returned and how much did the company lose to that

SELECT (SELECT FORMAT(SUM(Quantity), 2)) as quantity_returned,
       (SELECT FORMAT(SUM(Sales), 2)) as loss_in_sales
FROM pharma
WHERE Quantity < 0 and Sales < 0;
```
Output:

![loss](https://github.com/richmond-yeboah/Pharmaceuticals-Data-Analysis/assets/143017331/2e188f6e-ceee-403f-9e2b-bbe5b283e320)




An sql file has been added so you can view the queries made to answer some business questions.

### power bi

Like I said before, during the visualizations in Power BI, I ended up with 5 dashboards namely;
- Sales Summary
- Products
- Distributors and Customers
- Sales Team
- Region

Every Key Performance Metric (KPI) and measures in the Power BI dashboards were calculated using Data Analysis Expressions(DAX).

#### creating DAX measures

Below are some of the DAX calculations.


`Total Sales = CALCULATE(SUM(pharm_data[Sales]), pharm_data[Sales]>0)`

`Total Quantities sold = CALCULATE(SUM(pharm_data[Quantity]), pharm_data[Quantity]>0)`

`Sales Per Product Class = [Total Sales] / DISTINCTCOUNT(pharm_data[Product Class])`

`Products returned = ABS(CALCULATE(SUM(pharm_data[Quantity]), pharm_data[Quantity]<0))`

`Number of Cities = DISTINCTCOUNT(pharm_data[City])`

`Loss in sales = ABS(CALCULATE(SUM(pharm_data[Sales]), pharm_data[Sales]<0))`

#### dashboards and visualizations

Below is an image of the Sales Summary Dashboard

![sales_dashb](https://github.com/richmond-yeboah/Pharmaceuticals-Data-Analysis/assets/143017331/459a67ae-1774-44bb-8ea0-63862b5e444e)


The Distributors and customers Dashboard follows

![dist_cust](https://github.com/richmond-yeboah/Pharmaceuticals-Data-Analysis/assets/143017331/8471a248-3ebc-4fd4-b841-4cfa1e8452da)



Then the Sales Team Dashboard

![sales_team](https://github.com/richmond-yeboah/Pharmaceuticals-Data-Analysis/assets/143017331/a5b86529-6a6a-4f7b-8c57-f95a255c1eb7)


## Insights and Recommendations

As seen in the Sales Summary Dashboard above, Total Revenue made from sales is 11.95bn Euros from selling 29M quantity of products, total loss of 146.48M Euros due to customers returning 357,440 quantity of products (reason wasn't stated). This is quite alarming, it is advisable that the company make it a priority to collect data on the reasons for customers returning products, and analyze to find the leading reasons for this.

Over the 4 years, sales peaked in 2018 with a total of 3.55bn Euros but after 2018, sales begun to decline as shown in the visualization. August comes in first as the month with the highest total sales with 1.21bn Euros while January comes last with 680M (0.68bn Euros). There are products that are purchased more in a certain season or month due to some specific diseases being known to increase in certain months. This can be looked at so that production can be focused on some products durings those seasons, so as to maximize sales.

Among the all the sub-channels(sectors), Retail is where the highest total sales has been generated from (3.38bn Euros) while Private sector has generated the least (2.55bn Euros). It is recommended that managers explore ways to boost sales in the Private sector. Consider targeted marketing campaigns, product diversification, or pricing adjustments. Also, managers should make it a point to reach out to business leaders in the private sector to get reasons for this and tailor solutions for them.

On the product dashboard, Analgesics is the leading product class, selling 5.6M quantity of products to amass a total sales of 2.4bn Euros, which is 20.12% of total sales across all product classes. Antipyretics comes in last with 4.1M quantity of products sold and a total sales of 1.9bn Euros.

Between the two channels (Hospital and Pharmacy), Pharmacies contributed to 52.7% of total sales while Hospitals contributed to 47.3%.

In these 2 countries (Germany and Poland), The company has 751 customers and 29 Distributors.

The top 5 Distributors by sales are Gerlach LLC, Koss, Erdman, Kozey-Emerich and Romaguera-Fey.

The top Customer by sales is Mraz-Kutch Pharma PLC (95M Euros).

Manager Brittany Bold and her Sales Team (Delta) lead in sales with 3.69bn Euros while Manager James Goodwill and his Sales Team (Alfa) are last with 2.62bn Euros.

The top Sales Representative is Jimmy Grey, helping the company generate 994.94M Euros in sales.

These are some of the important insights generated from the data. There are a lot more information and business insights one can get from this analysis and the 5 dashboards. You can have a look at the power bi report [here](https://app.powerbi.com/view?r=eyJrIjoiYjhiMmM2NDYtZTVjNi00Y2QyLTkwNDQtNjFkNTYwYzBlMjk5IiwidCI6IjFjZTU4MjFjLTE5NDItNDczMy1hNmRjLTBmYzNhODJiNzRkYiJ9).







