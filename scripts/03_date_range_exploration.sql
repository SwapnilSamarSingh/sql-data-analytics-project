/*

# Script: Date Range Exploration

Script Purpose:
This script analyzes the temporal coverage of the analytical dataset.

```
It identifies the available time span of transactional data and
evaluates customer age distribution using birthdate information.

The analysis supports:
    • Understanding historical data availability.
    • Determining the reporting period.
    • Assessing customer age ranges.
    • Validating date-related business data.
```

===============================================================================
*/

/*=============================================================================
Sales Data Time Range
Determine the earliest and latest order dates and calculate
the total reporting period in months.
=============================================================================*/

SELECT
MIN(order_date) AS first_order_date,
MAX(order_date) AS last_order_date,
DATEDIFF(
MONTH,
MIN(order_date),
MAX(order_date)
) AS order_range_months
FROM gold.fact_sales;

/*=============================================================================
Customer Age Distribution
Identify the oldest and youngest customers based on birthdate.
=============================================================================*/

SELECT
MIN(birthdate) AS oldest_birthdate,
DATEDIFF(
YEAR,
MIN(birthdate),
GETDATE()
) AS oldest_age,

```
MAX(birthdate) AS youngest_birthdate,
DATEDIFF(
    YEAR,
    MAX(birthdate),
    GETDATE()
) AS youngest_age
```

FROM gold.dim_customers;
