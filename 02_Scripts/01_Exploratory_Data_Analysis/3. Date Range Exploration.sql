/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Determine the first and last order date and the total duration in months
SELECT
	MIN(order_date) AS FIRST_ORDER_DATE,
	MAX(order_date) AS LAST_ORDER_DATE,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS TOTAL_MONTH_DURATION
FROM gold.fact_sales

-- Find the youngest and oldest customer based on birthdate
SELECT
	MAX(birthdate) AS YOUNGEST_BIRTH_DATE,
	MIN(birthdate) AS OLDEST_BIRTH_DATE,
	DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS YOUNGEST_CUSTOMER,
	DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS OLDEST_CUSTOMER
FROM goLd.dim_customers
