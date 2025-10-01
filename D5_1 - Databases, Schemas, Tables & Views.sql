/*----------------D5_1 Hands-on----------------
1) Introduce Databases & schemas
2) Understand table and view types
----------------------------------------------*/

-- Set context 
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE SNOWFLAKE_SAMPLE_DATA;
USE SCHEMA TPCH_SF1;

--"SNOWFLAKE_SAMPLE_DATA"."WEATHER"."DAILY_14_TOTAL"

-- Describe table schema
desc table customer;
describe table customer;

-- Provide details on all tables in current context
show tables;

-- Filter output of SHOW TABLES using LIKE string matching
show tables like 'customer';

SELECT "name", "database_name", "schema_name", "kind", "is_external", "retention_time" FROM TABLE(result_scan(last_query_id()));

-- Create demo database & schema 
CREATE DATABASE DEMO_DB;
CREATE SCHEMA DEMO_SCHEMA;

USE DATABASE DEMO_DB;
USE SCHEMA DEMO_SCHEMA;

-- Create three table types
create or replace table  permanent_table
(
  NAME STRING,
  AGE INT
  );

create or replace temporary table temporary_table
(
  NAME STRING,
  AGE INT
  );

create or replace transient table transient_table
(
  NAME STRING,
  AGE INT
  );

show tables;

SELECT "name", "database_name", "schema_name", "kind", "is_external" FROM TABLE(result_scan(last_query_id()));

-- Successful 
alter table permanent_table set data_retention_time_in_days = 90;

-- Invalid value [90]
alter table transient_table set data_tetentiion_time_in_days= 2;

-- Create external table 
create external table ext_table
(
  col1 varchar as (value:col1::varchar),
  col2 varchar as (value:col2::int),
  col3 varchar as (value:col3::varchar)

)
location = @s1/logs/
file_format = (type = parquet);

-- Refresh external table metadata so it reflects latest changes in external cloud storage
alter external table ext_table refresh;

-- Create three views - one of each type

create or replace view standard_view as 
select * from permanent_table;

create or replace secure view secure_view as 
select * from permanent_table;

create or replace materialized view materialized_view as 
select * from permanent_table;

show views;

SELECT "name", "database_name", "schema_name", "is_secure", "is_materialized" FROM TABLE(result_scan(last_query_id()));

-- Secure view functionality

GRANT USAGE ON DATABASE DEMO_DB TO ROLE SYSADMIN;
GRANT USAGE ON SCHEMA DEMO_SCHEMA TO ROLE SYSADMIN;
GRANT SELECT, REFERENCES ON TABLE STANDARD_VIEW TO ROLE SYSADMIN;
GRANT SELECT, REFERENCES ON TABLE SECURE_VIEW TO ROLE SYSADMIN;

-- DDL returned from secure view as role that owns secure view
select get_ddl('view','secure_view');

-- Set context
USE ROLE SYSADMIN;

-- Will not work with SYSADMIN role as only ownership role can view DDL
select get_ddl('view','secure_view');

-- Will work with SYSADMIN role as view not desginated as SECURE  
SELECT get_ddl('view', 'STANDARD_VIEW');

-- Set context
USE ROLE ACCOUNTADMIN;

-- Clear down database
DROP DATABASE DEMO_DB;