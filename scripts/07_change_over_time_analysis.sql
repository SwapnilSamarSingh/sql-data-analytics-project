/*

# Script: Change Over Time Analysis

Script Purpose:
This script analyzes business performance over time by aggregating
key metrics across monthly periods.

```
Time-series analysis helps identify trends, growth patterns,
seasonality, and changes in business performance.

The analysis supports:
    • Sales trend analysis.
    • Customer activity monitoring.
    • Demand analysis.
    • Period-over-period comparisons.
    • Business performance tracking.
```

===============================================================================
*/

/*=============================================================================
Monthly Sales Performance
Aggregate key business metrics by year and month using
date extraction functions.
=============================================================================*/

SELECT
YEAR(order_date) AS order_year,
MONTH(order_date) AS order_month,
SUM(sales_amount) AS total_sales,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY
YEAR(order_date),
MONTH(order_date)
ORDER BY
YEAR(order_date),
MONTH(order_date);

/*=============================================================================
Monthly Performance Using DATETRUNC()
Group transactions by month using SQL Server date truncation.
=============================================================================*/

SELECT
DATETRUNC(month, order_date) AS order_date,
SUM(sales_amount) AS total_sales,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date);

/*=============================================================================
Monthly Performance Using FORMAT()
Generate a formatted monthly reporting period.
=============================================================================*/

SELECT
FORMAT(order_date, 'yyyy-MMM') AS order_date,
SUM(sales_amount) AS total_sales,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM');
