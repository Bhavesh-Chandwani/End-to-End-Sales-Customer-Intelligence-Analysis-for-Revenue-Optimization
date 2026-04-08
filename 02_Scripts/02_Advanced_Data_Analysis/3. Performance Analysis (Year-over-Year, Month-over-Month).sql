/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */

WITH YEARLY_PRODUCT_SALES AS(
	SELECT 
		YEAR(fs.order_date) AS ORDER_YEAR,
		p.product_name,
		SUM(fs.sales_amount) AS CURRENT_SALES
	FROM gold.fact_sales fs
	LEFT JOIN gold.dim_products p
	ON fs.product_key = p.product_key
	WHERE fs.order_date IS NOT NULL
	GROUP BY 
		YEAR(fs.order_date),
		p.product_name
)

SELECT
	ORDER_YEAR,
	product_name,
	CURRENT_SALES,
	-- AVG CHANGE ANALYSIS
	AVG(CURRENT_SALES) OVER (PARTITION BY product_name) AS AVG_SALES,
	CURRENT_SALES - AVG(CURRENT_SALES) OVER (PARTITION BY product_name) AS AVG_DIFF,
	CASE
		WHEN CURRENT_SALES - AVG(CURRENT_SALES) OVER (PARTITION BY product_name) > 0 THEN 'ABOVE AVERAGE'
		WHEN CURRENT_SALES - AVG(CURRENT_SALES) OVER (PARTITION BY product_name) < 0 THEN 'BELOW AVERAGE'
		ELSE 'AVERAGE'
	END AVG_CHANGE,
	--YEAR OVER YEAR ANALYSIS
	LAG(CURRENT_SALES) OVER (PARTITION BY product_name ORDER BY ORDER_YEAR) AS PREVIOUS_YEAR_SALES,
	CURRENT_SALES - LAG(CURRENT_SALES) OVER (PARTITION BY product_name ORDER BY ORDER_YEAR) AS PY_SALES_DIFF,
	CASE
		WHEN CURRENT_SALES - LAG(CURRENT_SALES) OVER (PARTITION BY product_name ORDER BY ORDER_YEAR) > 0 THEN 'INCREASE'
		WHEN CURRENT_SALES - LAG(CURRENT_SALES) OVER (PARTITION BY product_name ORDER BY ORDER_YEAR) < 0 THEN 'DECREASE'
		ELSE 'NO CHANGE'
	END PY_SALES_CHANGE
FROM YEARLY_PRODUCT_SALES
ORDER BY product_name, ORDER_YEAR
