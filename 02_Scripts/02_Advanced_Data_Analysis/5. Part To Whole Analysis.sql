/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
-- Which categories contribute the most to overall sales?
WITH CATEGORY_SALES AS(
SELECT
	p.category,
	SUM(fs.sales_amount) AS TOTAL_SALES
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products p
ON fs.product_key = p.product_key
GROUP BY p.category
)

SELECT 
	category,
	TOTAL_SALES,
	SUM(TOTAL_SALES) OVER() AS OVERALL_SALES,
	CONCAT(ROUND((CAST(TOTAL_SALES AS FLOAT) / SUM(TOTAL_SALES) OVER()) * 100, 2), '%') AS PERCENTAGE_OF_TOTAL
FROM CATEGORY_SALES

 