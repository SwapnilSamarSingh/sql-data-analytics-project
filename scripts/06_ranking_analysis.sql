/*

# Script: Ranking Analysis

Script Purpose:
This script ranks products and customers based on various business
performance metrics.

```
Ranking analysis helps identify top-performing and underperforming
entities, enabling businesses to recognize high-value customers,
successful products, and areas requiring improvement.

The analysis supports:
    • Product performance evaluation.
    • Customer value analysis.
    • Revenue-based ranking.
    • Sales performance benchmarking.
    • Identification of business leaders and laggards.
```

===============================================================================
*/

/*=============================================================================
Top 5 Revenue-Generating Products
Identify the products that generate the highest sales revenue.
=============================================================================*/

SELECT TOP 5
p.product_name,
SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

/*=============================================================================
Product Revenue Ranking Using Window Functions
Assign a rank to products based on total revenue.
=============================================================================*/

SELECT *
FROM (
SELECT
p.product_name,
SUM(f.sales_amount) AS total_revenue,
RANK() OVER (
ORDER BY SUM(f.sales_amount) DESC
) AS rank_products
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;

/*=============================================================================
Lowest Performing Products
Identify the products generating the lowest revenue.
=============================================================================*/

SELECT TOP 5
p.product_name,
SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue;

/*=============================================================================
Top Revenue-Generating Customers
Identify the customers contributing the highest revenue.
=============================================================================*/

SELECT TOP 10
c.customer_key,
c.first_name,
c.last_name,
SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY
c.customer_key,
c.first_name,
c.last_name
ORDER BY total_revenue DESC;

/*=============================================================================
Customers with the Fewest Orders
Identify customers with the lowest order activity.
=============================================================================*/

SELECT TOP 3
c.customer_key,
c.first_name,
c.last_name,
COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY
c.customer_key,
c.first_name,
c.last_name
ORDER BY total_orders;
