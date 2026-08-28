/*
================================================================================
DDL Script: Create Bronze Tables
================================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables
    if they already exist.
    
    Run this script to re-define the DDL structure of 'bronze' Tables

Author: Denilson Pius
Created: 2026-08-28
Last Modified: 2026-08-28
Version: 1.0
================================================================================
*/

-- ============================================================================
-- CRM SOURCE TABLES
-- ============================================================================

-- Drop and create CRM Customer Information table
IF OBJECT_ID ('bronze.crm_cust_info' , 'U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;

CREATE TABLE bronze.crm_cust_info (
	cst_id				INT,
	cst_key				NVARCHAR(50),
	cst_firstname		NVARCHAR (50),
	cst_lastname		NVARCHAR (50),
	cst_maritalstatus	NVARCHAR (50),
	cst_gndr			NVARCHAR (50),
	cst_create_date		DATE
);
GO

-- Drop and create CRM Product Information table
IF OBJECT_ID ('bronze.crm_prd_info' , 'U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;

CREATE TABLE bronze.crm_prd_info (
	prd_id			INT,
	prd_key			NVARCHAR (50),
	prd_nm			NVARCHAR (50),
	prd_cost		INT,
	prd_line		NVARCHAR (50),
	prd_start_dt	DATETIME,
	prd_end_dt		DATETIME
);
GO

-- Drop and create CRM Sales Details table
IF OBJECT_ID ('bronze.crm_sales_details' , 'U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details;

CREATE TABLE bronze.crm_sales_details (
	sls_ord_num		NVARCHAR (50),
	sls_prd_key		NVARCHAR (50),
	sls_cust_id		INT,
	sls_order_dt	INT,
	sls_ship_dt		INT,
	sls_due_dt		INT,
	sls_sales		INT,
	sls_quantity	INT,
	sls_price		INT
);
GO

-- ============================================================================
-- ERP SOURCE TABLES
-- ============================================================================

-- Drop and create ERP Location table (A101)
IF OBJECT_ID ('bronze.erp_loc_a101' , 'U') IS NOT NULL
	DROP TABLE bronze.erp_loc_a101;

CREATE TABLE bronze.erp_loc_a101 (
	cid		NVARCHAR (50),
	cntry	NVARCHAR (50),
);
GO

-- Drop and create ERP Customer table (AZ12)
IF OBJECT_ID ('bronze.erp_cust_az12' , 'U') IS NOT NULL
	DROP TABLE bronze.erp_cust_az12;

CREATE TABLE bronze.erp_cust_az12 (
	cid		NVARCHAR (50),
	bdate	DATE,
	gen		NVARCHAR (50)
);
GO

-- Drop and create ERP Product Category table (PX_CAT_G1V2)
IF OBJECT_ID ('bronze.erp_px_cat_g1v2' , 'U') IS NOT NULL
	DROP TABLE bronze.erp_px_cat_g1v2;

CREATE TABLE bronze.erp_px_cat_g1v2 (
	id				NVARCHAR (50),
	cat				NVARCHAR (50),
	subcat			NVARCHAR (50),
	maintenance		NVARCHAR (50)
);
GO

/*
================================================================================
END OF SCRIPT
================================================================================
Tables Created:
    - bronze.crm_cust_info (CRM Customer Information)
    - bronze.crm_prd_info (CRM Product Information)
    - bronze.crm_sales_details (CRM Sales Details)
    - bronze.erp_loc_a101 (ERP Location Data)
    - bronze.erp_cust_az12 (ERP Customer Data)
    - bronze.erp_px_cat_g1v2 (ERP Product Category Data)

Next Steps:
    1. Verify table structures match source data
    2. Run bronze.load_bronze procedure to populate tables
    3. Validate row counts against source files
================================================================================
*/
