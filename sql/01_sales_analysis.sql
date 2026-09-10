CREATE TEMP TABLE sales_analysis AS
SELECT s.*,
REPLACE(REPLACE("Unit Price USD", "$",""), ",","") - REPLACE(REPLACE("Unit Cost USD", "$",""), ",","") AS "Gross Profit USD",
p.Category
FROM sales s
LEFT JOIN products p
ON s.ProductKey = p.ProductKey

SELECT *, Quantity * "Gross Profit USD" AS "Total Profit USD"
FROM sales_analysis
ORDER BY "Total Profit USD" DESC
/* The order number that generated the highest profit was 433005 with 21397.7$ total profit 
and the category of this product was Home Apliances
*/

SELECT Category, SUM(Quantity * "Gross Profit USD") AS "Total Profit USD"
FROM sales_analysis
GROUP BY Category
ORDER BY "Total Profit USD" DESC



