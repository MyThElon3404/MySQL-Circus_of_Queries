-- QUESTION : 1
-- 1. Find the average daily active users for January 2021 for each account. 
-- Your output should have account_id and the average daily count for that account.

drop table if exists sf_events;
CREATE TABLE sf_events (
    record_date DATE,
    account_id VARCHAR(10),
    user_id VARCHAR(10)
);

INSERT INTO sf_events (record_date, account_id, user_id) VALUES
('2021-01-01', 'A1', 'U1'),
('2021-01-01', 'A1', 'U2'),
('2021-01-06', 'A1', 'U3'),
('2021-01-02', 'A1', 'U1'),
('2020-12-24', 'A1', 'U2'),
('2020-12-08', 'A1', 'U1'),
('2020-12-09', 'A1', 'U1'),
('2021-01-10', 'A2', 'U4'),
('2021-01-11', 'A2', 'U4'),
('2021-01-12', 'A2', 'U4'),
('2021-01-15', 'A2', 'U5'),
('2020-12-17', 'A2', 'U4'),
('2020-12-25', 'A3', 'U6'),
('2020-12-25', 'A3', 'U6'),
('2020-12-25', 'A3', 'U6'),
('2020-12-06', 'A3', 'U7'),
('2020-12-06', 'A3', 'U6'),
('2021-01-14', 'A3', 'U6'),
('2021-02-07', 'A1', 'U1'),
('2021-02-10', 'A1', 'U2'),
('2021-02-01', 'A2', 'U4'),
('2021-02-01', 'A2', 'U5'),
('2020-12-05', 'A1', 'U8'),
('2021-01-07', 'A1', 'U3'),
('2021-01-08', 'A1', 'U2'),
('2021-01-09', 'A1', 'U1'),
('2021-01-13', 'A2', 'U5'),
('2021-01-18', 'A3', 'U7'),
('2021-01-19', 'A3', 'U6'),
('2021-01-20', 'A3', 'U7'),
('2021-01-21', 'A3', 'U6'),
('2021-01-22', 'A3', 'U6');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- solution 1 - Using COUNT(DISTINCT user_id) and COUNT(DISTINCT record_date)
select account_id,
	-- count(distinct user_id) as total_user,
	-- count(distinct record_date) as total_rd,
	count(distinct user_id)*1.0 / count(distinct record_date) as avg_daily_active_users
from sf_events
where record_date between '2021-01-01' and '2021-01-31'
group by account_id;

-- Solution 2 - Using AVG(COUNT(DISTINCT user_id)) OVER (PARTITION BY account_id)
SELECT 
    account_id, 
    AVG(user_count) AS avg_daily_active_users
FROM (
    SELECT 
        account_id, 
        record_date, 
        COUNT(DISTINCT user_id) AS user_count
    FROM sf_events
    WHERE record_date BETWEEN '2021-01-01' AND '2021-01-31'
    GROUP BY account_id, record_date
) daily_counts
GROUP BY account_id;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Same-Day Orders
-- Identify users who started a session and placed an order on the same day. 
-- For these users, the total number of orders placed on that day and the total order value for that day.
-- Your output should include the user id, the session date, the total number of orders, and the total order value for that day.

-- sessions table
CREATE TABLE sessions (
    session_id INT,
    user_id INT,
    session_date DATE
);

INSERT INTO sessions (session_id, user_id, session_date) VALUES
(1, 1, '2024-01-01'),
(2, 2, '2024-01-02'),
(3, 3, '2024-01-05'),
(4, 3, '2024-01-05'),
(5, 4, '2024-01-03'),
(6, 4, '2024-01-03'),
(7, 5, '2024-01-04'),
(8, 5, '2024-01-04'),
(9, 3, '2024-01-05'),
(10, 5, '2024-01-04');

-- order_summary table
CREATE TABLE order_summary (
    order_id INT,
    user_id INT,
    order_value INT,
    order_date DATE
);

INSERT INTO order_summary (order_id, user_id, order_value, order_date) VALUES
(1, 1, 152, '2024-01-01'),
(2, 2, 485, '2024-01-02'),
(3, 3, 398, '2024-01-05'),
(4, 3, 320, '2024-01-05'),
(5, 4, 156, '2024-01-03'),
(6, 4, 121, '2024-01-03'),
(7, 5, 238, '2024-01-04'),
(8, 5, 70, '2024-01-04'),
(9, 3, 152, '2024-01-05'),
(10, 5, 171, '2024-01-04');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1 - Using INNER JOIN with GROUP BY
SELECT 
    os.user_id,
    os.order_date AS session_date,
    COUNT(DISTINCT os.order_id) AS total_no_orders,
    SUM(os.order_value) AS total_order_value
FROM sessions_tb st
INNER JOIN order_summary os
    ON st.user_id = os.user_id
    AND st.session_date = os.order_date
GROUP BY os.user_id, os.order_date
ORDER BY os.user_id, os.order_date;

-- SOLUTION 2 - Using CTE with DISTINCT Dates → Then Aggregation
WITH same_day_users AS (
    SELECT DISTINCT s.user_id, s.session_date
    FROM sessions_tb s
    JOIN order_summary o
        ON s.user_id = o.user_id AND s.session_date = o.order_date
)
SELECT 
    s.user_id,
    s.session_date,
    COUNT(o.order_id) AS total_orders,
    SUM(o.order_value) AS total_order_value
FROM same_day_users s
JOIN order_summary o 
    ON s.user_id = o.user_id AND s.session_date = o.order_date
GROUP BY s.user_id, s.session_date
ORDER BY s.user_id, s.session_date;

-- ==================================================================================================================================

-- QUESTION : 3
-- 3. 



-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================
