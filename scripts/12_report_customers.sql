/*

# View: gold.report_customers

Script Purpose:
This view consolidates customer-level metrics, purchasing behavior,
and segmentation attributes into a single analytical report.

```
The report provides a comprehensive customer profile by combining
demographic information, purchasing history, sales performance,
recency metrics, and customer segmentation.

The report supports:
    • Customer analytics.
    • Customer segmentation.
    • Recency and lifespan analysis.
    • Revenue analysis.
    • Customer value assessment.
    • Business reporting and dashboards.
```

===============================================================================
*/

/*=============================================================================
Drop Existing View
=============================================================================*/

IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
DROP VIEW gold.report_customers;
GO

/==============================================================================
Create Customer Analytics Report
==============================================================================/

CREATE VIEW gold.report_customers AS

WITH base_query AS
(
/*-------------------------------------------------------------------------
Stage 1: Base Customer Transactions

```
    Retrieve transactional and customer information required for
    customer-level analysis.
-------------------------------------------------------------------------*/

SELECT
    f.order_number,
    f.product_key,
    f.order_date,
    f.sales_amount,
    f.quantity,

    c.customer_key,
    c.customer_number,

    CONCAT(
        c.first_name,
        ' ',
        c.last_name
    ) AS customer_name,

    DATEDIFF(YEAR, c.birthdate, GETDATE()) AS age

FROM gold.fact_sales f

LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key

WHERE order_date IS NOT NULL
```

),

customer_aggregation AS
(
/*-------------------------------------------------------------------------
Stage 2: Customer-Level Aggregations

```
    Calculate purchasing, sales, and engagement metrics for each
    customer.
-------------------------------------------------------------------------*/

SELECT
    customer_key,
    customer_number,
    customer_name,
    age,

    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT product_key) AS total_products,

    MAX(order_date) AS last_order_date,

    DATEDIFF(
        MONTH,
        MIN(order_date),
        MAX(order_date)
    ) AS lifespan

FROM base_query

GROUP BY
    customer_key,
    customer_number,
    customer_name,
    age
```

)

SELECT
customer_key,
customer_number,
customer_name,
age,

```
/*-------------------------------------------------------------------------
    Customer Age Segmentation
-------------------------------------------------------------------------*/

CASE
    WHEN age < 20 THEN 'Under 20'
    WHEN age BETWEEN 20 AND 29 THEN '20-29'
    WHEN age BETWEEN 30 AND 39 THEN '30-39'
    WHEN age BETWEEN 40 AND 49 THEN '40-49'
    ELSE '50 and above'
END AS age_group,

/*-------------------------------------------------------------------------
    Customer Value Segmentation
-------------------------------------------------------------------------*/

CASE
    WHEN lifespan >= 12
         AND total_sales > 5000 THEN 'VIP'

    WHEN lifespan >= 12
         AND total_sales <= 5000 THEN 'Regular'

    ELSE 'New'
END AS customer_segment,

last_order_date,

/*-------------------------------------------------------------------------
    Recency Analysis
-------------------------------------------------------------------------*/

DATEDIFF(
    MONTH,
    last_order_date,
    GETDATE()
) AS recency,

total_orders,
total_sales,
total_quantity,
total_products,
lifespan,

/*-------------------------------------------------------------------------
    Average Order Value (AOV)
-------------------------------------------------------------------------*/

CASE
    WHEN total_sales = 0 THEN 0
    ELSE total_sales / total_orders
END AS avg_order_value,

/*-------------------------------------------------------------------------
    Average Monthly Spending
-------------------------------------------------------------------------*/

CASE
    WHEN lifespan = 0 THEN total_sales
    ELSE total_sales / lifespan
END AS avg_monthly_spend
```

FROM customer_aggregation;
