/*

# Script: Performance Analysis (Year-over-Year Analysis)

Script Purpose:
This script evaluates product performance over time by comparing
annual sales results against historical and average performance.

```
The analysis measures:
    • Yearly product sales performance.
    • Product performance relative to average sales.
    • Year-over-Year (YoY) sales changes.
    • Sales growth and decline trends.

The analysis supports:
    • Product performance evaluation.
    • Benchmarking against historical performance.
    • Growth trend identification.
    • Revenue performance monitoring.
    • Business decision-making.
```

===============================================================================
*/

/*=============================================================================
Product Performance Analysis

```
Analyze annual product sales and compare:

    • Current sales versus average product sales.
    • Current sales versus previous year's sales.
    • Year-over-Year growth or decline.
```

=============================================================================*/

WITH yearly_product_sales AS
(
SELECT
YEAR(f.order_date) AS order_year,
p.product_name,
SUM(f.sales_amount) AS current_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE f.order_date IS NOT NULL
GROUP BY
YEAR(f.order_date),
p.product_name
)

SELECT
order_year,
product_name,
current_sales,

```
/*---------------------------------------------------------
    Average Sales Benchmark
---------------------------------------------------------*/

AVG(current_sales) OVER (
    PARTITION BY product_name
) AS avg_sales,

current_sales -
AVG(current_sales) OVER (
    PARTITION BY product_name
) AS diff_avg,

CASE
    WHEN current_sales -
         AVG(current_sales) OVER (
             PARTITION BY product_name
         ) > 0
        THEN 'Above Avg'

    WHEN current_sales -
         AVG(current_sales) OVER (
             PARTITION BY product_name
         ) < 0
        THEN 'Below Avg'

    ELSE 'Avg'
END AS avg_change,


/*---------------------------------------------------------
    Year-over-Year Analysis
---------------------------------------------------------*/

LAG(current_sales) OVER (
    PARTITION BY product_name
    ORDER BY order_year
) AS py_sales,

current_sales -
LAG(current_sales) OVER (
    PARTITION BY product_name
    ORDER BY order_year
) AS diff_py,

CASE
    WHEN current_sales -
         LAG(current_sales) OVER (
             PARTITION BY product_name
             ORDER BY order_year
         ) > 0
        THEN 'Increase'

    WHEN current_sales -
         LAG(current_sales) OVER (
             PARTITION BY product_name
             ORDER BY order_year
         ) < 0
        THEN 'Decrease'

    ELSE 'No Change'
END AS py_change
```

FROM yearly_product_sales

ORDER BY
product_name,
order_year;
