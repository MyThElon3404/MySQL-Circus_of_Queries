-- Find the average daily active users for January 2021 for each account. 
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

--------------------------------------------------------------------------------------------------------------------------------------
