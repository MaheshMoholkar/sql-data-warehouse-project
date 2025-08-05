/*
    This script is used to create the bronze layer tables in the datawarehouse database.
    It is used to import the data from the source_crm and source_erp datasets into the bronze layer tables.
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME = GETDATE();
    BEGIN TRY
        PRINT 'Importing CRM Customer Info';
        -- Import CRM Customer Info
        TRUNCATE TABLE bronze.crm_cust_info;
        
        BULK INSERT bronze.crm_cust_info
        FROM
            '/var/opt/mssql/datasets/source_crm/cust_info.csv'
        WITH
            (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
        
        PRINT 'Importing CRM Product Info';
        -- Import CRM Product Info
        TRUNCATE TABLE bronze.crm_prd_info;
        
        BULK INSERT bronze.crm_prd_info
        FROM
            '/var/opt/mssql/datasets/source_crm/prd_info.csv'
        WITH
            (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
        
        PRINT 'Importing CRM Sales Details';
        -- Import CRM Sales Details
        TRUNCATE TABLE bronze.crm_sales_details;
        
        BULK INSERT bronze.crm_sales_details
        FROM
            '/var/opt/mssql/datasets/source_crm/sales_details.csv'
        WITH
            (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
        
        PRINT 'Importing ERP Customer Data';
        -- Import ERP Customer Data
        TRUNCATE TABLE bronze.erp_cust_az12;
        
        BULK INSERT bronze.erp_cust_az12
        FROM
            '/var/opt/mssql/datasets/source_erp/CUST_AZ12.csv'
        WITH
            (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
        
        PRINT 'Importing ERP Location Data';
        -- Import ERP Location Data
        TRUNCATE TABLE bronze.erp_loc_a101;
        
        BULK INSERT bronze.erp_loc_a101
        FROM
            '/var/opt/mssql/datasets/source_erp/LOC_A101.csv'
        WITH
            (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
        
        PRINT 'Importing ERP Product Category Data';
        -- Import ERP Product Category Data
        TRUNCATE TABLE bronze.erp_px_cat_g1_g1v3;
        
        BULK INSERT bronze.erp_px_cat_g1_g1v3
        FROM
            '/var/opt/mssql/datasets/source_erp/PX_CAT_G1V2.csv'
        WITH
            (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
    END TRY
    BEGIN CATCH
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH

    PRINT 'Time taken: ' + CAST(DATEDIFF(SECOND, @start_time, GETDATE()) AS VARCHAR(10)) + ' seconds';
END