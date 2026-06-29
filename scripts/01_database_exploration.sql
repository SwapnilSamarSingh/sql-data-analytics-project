# /*

# Script: Database Exploration

Script Purpose:
This script performs an initial exploration of the analytical database.

```
It provides:
    • An overview of all available tables and schemas.
    • Metadata information for specific tables.
    • Structural insights into the database model.

These queries are useful for understanding the database structure
before performing analytical or reporting tasks.
```

===============================================================================
*/

/*=============================================================================
Explore Database Tables
Retrieve all tables and schemas available in the database.
=============================================================================*/

SELECT
TABLE_CATALOG,
TABLE_SCHEMA,
TABLE_NAME,
TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES;

/*=============================================================================
Explore Table Columns
Inspect metadata for the dim_customers table.
=============================================================================*/

SELECT
COLUMN_NAME,
DATA_TYPE,
IS_NULLABLE,
CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';
