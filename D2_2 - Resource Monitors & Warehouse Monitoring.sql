/*----------------D2_2 Hands-on----------------
1) Virtual Warehouse usage and credit monitoring through UI and SQL 
2) Resource Monitors
----------------------------------------------*/

-- Set context
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE SNOWFLAKE;
USE SCHEMA ACCOUNT_USAGE;

SELECT * FROM WAREHOUSE_METERING_HISTORY
WHERE WAREHOUSE_NAME = 'DATA_ANALYSIS_WAREHOUSE';

-- Total credits used grouped by warehouse
SELECT WAREHOUSE_NAME,
       SUM(CREDITS_USED) AS TOTAL_CREDITS_USED
FROM WAREHOUSE_METERING_HISTORY
WHERE START_TIME >= DATE_TRUNC(MONTH, CURRENT_DATE)
GROUP BY 1
ORDER BY 2 DESC;

-- Warehouse metering history using the Information Schema
SELECT *
FROM TABLE(INFORMATION_SCHEMA.WAREHOUSE_METERING_HISTORY(dateadd('days',-7,current_date())));


-- Copy into Classic Console

-- Set context
USE DATABASE SNOWFLAKE_SAMPLE_DATA;
USE SCHEMA TPCH_SF1000;

-- Create resource monitor
create resource monitor data_analysis_warehouse_resource_monitor with credit_quota = 1
triggers
on 50 percent do notify
on 90 percent do suspend
on 100 percent do suspend_immediate;

 
-- Resource Monitor object can be applied at account level 
-- ALTER ACCOUNT SET RESOURCE_MONITOR = "ACCOUNT_RESOURCE_MONITOR";

-- Apply resource monitor at virtual warehouse level 
ALTER WAREHOUSE "COMPUTE_WH" SET RESOURCE_MONITOR = "DATA_ANALYSIS_WAREHOUSE_RESOURCE_MONITOR";

alter warehouse compute_wh set warehouse_size = XXXLARGE;

SELECT * FROM LINEITEM limit 10;

-- Resize warehouse to xsmall
alter warehouse compute_wh set warehouse_size = XSMALL;

drop resource monitor data_analysis_warehouse_resource_monitor;
