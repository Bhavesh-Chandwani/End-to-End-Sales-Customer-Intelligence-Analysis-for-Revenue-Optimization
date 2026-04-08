/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

/*Segment products into cost ranges and 
count how many products fall into each segment*/

WITH PRODUCTS_SEGMENT AS (
SELECT
	product_key,
	product_name,
	cost,
	CASE
		WHEN cost < 100 THEN 'BELOW 100'
		WHEN cost BETWEEN 100 AND 500 THEN '100-500'
		WHEN cost BETWEEN 500 AND 100 THEN '500-1000'
		ELSE 'ABOVE 1000'
	END AS COST_RANGE
FROM gold.dim_products
)

SELECT
	COST_RANGE,
	COUNT(product_key) AS TOTAL_PRODUCTS
FROM PRODUCTS_SEGMENT
GROUP BY COST_RANGE
ORDER BY TOTAL_PRODUCTS DESC

/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

WITH CUSTOMER_SPENDING AS(
SELECT
	c.customer_key,
	SUM(sales_amount) AS TOTAL_SPENDING,
	MIN(order_date) AS FIRST_ORDER,
	MAX(order_date) AS LAST_ORDER,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS LIFE_SPAN
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers c
ON fs.customer_key = c.customer_key
GROUP BY c.customer_key
)

SELECT 
	CUSTOMER_SEGMENT,
	COUNT(customer_key) AS TOTAL_CUSTOMERS
FROM(
SELECT 
	customer_key,
	CASE
		WHEN TOTAL_SPENDING >= 5000 AND LIFE_SPAN >= 12 THEN 'VIP CUSTOMER'
		WHEN TOTAL_SPENDING <= 5000 AND LIFE_SPAN <= 12 THEN 'REGULAR CUSTOMER'
		ELSE 'NEW CUSTOMER'
	END AS CUSTOMER_SEGMENT
FROM CUSTOMER_SPENDING
) AS SEGMENTED_CUSTOMERS
GROUP BY CUSTOMER_SEGMENT
ORDER BY TOTAL_CUSTOMERS