-- -----------------------------------------------------------------------------
-- Project: Modern SQL Data Warehouse & Analytics
-- Script: Gold Layer Quality Checks
-- -----------------------------------------------------------------------------
-- This script contains queries to validate the integrity and consistency 
-- of the Gold Layer Star Schema.
--   - Validates uniqueness of Surrogate Keys in dimensions.
--   - Validates referential integrity between Facts and Dimensions.
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Test: gold.dim_customers
-- Objective: Ensure Customer Key uniqueness
-- Expected Result: 0 rows returned
-- -----------------------------------------------------------------------------
SELECT 
    customer_key,
    COUNT(*) AS records_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- -----------------------------------------------------------------------------
-- Test: gold.dim_products
-- Objective: Ensure Product Key uniqueness
-- Expected Result: 0 rows returned
-- -----------------------------------------------------------------------------
SELECT 
    product_key,
    COUNT(*) AS records_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- -----------------------------------------------------------------------------
-- Test: gold.fact_sales
-- Objective: Validate referential integrity (Fact -> Dimensions)
-- Expected Result: 0 rows returned
-- -----------------------------------------------------------------------------
SELECT * 
FROM gold.fact_sales fact
LEFT JOIN gold.dim_customers cust
    ON cust.customer_key = fact.customer_key
LEFT JOIN gold.dim_products prd
    ON prd.product_key = fact.product_key
WHERE prd.product_key IS NULL 
   OR cust.customer_key IS NULL;
