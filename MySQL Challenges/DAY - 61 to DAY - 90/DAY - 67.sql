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
-- 2. Stripe asked this tricky SQL interview question, 
-- about identifying any payments made at the same merchant with the same credit card for the same amount 
-- within 10 minutes of each other and reporting the count of such repeated payments.

drop table if exists transaction_tb;
CREATE TABLE transaction_tb (
    transaction_id INT PRIMARY KEY,
    merchant_id INT,
    credit_card_id INT,
    amount DECIMAL(10,2),
    transaction_timestamp DATETIME
);

INSERT INTO transaction_tb
	VALUES
(1, 101, 1, 100, '2022-09-25 12:00:00'),
(2, 101, 1, 100, '2022-09-25 12:08:00'),
(3, 101, 1, 100, '2022-09-25 12:28:00'),
(4, 102, 2, 300, '2022-09-25 12:00:00'),
(6, 102, 2, 400, '2022-09-25 14:00:00');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- Solution 1 - Using SELF JOIN
SELECT t1.merchant_id, t1.credit_card_id, 
    t1.amount,
    COUNT(distinct t1.merchant_id) AS repeated_payments
FROM transaction_tb t1
JOIN transaction_tb t2 
    ON t1.merchant_id = t2.merchant_id 
    AND t1.credit_card_id = t2.credit_card_id 
    AND t1.amount = t2.amount 
    AND t1.transaction_id <> t2.transaction_id 
    AND ABS(datediff(MINUTE, t1.transaction_timestamp, t2.transaction_timestamp)) <= 10
GROUP BY t1.merchant_id, t1.credit_card_id, t1.amount;

-- Solution 2 - Using WINDOW FUNCTION (LAG)
with transaction_cte as (
	select *,
		LAG(transaction_timestamp) over(
			partition by merchant_id, credit_card_id, amount
			order by transaction_timestamp) as prev_transaction_timestamp
	from transaction_tb
)
select merchant_id, credit_card_id, amount,
	count(*) as repeated_payments
from transaction_cte
where ABS(DATEDIFF(MINUTE, transaction_timestamp, prev_transaction_timestamp)) <= 10
group by merchant_id, credit_card_id, amount;

-- ==================================================================================================================================

-- QUESTION : 3
-- 3. Monthly Merchant Balance [Visa SQL Interview Question]
-- Say you have access to all the transactions for a given merchant account. 
-- Write a query to print the cumulative balance of the merchant account at the end of each day, 
-- with the total balance reset back to zero at the end of the month. Output the transaction date and cumulative balance.

drop table if exists trans_tb;
CREATE TABLE trans_tb (
    transaction_id INT PRIMARY KEY,
    type VARCHAR(20) CHECK (type IN ('deposit', 'withdrawal')),
    amount DECIMAL(10,2),
    transaction_date DATETIME
);

INSERT INTO trans_tb
	VALUES
(19153, 'deposit', 65.90, '2022-07-10 10:00:00'),
(53151, 'deposit', 178.55, '2022-07-08 10:00:00'),
(29776, 'withdrawal', 25.90, '2022-07-08 10:00:00'),
(16461, 'withdrawal', 45.99, '2022-07-08 10:00:00'),
(77134, 'deposit', 32.60, '2022-07-10 10:00:00');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- Solution 1 - Using CTE and window function
with balance_cte as (
	select CONVERT(date, transaction_date) as transaction_day,
		MONTH(transaction_date) as transaction_month,
		sum(case when type = 'deposit' then amount else -amount end) as balance_change
	from trans_tb
	group by CONVERT(date, transaction_date), MONTH(transaction_date)
)
select transaction_day,
	sum(balance_change) over(partition by transaction_month order by transaction_day) as cumulative_balance
from balance_cte
order by transaction_day;

-- Solution 2 - Using a SELF JOIN
SELECT t1.transaction_date, 
       SUM(CASE WHEN t2.type = 'deposit' THEN t2.amount ELSE -t2.amount END) AS cumulative_balance
FROM transactions t1
JOIN transactions t2 
    ON YEAR(t1.transaction_date) = YEAR(t2.transaction_date)
    AND MONTH(t1.transaction_date) = MONTH(t2.transaction_date)
    AND t2.transaction_date <= t1.transaction_date
GROUP BY t1.transaction_date
ORDER BY t1.transaction_date;

-- Solution 3 - Using SUM() with PARTITION BY
SELECT 
    transaction_date, 
    SUM(CASE WHEN type = 'deposit' THEN amount ELSE -amount END) 
        OVER (PARTITION BY YEAR(transaction_date), MONTH(transaction_date) 
              ORDER BY transaction_date) AS cumulative_balance
FROM transactions;

-- ==================================================================================================================================
