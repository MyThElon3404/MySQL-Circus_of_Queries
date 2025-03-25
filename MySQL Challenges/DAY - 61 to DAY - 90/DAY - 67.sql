-- QUESTION : 1
-- 1. A Microsoft Azure Supercloud customer is defined as a customer 
-- who has purchased at least one product from every product category listed in the products table.
-- Write a query that identifies the customer IDs of these Supercloud customers.

CREATE TABLE customer_contracts (
    customer_id INT,
    product_id INT,
    amount INT,
    PRIMARY KEY (customer_id, product_id)
);

INSERT INTO customer_contracts (customer_id, product_id, amount) 
  VALUES
(1, 1, 1000),
(1, 3, 2000),
(1, 5, 1500),
(2, 2, 3000),
(2, 6, 2000);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_category VARCHAR(50),
    product_name VARCHAR(100)
);

INSERT INTO products (product_id, product_category, product_name) VALUES
(1, 'Analytics', 'Azure Databricks'),
(2, 'Analytics', 'Azure Stream Analytics'),
(4, 'Containers', 'Azure Kubernetes Service'),
(5, 'Containers', 'Azure Service Fabric'),
(6, 'Compute', 'Virtual Machines'),
(7, 'Compute', 'Azure Functions');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- Solution 1 - Using GROUP BY and HAVING
SELECT cc.customer_id
FROM customer_contracts cc
JOIN products p ON cc.product_id = p.product_id
GROUP BY cc.customer_id
HAVING COUNT(DISTINCT p.product_category) = 
  (SELECT COUNT(DISTINCT product_category) FROM products);

-- Solution 2 - Using JOIN and NOT EXISTS
SELECT DISTINCT cc.customer_id
FROM customer_contracts cc
WHERE NOT EXISTS (
    SELECT p.product_category
    FROM products p
    WHERE NOT EXISTS (
        SELECT 1
        FROM customer_contracts cc2
        WHERE cc2.customer_id = cc.customer_id
        AND cc2.product_id = p.product_id
    )
);

-- Solution 3 - Using COUNT with PARTITION BY
WITH CustomerCategoryCount AS (
    SELECT cc.customer_id, COUNT(DISTINCT p.product_category) AS category_count
    FROM customer_contracts cc
    JOIN products p ON cc.product_id = p.product_id
    GROUP BY cc.customer_id
)
SELECT customer_id
FROM CustomerCategoryCount
WHERE category_count = (SELECT COUNT(DISTINCT product_category) FROM products);

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. write a sql query to populate category to the last not null value in category

CREATE TABLE brands (
    category VARCHAR(20),
    brand_name VARCHAR(20)
);

INSERT INTO brands (category, brand_name) 
    VALUES
('chocolates', '5-star'),
(NULL, 'dairy milk'),
(NULL, 'perk'),
(NULL, 'eclair'),
('Biscuits', 'britannia'),
(NULL, 'good day'),
(NULL, 'boost');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- Solution 1 - 


-- ==================================================================================================================================

-- QUESTION : 3
-- 3. 



-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================
