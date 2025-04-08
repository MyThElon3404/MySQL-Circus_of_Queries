-- QUESTION : 1
-- 1. Find the average daily active users for January 2021 for each account. 
-- Your output should have account_id and the average daily count for that account.

DROP TABLE IF EXISTS sf_events;
CREATE TABLE sf_events (
    record_date DATE,
    account_id VARCHAR(10),
    user_id VARCHAR(10)
);

INSERT INTO sf_events (record_date, account_id, user_id) VALUES
('2021-01-01', 'A1', 'U1'), ('2021-01-01', 'A1', 'U2'),
('2021-01-06', 'A1', 'U3'), ('2021-01-02', 'A1', 'U1'),
('2020-12-24', 'A1', 'U2'), ('2020-12-08', 'A1', 'U1'),
('2020-12-09', 'A1', 'U1'), ('2021-01-10', 'A2', 'U4'),
('2021-01-11', 'A2', 'U4'), ('2021-01-12', 'A2', 'U4'),
('2021-01-15', 'A2', 'U5'), ('2020-12-17', 'A2', 'U4'),
('2020-12-25', 'A3', 'U6'), ('2020-12-25', 'A3', 'U6'),
('2020-12-25', 'A3', 'U6'), ('2020-12-06', 'A3', 'U7'),
('2020-12-06', 'A3', 'U6'), ('2021-01-14', 'A3', 'U6'),
('2021-02-07', 'A1', 'U1'), ('2021-02-10', 'A1', 'U2'),
('2021-02-01', 'A2', 'U4'), ('2021-02-01', 'A2', 'U5'),
('2020-12-05', 'A1', 'U8'), ('2021-01-07', 'A1', 'U3'),
('2021-01-08', 'A1', 'U2'), ('2021-01-09', 'A1', 'U1'),
('2021-01-13', 'A2', 'U5'), ('2021-01-18', 'A3', 'U7'),
('2021-01-19', 'A3', 'U6'), ('2021-01-20', 'A3', 'U7'),
('2021-01-21', 'A3', 'U6'), ('2021-01-22', 'A3', 'U6');

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
-- 3. Friday Purchases
-- IBM is working on a new feature to analyze user purchasing behavior for all Fridays in the first quarter of the year. 
-- In this question first quarter is defined as first 13 weeks. 
-- For each Friday separately, calculate the average amount users have spent per order. 
-- The output should contain the week number of that Friday and average amount spent.

CREATE TABLE user_purchases (
    user_id INT,
    date DATE,
    amount_spent INT,
    day_name VARCHAR(10)
);

INSERT INTO user_purchases (user_id, date, amount_spent, day_name) VALUES
(1047, '2023-01-01', 288, 'Sunday'), (1099, '2023-01-04', 803, 'Wednesday'),
(1055, '2023-01-07', 546, 'Saturday'), (1040, '2023-01-10', 680, 'Tuesday'),
(1052, '2023-01-13', 889, 'Friday'), (1052, '2023-01-13', 596, 'Friday'),
(1016, '2023-01-16', 960, 'Monday'), (1023, '2023-01-17', 861, 'Tuesday'),
(1010, '2023-01-19', 758, 'Thursday'), (1013, '2023-01-19', 346, 'Thursday'),
(1069, '2023-01-21', 541, 'Saturday'), (1030, '2023-01-22', 175, 'Sunday'),
(1034, '2023-01-23', 707, 'Monday'), (1019, '2023-01-25', 253, 'Wednesday'),
(1052, '2023-01-25', 868, 'Wednesday'), (1095, '2023-01-27', 424, 'Friday'),
(1017, '2023-01-28', 755, 'Saturday'), (1010, '2023-01-29', 615, 'Sunday'),
(1063, '2023-01-31', 534, 'Tuesday'), (1019, '2023-02-03', 185, 'Friday'),
(1019, '2023-02-03', 995, 'Friday'), (1092, '2023-02-06', 796, 'Monday'),
(1058, '2023-02-09', 384, 'Thursday'), (1055, '2023-02-12', 319, 'Sunday'),
(1090, '2023-02-15', 168, 'Wednesday'), (1090, '2023-02-18', 146, 'Saturday'),
(1062, '2023-02-21', 193, 'Tuesday'), (1023, '2023-02-24', 259, 'Friday'),
(1023, '2023-02-24', 849, 'Friday'), (1009, '2023-02-27', 552, 'Monday'),
(1012, '2023-03-02', 303, 'Thursday'), (1001, '2023-03-05', 317, 'Sunday'),
(1058, '2023-03-08', 573, 'Wednesday'), (1001, '2023-03-11', 531, 'Saturday'),
(1034, '2023-03-14', 440, 'Tuesday'), (1096, '2023-03-17', 650, 'Friday'),
(1048, '2023-03-20', 711, 'Monday'), (1089, '2023-03-23', 388, 'Thursday'),
(1001, '2023-03-26', 353, 'Sunday'), (1016, '2023-03-29', 833, 'Wednesday');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1 - Using DATEPART(WEEK, date) (SQL Server specific) and AVG function
select 
	DATEPART(WEEK, date) as week_number,
	AVG(amount_spent) as avg_spend_per_user
from user_purchases
where day_name = 'Friday'
	and DATEPART(WEEK, date) <= 13
group by DATEPART(WEEK, date)
order by week_number asc;

-- SOLUTION 2 - Using Common Table Expression (CTE) to Tag Week Numbers
WITH friday_data AS (
    SELECT *,
           DATEPART(week, date) AS week_number
    FROM user_purchases
    WHERE day_name = 'Friday'
		and DATEPART(week, date) <= 13
)
SELECT 
    week_number,
    ROUND(AVG(amount_spent), 2) AS avg_amount_spent
FROM friday_data
GROUP BY week_number
ORDER BY week_number;

-- ==================================================================================================================================
