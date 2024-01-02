drop schema if exists zomato_sch;

create schema if not exists zomato_sch;
use zomato_sch;
-- ===============================================================================================================================
# for data rather than creating a table we just import dataset and create table
-- ===============================================================================================================================
select * from zomato_tb;

# The information schema (INFORMATION_SCHEMA) is an ANSI/ISO-standard schema in relational database management systems 
# (RDBMS s) that provides a comprehensive view of the metadata associated with each database. It acts as a catalog that 
# houses metadata about tables, views, stored procedures, columns, constraints, and other database objects.

SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'zomato_tb';

SELECT DISTINCT(TABLE_CATALOG),TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS;								-- CHECK TABLES IN ALL THE DATABSE
SELECT * FROM INFORMATION_SCHEMA.COLUMNS;
-- ===============================================================================================================================

# Query - checking for dublicates
	--	if count is greater than or equal to 2 then dublicate present
    
select RestaurantID, count(RestaurantID)
from zomato_tb
group by RestaurantID
order by 2 desc;

/*Version 2*/
select RestaurantID, count(RestaurantID), if(count(RestaurantID) >=2, "Yes", "NO") as dublicate
from zomato_tb
group by RestaurantID
order by 1 asc;
-- =======================================================================================================================
# Query - ROLLING/MOVING COUNT OF RESTAURANTS IN INDIAN CITIES

select 
-- =======================================================================================================================

-- =======================================================================================================================

-- =======================================================================================================================

-- =======================================================================================================================

-- =======================================================================================================================

-- =======================================================================================================================

-- =======================================================================================================================

-- =======================================================================================================================

-- =======================================================================================================================







