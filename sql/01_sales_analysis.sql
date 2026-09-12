
DROP TABLE IF EXISTS sales_analysis;

CREATE TEMP TABLE sales_analysis AS
SELECT s.*, CAST(REPLACE(REPLACE("Unit Price USD", "$",""), ",","") AS DECIMAL) AS "Unit Price USD",
CAST(REPLACE(REPLACE("Unit Cost USD", "$",""), ",","") AS DECIMAL) AS "Unit Cost USD",
CAST(REPLACE(REPLACE("Unit Price USD", "$",""), ",","") - REPLACE(REPLACE("Unit Cost USD", "$",""), ",","") AS DECIMAL) AS "Gross Profit USD",
p.Category,p."Product Name",p."Unit Price USD",p."Unit Cost USD"
FROM sales s
LEFT JOIN products p
ON s.ProductKey = p.ProductKey


SELECT SUM(Quantity * "Unit Price USD") AS "Total Revenue"
FROM sales_analysis

-- Total Revenue : 55,755,479.59 $

SELECT Category, SUM(Quantity * "Unit Price USD") AS "Total Revenue"
FROM sales_analysis
GROUP BY Category
ORDER BY "Total Revenue" DESC

-- The product category that generated the highest revenue was Computers, with 19,301,595.46 $ in total

SELECT s.*,p."Category" FROM 
(SELECT 
	"Product Name", 
	SUM(Quantity * "Unit Price USD") AS "Total Revenue"
FROM sales_analysis 
GROUP BY "Product Name"
ORDER BY "Total Revenue" DESC) AS s
LEFT JOIN products p
on s."Product Name" = p."Product Name"
-- The product that generated the highest revenue was "WWI Desktop PC2.33 X2330 Black"  whose category is "Computers"

SELECT 
    "Product Name",
    SUM(Quantity * "Unit Price USD") AS "Total Revenue",
    SUM(Quantity * "Unit Price USD"-"Unit Cost USD") AS "Total Profit"
FROM sales_analysis
GROUP BY "Product Name"
ORDER BY "Total Profit" DESC
LIMIT 10;

-- The top 10 products accounted for a significant share of total profit.




SELECT *, Quantity * "Gross Profit USD" AS "Total Profit USD"
FROM sales_analysis
ORDER BY "Total Profit USD" DESC
/* 
The order number that generated the highest profit was 433005 with 21397.7$ total profit 
and the category of this product was Home Apliances
*/

SELECT Category, SUM(Quantity * "Gross Profit USD") AS "Total Profit USD"
FROM sales_analysis
GROUP BY Category
ORDER BY "Total Profit USD" DESC
/* 
The product category which generated the highest profit was Computers,
with 11,277,447.9$ in total
*/

SELECT Category, SUBSTR("Order Date",-4) as Year, SUM(Quantity * "Gross Profit USD") AS "Total Profit USD"
FROM sales_analysis
GROUP BY Category, Year
ORDER BY Year ASC, "Total Profit USD" ASC

-- Analysis of total profit by year and category

WITH order_summary AS (
    SELECT 
        "Order Number",
        SUM("Line Item") AS "Total Line Item",
        SUM(Quantity * "Gross Profit USD") AS "Total Profit USD"
    FROM sales_analysis
    GROUP BY "Order Number"
)

SELECT * FROM order_summary
ORDER BY "Total Line Item" DESC

-- Summarizes each order by total line items and total profit


SELECT Category, ROUND(SUM(Quantity * ("Unit Price USD" - "Unit Cost USD"))/ 
SUM(Quantity * "Unit Price USD") *100,2) as "Profit Margin by Category"
FROM sales_analysis
GROUP BY Category

-- Profit Margin by Category = Total Profit / Total Revenue × 100 

SELECT 
    Category,
    SUM(Quantity) AS "Total Quantity",
    SUM(Quantity * "Unit Price USD") AS "Total Revenue"
FROM sales_analysis
GROUP BY Category
ORDER BY "Total Revenue" DESC;

/*
Revenue was not directly proportional to quantity sold.
Some categories generated relatively high revenue despite having lower sales volume,
suggesting higher average selling prices per unit.
*/


WITH order_sales AS (
    SELECT
        "Order Number",
        SUM(Quantity * REPLACE(REPLACE("Unit Price USD", "$", ""),",","")) AS "Order Revenue"
    FROM sales_analysis
    GROUP BY "Order Number"
)

SELECT 
    ROUND(AVG("Order Revenue"),2) AS "Average Order Value"
FROM order_sales;

-- Calculates the average revenue generated per order


SELECT 
    "Total Line Item",
    COUNT(*) AS "Order Count",
    AVG("Total Profit USD") AS "Average Profit USD",
    MAX("Total Profit USD") AS "Max Profit USD",
    MIN("Total Profit USD") AS "Min Profit USD"
FROM order_summary
GROUP BY "Total Line Item"
ORDER BY "Total Line Item";

-- Orders with 28 line items have the highest average profit.

