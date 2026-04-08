/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

-- =============================================================================
-- Create Report: gold.report_customers
-- =============================================================================
WITH BASE_QUERY AS(
SELECT
	fs.order_number,
	fs.product_key,
	fs.order_date,
	fs.sales_amount,
	fs.quantity,
	c.customer_key,
	c.customer_number,
	CONCAT(c.first_name, ' ' , c.last_name) AS CUSTOMER_NAME,
	DATEDIFF(YEAR, c.birthdate, GETDATE()) AS AGE
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers c
ON fs.customer_key = c.customer_key
WHERE fs.order_date IS NOT NULL
)

SELECT 
	*
FROM BASE_QUERY 
