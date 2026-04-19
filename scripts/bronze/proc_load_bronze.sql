-- -----------------------------------------------------------------------------
-- Project: Modern SQL Data Warehouse & Analytics
-- Script: Load Bronze Layer Stored Procedure
-- -----------------------------------------------------------------------------
-- This stored procedure handles the ingestion of raw data from CSV files 
-- into the landing tables within the 'bronze' schema.
-- Execution:
--     EXEC bronze.sp_load_bronze;
-- -----------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE bronze.sp_load_bronze AS
BEGIN
	DECLARE @ExecStart DATETIME, @ExecEnd DATETIME, @BatchStart DATETIME, @BatchEnd DATETIME; 
	BEGIN TRY
		SET @BatchStart = GETDATE();
		PRINT '***************************************************************';
		PRINT '   [START] Executing Bronze Layer Load Process';
		PRINT '***************************************************************';

		PRINT '---------------------------------------------------------------';
		PRINT '   [PROCESS] Ingesting CRM Source Data';
		PRINT '---------------------------------------------------------------';

		SET @ExecStart = GETDATE();
		PRINT '[INFO] Truncating table: bronze.crm_cust_info...';
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT '[INFO] Populating table: bronze.crm_cust_info...';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\sql\dwh_project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @ExecEnd = GETDATE();
		PRINT '[METRIC] Load duration: ' + CAST(DATEDIFF(second, @ExecStart, @ExecEnd) AS NVARCHAR) + ' seconds';
		PRINT '---';

        SET @ExecStart = GETDATE();
		PRINT '[INFO] Truncating table: bronze.crm_prd_info...';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '[INFO] Populating table: bronze.crm_prd_info...';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\sql\dwh_project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @ExecEnd = GETDATE();
		PRINT '[METRIC] Load duration: ' + CAST(DATEDIFF(second, @ExecStart, @ExecEnd) AS NVARCHAR) + ' seconds';
		PRINT '---';

        SET @ExecStart = GETDATE();
		PRINT '[INFO] Truncating table: bronze.crm_sales_details...';
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT '[INFO] Populating table: bronze.crm_sales_details...';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\sql\dwh_project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @ExecEnd = GETDATE();
		PRINT '[METRIC] Load duration: ' + CAST(DATEDIFF(second, @ExecStart, @ExecEnd) AS NVARCHAR) + ' seconds';
		PRINT '---';

		PRINT '---------------------------------------------------------------';
		PRINT '   [PROCESS] Ingesting ERP Source Data';
		PRINT '---------------------------------------------------------------';
		
		SET @ExecStart = GETDATE();
		PRINT '[INFO] Truncating table: bronze.erp_loc_a101...';
		TRUNCATE TABLE bronze.erp_loc_a101;
		PRINT '[INFO] Populating table: bronze.erp_loc_a101...';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\sql\dwh_project\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @ExecEnd = GETDATE();
		PRINT '[METRIC] Load duration: ' + CAST(DATEDIFF(second, @ExecStart, @ExecEnd) AS NVARCHAR) + ' seconds';
		PRINT '---';

		SET @ExecStart = GETDATE();
		PRINT '[INFO] Truncating table: bronze.erp_cust_az12...';
		TRUNCATE TABLE bronze.erp_cust_az12;
		PRINT '[INFO] Populating table: bronze.erp_cust_az12...';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\sql\dwh_project\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @ExecEnd = GETDATE();
		PRINT '[METRIC] Load duration: ' + CAST(DATEDIFF(second, @ExecStart, @ExecEnd) AS NVARCHAR) + ' seconds';
		PRINT '---';

		SET @ExecStart = GETDATE();
		PRINT '[INFO] Truncating table: bronze.erp_px_cat_g1v2...';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		PRINT '[INFO] Populating table: bronze.erp_px_cat_g1v2...';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\sql\dwh_project\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @ExecEnd = GETDATE();
		PRINT '[METRIC] Load duration: ' + CAST(DATEDIFF(second, @ExecStart, @ExecEnd) AS NVARCHAR) + ' seconds';
		PRINT '---';

		SET @BatchEnd = GETDATE();
		PRINT '***************************************************************';
		PRINT '   [FINISH] Bronze Layer Load Process Completed';
        PRINT '   [TOTAL DURATION] ' + CAST(DATEDIFF(SECOND, @BatchStart, @BatchEnd) AS NVARCHAR) + ' seconds';
		PRINT '***************************************************************';
	END TRY
	BEGIN CATCH
		PRINT '***************************************************************';
		PRINT '   [CRITICAL ERROR] Failed during Bronze Layer load process.';
		PRINT '   Message: ' + ERROR_MESSAGE();
		PRINT '   Code: ' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT '   State: ' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '***************************************************************';
	END CATCH
END
