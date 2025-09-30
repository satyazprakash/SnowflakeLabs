/*----------------D2_1 Hands-on----------------
1) Virtual warehouse creation
2) Virtual warehouse sizes
3) Virtual warehouse state properties
4) Virtual warehouse behaviour
----------------------------------------------*/

-- Set context
USE ROLE SYSADMIN;

-- Create data loading analysis warehouse
create warehouse data_analysis_warehouse
warehouse_size = 'SMALL'
auto_suspend = 600
auto_resume = TRUE
initially_suspended = TRUE;

-- Set context
use warehouse data_analysis_warehouse;
use schema snowflake_sample_data.TPCH_SF1000;

-- Manually resume virtual warehouse
alter warehouse data_analysis_warehouse resume;

-- Show state of virtual warehouse
show warehouses like 'DATA_ANALYSIS_WAREHOUSE';

-- Manually suspend virtual warehouse
alter warehouse data_analysis_warehouse suspend;

show warehouses like 'DATA_ANALYSIS_WAREHOUSE';

SELECT 
C_CUSTKEY, 
C_NAME, 
C_ADDRESS, 
C_NATIONKEY, 
C_PHONE FROM CUSTOMER LIMIT 100;

SHOW WAREHOUSES LIKE 'DATA_ANALYSIS_WAREHOUSE';

-- Set configurations on-the-fly
ALTER WAREHOUSE DATA_ANALYSIS_WAREHOUSE SET WAREHOUSE_SIZE=LARGE;
alter warehouse data_analysis_warehouse set warehouse_size = LARGE;

alter warehouse data_analysis_warehouse set auto_suspend = 300;

alter warehouse data_analysis_warehouse set auto_resume=FALSE;

SHOW WAREHOUSES LIKE 'DATA_ANALYSIS_WAREHOUSE';
SELECT "name", "state", "size", "auto_suspend", "auto_resume" FROM TABLE(result_scan(last_query_id()));

-- Clear-down resources
DROP WAREHOUSE DATA_ANALYSIS_WAREHOUSE;