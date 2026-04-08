/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- Analyse sales performance over time
-- Quick Date Functions

SELECT
	YEAR(order_date) AS ORDER_YEAR,
	MONTH(order_date) AS ORDER_MONTH,
	SUM(sales_amount) AS TOTAL_SALES,
	COUNT(DISTINCT customer_key) AS TOTAL_CUSTOMERS 
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date)

-- DATETRUNC()
SELECT 
	DATETRUNC(MONTH, order_date) AS ORDER_DATE,
	SUM(sales_amount) AS TOTAL_SALES,
	COUNT(DISTINCT customer_key) AS TOTAL_CUSTOMERS,
	SUM(quantity) AS TOTAL_QUANTITIES
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
ORDER BY DATETRUNC(MONTH, order_date)