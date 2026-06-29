/*

# Script: Data Segmentation Analysis

Script Purpose:
This script segments products and customers into meaningful business
categories to support targeted analysis and decision-making.

```
Segmentation analysis helps identify customer groups, product tiers,
and behavioral patterns that can be used for reporting, marketing,
and performance evaluation.

The analysis supports:
    • Product categorization.
    • Customer segmentation.
    • Spending behavior analysis.
    • Customer value assessment.
    • Business strategy and targeting.
```

===============================================================================
*/

/*=============================================================================
Product Cost Segmentation

```
Categorize products into cost ranges and measure the number of
products within each segment.
```

=============================================================================*/

WITH product_segments AS
(
SELECT
product_key,
product_name,
cost,

```
    CASE
        WHEN cost < 100 THEN 'Below 100'
        WHEN cost BETWEEN 100 AND 500 THEN '100-500'
        WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
        ELSE 'Above 1000'
    END AS cost_range

FROM gold.dim_products
```

)

SELECT
cost_range,
COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;

/*=============================================================================
Customer Segmentation Analysis

```
Customer segments are defined as:

    • VIP:
        Customers with at least 12 months of purchasing history
        and total spending greater than €5,000.

    • Regular:
        Customers with at least 12 months of purchasing history
        and total spending less than or equal to €5,000.

    • New:
        Customers with less than 12 months of purchasing history.
```

=============================================================================*/

WITH customer_spending AS
(
SELECT
c.customer_key,
SUM(f.sales_amount) AS total_spending,
MIN(order_date) AS first_order,
MAX(order_date) AS last_order,

```
    DATEDIFF(
        MONTH,
        MIN(order_date),
        MAX(order_date)
    ) AS lifespan

FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key

GROUP BY c.customer_key
```

)

SELECT
customer_segment,
COUNT(customer_key) AS total_customers

FROM
(
SELECT
customer_key,

```
    CASE
        WHEN lifespan >= 12
             AND total_spending > 5000
            THEN 'VIP'

        WHEN lifespan >= 12
             AND total_spending <= 5000
            THEN 'Regular'

        ELSE 'New'
    END AS customer_segment

FROM customer_spending
```

) AS segmented_customers

GROUP BY customer_segment
ORDER BY total_customers DESC;
