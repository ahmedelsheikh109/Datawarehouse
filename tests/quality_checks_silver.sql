-- -----------------------------------------------------------------------------
-- Project: Modern SQL Data Warehouse & Analytics
-- Script: Silver Layer Quality Checks
-- -----------------------------------------------------------------------------
-- This script performs data validation checks on the 'silver' layer.
--   - Identifies NULL or duplicate primary keys.
--   - Validates text formatting (e.g., trailing/leading spaces).
--   - Ensures date ranges and logical date orders are valid.
--   - Confirms calculation accuracy (e.g., Sales = Qty * Price).
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- CRM: Customer Info
-- -----------------------------------------------------------------------------
-- Test: Primary Key Integrity
SELECT 
    cst_id,
    COUNT(*) AS total_records
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Test: Whitespace Detection
SELECT 
    cst_key 
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Test: Categorical Standardization
SELECT DISTINCT 
    cst_marital_status 
FROM silver.crm_cust_info;

-- -----------------------------------------------------------------------------
-- CRM: Product Info
-- -----------------------------------------------------------------------------
-- Test: Primary Key Integrity
SELECT 
    prd_id,
    COUNT(*) AS total_records
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Test: Whitespace Detection
SELECT 
    prd_nm 
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Test: Cost Validation
SELECT 
    prd_cost 
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Test: Categorical Standardization
SELECT DISTINCT 
    prd_line 
FROM silver.crm_prd_info;

-- Test: Logical Date Order (Start <= End)
SELECT * 
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- -----------------------------------------------------------------------------
-- CRM: Sales Details
-- -----------------------------------------------------------------------------
-- Test: Invalid Date Validation
SELECT 
    NULLIF(sls_due_dt, 0) AS due_date_issue 
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
   OR LEN(sls_due_dt) != 8 
   OR sls_due_dt > 20500101 
   OR sls_due_dt < 19000101;

-- Test: Logical Date Order (Order <= Ship <= Due)
SELECT * 
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
   OR sls_order_dt > sls_due_dt;

-- Test: Mathematical Consistency
SELECT DISTINCT 
    sls_sales,
    sls_quantity,
    sls_price 
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- -----------------------------------------------------------------------------
-- ERP: Customer Demographics
-- -----------------------------------------------------------------------------
-- Test: Date Range Validation
SELECT DISTINCT 
    bdate 
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' 
   OR bdate > GETDATE();

-- Test: Categorical Standardization
SELECT DISTINCT 
    gen 
FROM silver.erp_cust_az12;

-- -----------------------------------------------------------------------------
-- ERP: Location Data
-- -----------------------------------------------------------------------------
-- Test: Categorical Standardization
SELECT DISTINCT 
    cntry 
FROM silver.erp_loc_a101
ORDER BY cntry;

-- -----------------------------------------------------------------------------
-- ERP: Product Categories
-- -----------------------------------------------------------------------------
-- Test: Whitespace Detection
SELECT * 
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
   OR subcat != TRIM(subcat) 
   OR maintenance != TRIM(maintenance);

-- Test: Categorical Standardization
SELECT DISTINCT 
    maintenance 
FROM silver.erp_px_cat_g1v2;
