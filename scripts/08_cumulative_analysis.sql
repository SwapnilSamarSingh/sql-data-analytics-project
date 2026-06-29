/*

# Script: Cumulative Analysis

Script Purpose:
This script performs cumulative analysis to evaluate business
performance over time.

```
It calculates running totals and moving averages to monitor growth,
identify long-term trends, and measure changes in business performance.

The analysis supports:
    • Growth analysis.
    • Trend evaluation.
    • Performance monitoring.
    • Cumulative sales tracking.
    • Long-term business assessment.
```

===============================================================================
*/

/*=============================================================================
Annual Sales Trend Analysis

```
Calculate yearly sales performance and derive:
    • Running total sales.
    • Moving average selling price.

Window functions are used to measure cumulative business growth
and pricing trends over time.
```

=============================================================================*/

SELECT
order_date,
total_sales,

```
SUM(total_sales) OVER (
    ORDER BY order_date
) AS running_total_sales,

AVG(avg_price) OVER (
    ORDER BY order_date
) AS moving_average_price
```

FROM
(
SELECT
DATETRUNC(year, order_date) AS order_date,
SUM(sales_amount) AS total_sales,
AVG(price) AS avg_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(year, order_date)
) t;
