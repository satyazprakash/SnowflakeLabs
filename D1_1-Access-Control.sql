/*----------------D1_1 Hands-on----------------
1) Role-based access control (RBAC)
2) Discretionary access control (DAC)
3) Roles & Privileges
4) Privilege Inheritance
----------------------------------------------*/
 
-- Set context 
USE ROLE ACCOUNTADMIN;

show roles;

SELECT "name", "comment" FROM TABLE(result_scan(last_query_id()));

show grants to role securityadmin;

-- Create Database and Schema
USE ROLE SYSADMIN;

use role sysadmin;

create database films_db;
create schema films_schema;

create table films_sysadmin
(
id string,
title string,
release_date date,
rating int
);

-- Create custom role inherited by SYSADMIN system-defined role
use role securityadmin;

create role analyst;

grant usage on database films_db to role analyst;

grant usage, create table 
on schema films_db.films_schema
to role analyst;

grant usage on warehouse compute_wh to role analyst;
  
GRANT ROLE ANALYST TO ROLE SYSADMIN;

GRANT ROLE ANALYST TO USER ADMIN;

-- Verify privileges 
show grants to role sysadmin;

SHOW GRANTS OF ROLE ANALYST;

SHOW GRANTS TO ROLE ANALYST;

-- Set context
USE ROLE ANALYST;
USE SCHEMA FILMS_DB.FILMS_SCHEMA;

CREATE TABLE FILMS_ANALYST
(
  ID STRING, 
  TITLE STRING,  
  RELEASE_DATE DATE,
  RATING INT
);

SHOW TABLES;

SHOW DATABASES;
SELECT "name", "owner" FROM TABLE(result_scan(last_query_id()));

-- GRANT OWNERSHIP ON DATABASE FILMS_DB TO ROLE ANALYST;

USE ROLE SYSADMIN;
SHOW TABLES;


-- Future grants
USE ROLE SECURITYADMIN;

grant usage on future schemas in database films_db to role analyst;

USE ROLE SYSADMIN;

create schema music_schema;

create schema books_schema;

SHOW SCHEMAS;

use role analyst;

show schemas;

show grants to role analyst;

--Create user
USE ROLE USERADMIN;

create user rajesh password = 'temp' default_role = analyst default_warehouse = 'COMPUTE_WH' must_change_password=FALSE;

use role securityadmin;

grant role analyst to user rajesh;

use schema films_db.films_schema;


SHOW TABLES;

-- Clear-down resources
use role sysadmin;

drop database films_db;

database films_db;



