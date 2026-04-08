/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Which 5 products Generating the Highest Revenue?
-- Simple Ranking
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- Complex but Flexibly Ranking Using Window Functions
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;

-- What are the 5 worst-performing products in terms of sales?
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue;

-- Find the top 10 customers who have generated the highest revenue
SELECT
	*
FROM(
	SELECT 
		c.customer_key,
		CONCAT(c.first_name, ' ', c.last_name) AS FULL_NAME,
		SUM(fs.sales_amount) AS TOTAL_REVENUE,
		DENSE_RANK() OVER (ORDER BY SUM(sales_amount) DESC) AS CUSTOMER_RANK
	FROM gold.fact_sales fs
	LEFT JOIN gold.dim_customers c
	ON fs.customer_key = c.customer_key
	GROUP BY 
		c.customer_key,
		CONCAT(c.first_name, ' ', c.last_name)
)t
WHERE CUSTOMER_RANK <= 10

-- The 3 customers with the fewest orders placed
SELECT TOP 3
	c.customer_key,
	CONCAT(c.first_name, ' ', c.last_name) FULL_NAME,
	COUNT(DISTINCT fs.order_number) AS TOTAL_ORDERS
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers c
ON fs.customer_key = c.customer_key
GROUP BY
	c.customer_key,
	CONCAT(c.first_name, ' ', c.last_name)
ORDER BY TOTAL_ORDERS 
