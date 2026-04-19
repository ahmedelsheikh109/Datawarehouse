-- -----------------------------------------------------------------------------
-- Project: Modern SQL Data Warehouse & Analytics
-- Script Purpose: Initialize Database and Schemas
-- -----------------------------------------------------------------------------
-- This script sets up the primary 'DataWarehouse' database. 
-- It removes the existing database (if present) and creates the standard 
-- Medallion architecture schemas: 'bronze', 'silver', and 'gold'.
-- -----------------------------------------------------------------------------

USE master;
GO

-- Drop DataWarehouse if it currently exists
IF DB_ID('DataWarehouse') IS NOT NULL
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- Provision new DataWarehouse database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Provision Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
