/*

# View: gold.report_products

Script Purpose:
This view consolidates product-level metrics, sales performance,
customer reach, and product behavior into a single analytical report.

```
The report provides a comprehensive product profile by combining
sales transactions, customer activity, product dimensions, and
performance indicators.

The report supports:
    • Product performance analysis.
    • Revenue analysis.
    • Product segmentation.
    • Customer reach analysis.
    • Sales trend evaluation.
    • Business reporting and dashboards.
```

===============================================================================
*/

/*=============================================================================
Drop Existing View
=============================================================================*/

IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
DROP VIEW gold.report_products;
GO

/==============================================================================
Create Product Analytics Report
==============================================================================/

CREATE VIEW gold.report_products AS

WITH base_query AS
(
/*-------------------------------------------------------------------------
Stage 1: Base Product Transactions

```
    Retrieve transactional and product information required for
    product-level analysis.
-------------------------------------------------------------------------*/

SELECT
    f.order_number,
    f.order_date,
    f.customer_key,
    f.sales_amount,
    f.quantity,

    p.product_key,
    p.product_name,
    p.category,
    p.subcategory,
    p.cost

FROM gold.fact_sales f

LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key

WHERE order_date IS NOT NULL
```

),

product_aggregations AS
(
/*-------------------------------------------------------------------------
Stage 2: Product-Level Aggregations

```
    Calculate sales, customer, and performance metrics for each
    product.
-------------------------------------------------------------------------*/

SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,

    DATEDIFF(
        MONTH,
        MIN(order_date),
        MAX(order_date)
    ) AS lifespan,

    MAX(order_date) AS last_sale_date,

    COUNT(DISTINCT order_number) AS total_orders,
    COUNT(DISTINCT customer_key) AS total_customers,

    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,

    ROUND(
        AVG(
            CAST(sales_amount AS FLOAT)
            / NULLIF(quantity, 0)
        ),
        1
    ) AS avg_selling_price

FROM base_query

GROUP BY
    product_key,
    product_name,
    category,
    subcategory,
    cost
```

)

/*-------------------------------------------------------------------------
Stage 3: Final Product Report

```
Combine product metrics, performance indicators, and segmentation
attributes into a single analytical view.
```

-------------------------------------------------------------------------*/

SELECT
product_key,
product_name,
category,
subcategory,
cost,

```
last_sale_date,

DATEDIFF(
    MONTH,
    last_sale_date,
    GETDATE()
) AS recency_in_months,

/*-------------------------------------------------------------------------
    Product Performance Segmentation
-------------------------------------------------------------------------*/

CASE
    WHEN total_sales > 50000 THEN 'High-Performer'
    WHEN total_sales >= 10000 THEN 'Mid-Range'
    ELSE 'Low-Performer'
END AS product_segment,

lifespan,
total_orders,
total_sales,
total_quantity,
total_customers,
avg_selling_price,

/*-------------------------------------------------------------------------
    Average Order Revenue (AOR)
-------------------------------------------------------------------------*/

CASE
    WHEN total_orders = 0 THEN 0
    ELSE total_sales / total_orders
END AS avg_order_revenue,

/*-------------------------------------------------------------------------
    Average Monthly Revenue
-------------------------------------------------------------------------*/

CASE
    WHEN lifespan = 0 THEN total_sales
    ELSE total_sales / lifespan
END AS avg_monthly_revenue
```

FROM product_aggregations;
