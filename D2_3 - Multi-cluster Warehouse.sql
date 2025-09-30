/*----------------D2_3 Hands-on----------------
1) Multi-cluster warehouse behaviour
2) Meaning of the MIN[/MAX]_CLUSTER_COUNT option
3) Meaning of the SCALING_POLICY option 
----------------------------------------------*/

-- Set context
use role sysadmin;

create or replace warehouse multi_cluster_warehouse_standard_xs
warehouse_size = 'XSMALL'
Warehouse_type = 'STANDARD'
Auto_suspend = 600
auto_resume = TRUE
min_cluster_count = 1
max_cluster_count = 2
scaling_policy = 'STANDARD';

show warehouses like 'MULTI%'

-- Set context
USE ROLE ACCOUNTADMIN;

create or replace user user1 password='temp' default_role = SYSADMIN default_warehouse = multi_cluster_warehouse_standard_XS;
grant role sysadmin to user user1;
create or replace user user2 password='temp' default_role = SYSADMIN default_warehouse = multi_cluster_warehouse_standard_XS;
grant role sysadmin to user user2;
create or replace user user3 password='temp' default_role = SYSADMIN default_warehouse = multi_cluster_warehouse_standard_XS;
grant role sysadmin to user user3;


DROP USER USER1;
DROP USER USER2;
DROP USER USER3;

DROP WAREHOUSE MULTI_CLUSTER_WAREHOUSE_STANDARD_XS;
