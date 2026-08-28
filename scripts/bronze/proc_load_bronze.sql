/*
================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
================================================================================

Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;

================================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	-- Declare variables for tracking individual table load times
	DECLARE @start_time DATETIME, @end_time DATETIME
	-- Declare variables for tracking the entire batch duration
	DECLARE @batch_start_time DATETIME, @batch_end_time DATETIME

	BEGIN TRY
		-- Capture the start time for the entire batch
		SET @batch_start_time = GETDATE();

		PRINT '=============================';
		PRINT 'Loading Bronze Layer';
		PRINT '=============================';

		-- ====================================================================
		-- CRM TABLES
		-- ====================================================================
		PRINT '-----------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '-----------------------------';

		-- Load CRM Customer Information
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info'
		TRUNCATE TABLE bronze.crm_cust_info

		PRINT '>> Inserting Data into: bronze.crm_cust_info'
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\DENILSON PIUS\Desktop\Projects\Data Engineering Learning Journey\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------------------';

		-- Load CRM Product Information
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info'
		TRUNCATE TABLE bronze.crm_prd_info

		PRINT '>> Inserting Data into: bronze.crm_prd_info'
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\DENILSON PIUS\Desktop\Projects\Data Engineering Learning Journey\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------------------';

		-- Load CRM Sales Details
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_details'
		TRUNCATE TABLE bronze.crm_sales_details

		PRINT '>> Inserting Data into: bronze.crm_sales_details'
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\DENILSON PIUS\Desktop\Projects\Data Engineering Learning Journey\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------------------';

		-- ====================================================================
		-- ERP TABLES
		-- ====================================================================
		PRINT '-----------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '-----------------------------';

		-- Load ERP Customer Data (AZ12)
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_cust_az12'
		TRUNCATE TABLE bronze.erp_cust_az12

		PRINT '>> Inserting Data into: bronze.erp_cust_az12'
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\DENILSON PIUS\Desktop\Projects\Data Engineering Learning Journey\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------------------';

		-- Load ERP Location Data (A101)
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_loc_a101'
		TRUNCATE TABLE bronze.erp_loc_a101

		PRINT '>> Inserting Data into: bronze.erp_loc_a101'
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\DENILSON PIUS\Desktop\Projects\Data Engineering Learning Journey\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------------------';

		-- Load ERP Product Category Data (PX_CAT_G1V2)
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2'
		TRUNCATE TABLE bronze.erp_px_cat_g1v2
	
		PRINT '>> Inserting Data into: bronze.erp_px_cat_g1v2'
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\DENILSON PIUS\Desktop\Projects\Data Engineering Learning Journey\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------------------';
		
		-- Capture the end time and display total batch duration
		SET @batch_end_time = GETDATE();
		PRINT '================================================================';
		PRINT 'Loading Bronze Layer is Completed';
		PRINT '  - Total Load Duration: ' + CAST(DATEDIFF(second,@batch_start_time,@batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '================================================================';

	END TRY
	BEGIN CATCH
		-- Error handling: capture and display error details
		PRINT '========================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '========================================';
	END CATCH
END
GO

/*
================================================================================
END OF STORED PROCEDURE
================================================================================

Tables Loaded:
    CRM Source:
        - bronze.crm_cust_info      (Customer Information)
        - bronze.crm_prd_info       (Product Information)
        - bronze.crm_sales_details  (Sales Details)
    
    ERP Source:
        - bronze.erp_cust_az12      (Customer Data)
        - bronze.erp_loc_a101       (Location Data)
        - bronze.erp_px_cat_g1v2    (Product Category Data)

Notes:
    - All tables are truncated before loading to ensure clean data.
    - BULK INSERT is used for performance optimization.
    - FIRSTROW = 2 skips the header row in CSV files.
    - TABLOCK is used to improve insert performance.

Next Steps:
    1. Verify row counts in bronze tables match source CSV files.
    2. Proceed to Silver Layer transformations.
================================================================================
*/
