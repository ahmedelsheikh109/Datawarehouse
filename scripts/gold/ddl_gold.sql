-- -----------------------------------------------------------------------------
-- Project: Modern SQL Data Warehouse & Analytics
-- Script: Create Gold Layer Views (Star Schema)
-- -----------------------------------------------------------------------------
-- This script provisions the views for the Gold layer in the data warehouse. 
-- These views combine and enrich data from the Silver layer to form 
-- a clean, business-ready Star Schema (Fact and Dimension tables).
-- -----------------------------------------------------------------------------

-- ------------------------
-- Dimension: Customers
-- ------------------------
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY cust.cst_id) AS customer_key,
    cust.cst_id                              AS customer_id,
    cust.cst_key                             AS customer_number,
    cust.cst_firstname                       AS first_name,
    cust.cst_lastname                        AS last_name,
    loc.cntry                                AS country,
    cust.cst_marital_status                  AS marital_status,
    CASE 
        WHEN cust.cst_gndr != 'n/a' THEN cust.cst_gndr 
        ELSE ISNULL(demog.gen, 'n/a')  			   
    END                                      AS gender,
    demog.bdate                              AS birthdate,
    cust.cst_create_date                     AS create_date
FROM silver.crm_cust_info cust
LEFT JOIN silver.erp_cust_az12 demog
    ON cust.cst_key = demog.cid
LEFT JOIN silver.erp_loc_a101 loc
    ON cust.cst_key = loc.cid;
GO

-- ------------------------
-- Dimension: Products
-- ------------------------
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY prd.prd_start_dt, prd.prd_key) AS product_key,
    prd.prd_id       AS product_id,
    prd.prd_key      AS product_number,
    prd.prd_nm       AS product_name,
    prd.cat_id       AS category_id,
    cat.cat          AS category,
    cat.subcat       AS subcategory,
    cat.maintenance  AS maintenance,
    prd.prd_cost     AS cost,
    prd.prd_line     AS product_line,
    prd.prd_start_dt AS start_date
FROM silver.crm_prd_info prd
LEFT JOIN silver.erp_px_cat_g1v2 cat
    ON prd.cat_id = cat.id
WHERE prd.prd_end_dt IS NULL; 
GO

-- ------------------------
-- Fact: Sales
-- ------------------------
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
    sls.sls_ord_num  AS order_number,
    p_dim.product_key  AS product_key,
    c_dim.customer_key AS customer_key,
    sls.sls_order_dt AS order_date,
    sls.sls_ship_dt  AS shipping_date,
    sls.sls_due_dt   AS due_date,
    sls.sls_sales    AS sales_amount,
    sls.sls_quantity AS quantity,
    sls.sls_price    AS price
FROM silver.crm_sales_details sls
LEFT JOIN gold.dim_products p_dim
    ON sls.sls_prd_key = p_dim.product_number
LEFT JOIN gold.dim_customers c_dim
    ON sls.sls_cust_id = c_dim.customer_id;
GO
