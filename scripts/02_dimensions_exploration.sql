# /*

# Script: Dimension Exploration

Script Purpose:
This script explores the dimensional attributes within the analytical
data model.

```
It helps analysts understand the available business entities and their
classifications by examining customer locations and product hierarchies.

The analysis supports:
    • Customer geographic analysis.
    • Product categorization.
    • Business domain understanding.
    • Dimensional data validation.
```

===============================================================================
*/

/*=============================================================================
Customer Geography Analysis
Identify all unique countries represented in the customer dimension.
=============================================================================*/

SELECT DISTINCT
country
FROM gold.dim_customers
ORDER BY country;

/*=============================================================================
Product Hierarchy Analysis
Explore the relationship between categories, subcategories,
and products.
=============================================================================*/

SELECT DISTINCT
category,
subcategory,
product_name
FROM gold.dim_products
ORDER BY
category,
subcategory,
product_name;
