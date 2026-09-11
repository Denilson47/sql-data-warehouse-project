/*
-- ============================================================================
-- Quality Checks
-- ============================================================================
-- Script Purpose:
--   This script performs various quality checks for data consistency, accuracy,
--   and standardization across the 'silver' schema. It includes checks for:
--   - Null or duplicate primary keys.
--   - Unwanted spaces in string fields.
--   - Data standardization and consistency.
--   - Invalid date ranges and orders.
--   - Data consistency between related fields.
--
-- Usage Notes:
--   - Run these checks after data loading Silver Layer.
--   - Investigate and resolve any discrepancies found during the checks.
-- ============================================================================
*/

-- ============================================================================
-- CHECKING 'silver.crm_cust_info'
-- ============================================================================

-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT 
    cst_id,
    COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for Unwanted Spaces in String Fields
-- Expectation: No Results
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- Check Data Standardization - Gender Values
-- Expectation: Only 'Female', 'Male', and 'n/a' should exist
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info
ORDER BY cst_gndr;

-- Check Data Standardization - Marital Status Values
-- Expectation: Only 'Single', 'Married', and 'n/a' should exist
SELECT DISTINCT cst_maritalstatus
FROM silver.crm_cust_info
ORDER BY cst_maritalstatus;


-- ============================================================================
-- CHECKING 'silver.crm_prd_info'
-- ============================================================================

-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT 
    prd_id,
    COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for Unwanted Spaces in Product Name
-- Expectation: No Results
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check Data Standardization - Product Line Values
-- Expectation: Only 'Mountain', 'Road', 'Other Sales', 'Touring', and 'n/a'
SELECT DISTINCT prd_line
FROM silver.crm_prd_info
ORDER BY prd_line;

-- Check for Invalid Date Orders (End Date before Start Date)
-- Expectation: No Results
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- Check for NULL Costs (should have been replaced with 0)
-- Expectation: No Results
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS NULL;


-- ============================================================================
-- CHECKING 'silver.crm_sales_details'
-- ============================================================================

-- Check for Unwanted Spaces in Order Number
-- Expectation: No Results
SELECT sls_ord_num
FROM silver.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num);

-- Check for Invalid Date Orders
-- Expectation: No Results (Order date should not be after ship/due date)
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

-- Check Business Rules: Sales = Quantity * Price
-- Expectation: No Results (Values must not be NULL, zero, or negative)
SELECT DISTINCT sls_sales, sls_quantity, sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
   OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- Check for Invalid Dates (NULL values in required date fields)
-- Expectation: Review results (some NULLs may be acceptable)
SELECT COUNT(*) as null_order_dates
FROM silver.crm_sales_details
WHERE sls_order_dt IS NULL;


-- ============================================================================
-- CHECKING 'silver.erp_cust_az12'
-- ============================================================================

-- Check for NULLs in Primary Key
-- Expectation: No Results
SELECT cid
FROM silver.erp_cust_az12
WHERE cid IS NULL;

-- Check for Future Birthdates (should have been set to NULL)
-- Expectation: No Results
SELECT DISTINCT bdate
FROM silver.erp_cust_az12
WHERE bdate > GETDATE();

-- Check for Out-of-Range Dates (too old)
-- Expectation: No Results (dates before 1924 are suspicious)
SELECT DISTINCT bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01';

-- Check Data Standardization - Gender Values
-- Expectation: Only 'Female', 'Male', and 'n/a' should exist
SELECT DISTINCT gen
FROM silver.erp_cust_az12
ORDER BY gen;


-- ============================================================================
-- CHECKING 'silver.erp_loc_a101'
-- ============================================================================

-- Check for NULLs in Primary Key
-- Expectation: No Results
SELECT cid
FROM silver.erp_loc_a101
WHERE cid IS NULL;

-- Check for Unwanted Spaces in Country
-- Expectation: No Results
SELECT cntry
FROM silver.erp_loc_a101
WHERE cntry != TRIM(cntry);

-- Check Data Standardization - Country Values
-- Expectation: Full country names only (no codes like 'US', 'DE', 'USA')
SELECT DISTINCT cntry
FROM silver.erp_loc_a101
ORDER BY cntry;


-- ============================================================================
-- CHECKING 'silver.erp_px_cat_g1v2'
-- ============================================================================

-- Check for NULLs in Primary Key
-- Expectation: No Results
SELECT id
FROM silver.erp_px_cat_g1v2
WHERE id IS NULL;

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT *
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
   OR subcat != TRIM(subcat) 
   OR maintenance != TRIM(maintenance);

-- Check Data Standardization - Category Values
-- Expectation: Review distinct categories
SELECT DISTINCT cat
FROM silver.erp_px_cat_g1v2
ORDER BY cat;

-- Check Data Standardization - Maintenance Flag Values
-- Expectation: Only 'Yes' and 'No' should exist
SELECT DISTINCT maintenance
FROM silver.erp_px_cat_g1v2
ORDER BY maintenance;


-- ============================================================================
-- CROSS-TABLE CONSISTENCY CHECKS
-- ============================================================================

-- Check Foreign Key Integrity: Sales to Products
-- Expectation: No Results (all product keys in sales should exist in products)
SELECT DISTINCT sls_prd_key
FROM silver.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info);

-- Check Foreign Key Integrity: Sales to Customers
-- Expectation: No Results (all customer IDs in sales should exist in customers)
SELECT DISTINCT sls_cust_id
FROM silver.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info);

-- Check Foreign Key Integrity: Location to Customers
-- Expectation: No Results (all customer IDs in location should exist in customers)
SELECT DISTINCT cid
FROM silver.erp_loc_a101
WHERE cid NOT IN (SELECT cst_key FROM silver.crm_cust_info);


-- ============================================================================
-- SUMMARY STATISTICS
-- ============================================================================

-- Display row counts for all Silver tables
SELECT 'silver.crm_cust_info' as table_name, COUNT(*) as row_count FROM silver.crm_cust_info
UNION ALL
SELECT 'silver.crm_prd_info', COUNT(*) FROM silver.crm_prd_info
UNION ALL
SELECT 'silver.crm_sales_details', COUNT(*) FROM silver.crm_sales_details
UNION ALL
SELECT 'silver.erp_cust_az12', COUNT(*) FROM silver.erp_cust_az12
UNION ALL
SELECT 'silver.erp_loc_a101', COUNT(*) FROM silver.erp_loc_a101
UNION ALL
SELECT 'silver.erp_px_cat_g1v2', COUNT(*) FROM silver.erp_px_cat_g1v2
ORDER BY table_name;

-- ============================================================================
-- END OF QUALITY CHECKS
-- ============================================================================
