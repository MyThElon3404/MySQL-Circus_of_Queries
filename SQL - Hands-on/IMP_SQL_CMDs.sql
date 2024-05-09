-- to see all the datebases from ssms
SELECT name
FROM sys.databases;

-- to see all the tables from database
USE week_3_sql; -- currently using database
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';
-- ==============================================================================================================================
-- INFORMATION_SCHEMA is a schema in SQL Server (and other database management systems) that contains a set of views that provide information about the database system. These views can be queried to retrieve metadata about the database objects, such as tables, columns, indexes, constraints, and more.

-- Some common views in the INFORMATION_SCHEMA schema include:

-- TABLES: Contains information about tables in the current database.
-- COLUMNS: Contains information about columns in the tables of the current database.
-- VIEWS: Contains information about views in the current database.
-- ROUTINES: Contains information about stored procedures and functions in the current database.
-- KEY_COLUMN_USAGE: Contains information about columns that are used as keys by constraints or indexes.
-- ==============================================================================================================================
