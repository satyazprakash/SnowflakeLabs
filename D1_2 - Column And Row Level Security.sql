/*----------------D1_2 Hands-on----------------
1) Managing masking policies
2) Managing row access policies
3) Centralized policy management
----------------------------------------------*/

-- Create database, schema and table for test data
USE ROLE SYSADMIN;

CREATE DATABASE SALES_DB;
CREATE SCHEMA SALES_SCHEMA;

CREATE TABLE CUSTOMERS (
ID NUMBER, 
NAME STRING,
EMAIL STRING,
COUNTRY_CODE STRING
);

INSERT INTO CUSTOMERS VALUES 
(138763, 'Kajal Yash','k-yash@gmail.com' ,'IN'), 
(896731, 'Iza Jacenty','jacentyi@stanford.edu','PL'),
(799521, 'Finn Conley','conley76@outlook.co.uk','IE');

-- Create reader role
USE ROLE ACCOUNTADMIN; 

GRANT USAGE ON DATABASE SALES_DB TO ROLE ANALYST; 
GRANT USAGE ON SCHEMA SALES_DB.SALES_SCHEMA TO ROLE ANALYST;
GRANT SELECT ON TABLE SALES_DB.SALES_SCHEMA.CUSTOMERS TO ROLE ANALYST; 

-- Create a masking admin role
CREATE ROLE MASKING_ADMIN;

GRANT USAGE ON DATABASE SALES_DB TO ROLE MASKING_ADMIN; 
GRANT USAGE ON SCHEMA SALES_DB.SALES_SCHEMA TO ROLE MASKING_ADMIN;
grant create masking policy, create row access policy on schema sales_db.sales_schema to role masking_admin;
grant apply masking policy, apply row access policy on account to role masking_admin;
grant role masking_admin to user admin:

-- Create masking policy
USE ROLE MASKING_ADMIN;
USE SCHEMA SALES_DB.SALES_SCHEMA;

create or replace masking policy email_mask as (val string) returns string ->
    case
        when current_role() in ('ANALYST') then VAL
        else regexp_replace(VAL,'.+\@','******@')
    end;
        
alter table customers modify column email set masking policy email_mask;

-- Verify policy
USE ROLE ANALYST;

SELECT * FROM CUSTOMERS limit 100;

USE ROLE SYSADMIN;

SELECT * FROM CUSTOMERS;


-- Create 'simple' row access policy

USE ROLE MASKING_ADMIN;
USE SCHEMA SALES_DB.SALES_SCHEMA;

-- Input column irrelevant in simple row access policy, just a binding point
create or replace row access policy RAP as (VAL VARCHAR) returns BOOLEAN ->
    case 
        when 'ANALYST' = CURRENT_ROLE() then TRUE
        else FALSE
    end;

alter table customers add row access policy RAP on (EMAIL);

-- ALTER TABLE CUSTOMERS MODIFY COLUMN EMAIL UNSET MASKING POLICY;

alter table customers add row access policy RAP on (NAME);

-- Verify policy 
USE ROLE ANALYST;

SELECT * FROM CUSTOMERS;

USE ROLE SYSADMIN;

SELECT * FROM CUSTOMERS;

-- Create mapping table 
CREATE TABLE TITLE_COUNTRY_MAPPING  (
  TITLE STRING,
  COUNTRY_ISO_CODE string
);

INSERT INTO TITLE_COUNTRY_MAPPING VALUES ('ANALYST','PL');

GRANT SELECT ON TABLE TITLE_COUNTRY_MAPPING TO ROLE MASKING_ADMIN;

USE ROLE MASKING_ADMIN;

CREATE OR REPLACE ROW ACCESS POLICY CUSTOMER_POLICY AS (COUNTRY_CODE VARCHAR) RETURNS BOOLEAN ->
  'SYSADMIN' = CURRENT_ROLE()
      OR EXISTS (
            SELECT 1 FROM TITLE_COUNTRY_MAPPING
              WHERE TITLE = CURRENT_ROLE()
                AND COUNTRY_ISO_CODE = COUNTRY_CODE
          );


ALTER TABLE CUSTOMERS ADD ROW ACCESS POLICY CUSTOMER_POLICY ON (COUNTRY_CODE);

ALTER TABLE CUSTOMERS DROP ALL ROW ACCESS POLICIES;

ALTER TABLE CUSTOMERS ADD ROW ACCESS POLICY CUSTOMER_POLICY ON (COUNTRY_CODE);

-- Verify policy
USE ROLE SYSADMIN;

SELECT * FROM CUSTOMERS; 

USE ROLE ANALYST;

SELECT * FROM CUSTOMERS; 

-- Clear-down resources
USE ROLE SYSADMIN;
DROP DATABASE SALES_DB;