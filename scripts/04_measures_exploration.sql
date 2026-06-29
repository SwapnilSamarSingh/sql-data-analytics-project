/*

# Script: Measures Exploration (Key Business Metrics)

Script Purpose:
This script calculates fundamental business metrics used to evaluate
overall sales performance and operational activity.

```
The generated measures provide a high-level overview of the business
by summarizing sales, orders, customers, products, and pricing data.

The analysis supports:
    • Executive reporting.
    • KPI monitoring.
    • Business performance evaluation.
    • Data quality validation.
    • Baseline analytical reporting.
```

===============================================================================
*/

/*=============================================================================
Total Sales Revenue
=============================================================================*/

SELECT
SUM(sales_amount) AS total_sales
FROM gold.fact_sales;

/*=============================================================================
Total Quantity Sold
=============================================================================*/

SELECT
SUM(quantity) AS total_quantity
FROM gold.fact_sales;

/*=============================================================================
Average Selling Price
=============================================================================*/

SELECT
AVG(price) AS avg_price
FROM gold.fact_sales;

/*=============================================================================
Total Number of Orders
=============================================================================*/

SELECT
COUNT(order_number) AS total_orders
FROM gold.fact_sales;

SELECT
COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales;

/*=============================================================================
Total Number of Products
=============================================================================*/

SELECT
COUNT(product_name) AS total_products
FROM gold.dim_products;

/*=============================================================================
Total Number of Customers
=============================================================================*/

SELECT
COUNT(customer_key) AS total_customers
FROM gold.dim_customers;

/*=============================================================================
Active Customers
Customers who have placed at least one order.
=============================================================================*/

SELECT
COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales;

/*=============================================================================
Business KPI Summary Report
Consolidate key business metrics into a single result set.
=============================================================================*/

SELECT
'Total Sales' AS measure_name,
SUM(sales_amount) AS measure_value
FROM gold.fact_sales

UNION ALL

SELECT
'Total Quantity',
SUM(quantity)
FROM gold.fact_sales

UNION ALL

SELECT
'Average Price',
AVG(price)
FROM gold.fact_sales

UNION ALL

SELECT
'Total Orders',
COUNT(DISTINCT order_number)
FROM gold.fact_sales

UNION ALL

SELECT
'Total Products',
COUNT(DISTINCT product_name)
FROM gold.dim_products

UNION ALL

SELECT
'Total Customers',
COUNT(customer_key)
FROM gold.dim_customers;
