-- Indexing in MySQL is a technique used to speed up the retrieval of rows from a table. It is a data structure that improves the 
-- speed of data retrieval operations on a database table at the cost of additional writes and storage space to maintain the index data structure.

-- Key Points:
-- 1. Speed: Indexes make it quicker to find rows matching a certain condition.
-- 2. Storage: Indexes require additional storage space.
-- 3. Maintenance: Indexes slow down insert, update, and delete operations because the index needs to be updated as well.

-- EXAMPLE :

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    category VARCHAR(255),
    price DECIMAL(10, 2)
);
INSERT INTO products (name, category, price) VALUES
('Laptop', 'Electronics', 1000.00),
('Smartphone', 'Electronics', 500.00),
('Shoes', 'Fashion', 80.00),
('Shirt', 'Fashion', 25.00);

-- Query Without Index:
SELECT * FROM products WHERE category = 'Electronics';

-- Adding an Index:
CREATE INDEX idx_category ON products(category);

-- Query With Index:
SELECT * FROM products WHERE category = 'Electronics';


-- Types of Indexes in MySQL:

-- 1. Primary Key Index - Ensures each row in a table is uniquely identifiable.
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    age INT
);

-- 2. Unique Index
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_code VARCHAR(10) UNIQUE,
    emp_name VARCHAR(100) NOT NULL,
    emp_dept VARCHAR(50)
);

-- 3. Index - Improves the speed of data retrieval operations.
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    category VARCHAR(50),
    price DECIMAL(10, 2),
    INDEX idx_category (category)
);

-- 4. Composite Index - Index on multiple columns, used when queries frequently reference multiple columns together.
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    INDEX idx_customer_date (customer_id, order_date)
);

-- =======================================================================================================================================

-- In the context of database indexing, the terms "clustered index" and "non-clustered index" refer to different ways data is physically 
-- stored and accessed in relation to the index. These concepts are particularly relevant in database systems like MySQL and SQL Server.

-- Clustered Index: A clustered index determines the physical order of data rows in a table. 
-- In other words, the rows of the table are stored on disk in the order of the clustered index key values.
CREATE TABLE employees (
    emp_id INT PRIMARY KEY CLUSTERED,
    emp_name VARCHAR(100),
    emp_dept VARCHAR(50)
);

-- Non-Clustered Index: A non-clustered index is a separate structure from the data rows and does not dictate the physical order of data 
-- on disk. Instead, it contains pointers to the corresponding rows in the table.
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    category VARCHAR(50),
    price DECIMAL(10, 2),
    INDEX idx_category (category)
);

-- Comparison and Recommendations:

-- Clustered Index: 
-- 1. Typically faster for retrieving rows because it directly points to the actual data. 
-- 2. Best suited for columns that are frequently used for range queries or sorting.
  
-- Non-Clustered Index: 
-- 1. Slower for retrieving rows compared to clustered indexes because it requires an additional lookup step.
-- 2. Useful for columns frequently used in search conditions (WHERE clause) that are not suitable for a clustered index.

-- When to Use Each:

-- Clustered Index: Use when you want to physically order the rows of a table based on a specific key. Primary keys are often suitable 
-- candidates for clustered indexes.
-- Non-Clustered Index: Use when you need to improve the performance of queries that search for values in columns that are not part of the 
-- clustered index or are frequently queried.


