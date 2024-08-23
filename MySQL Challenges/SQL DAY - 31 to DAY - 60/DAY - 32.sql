-- QUESTION : 1
-- 1. Write a query that joins this submissions table to the loans table and returns the total loan 
-- balance on each user’s most recent ‘Refinance’ submission. Return all users and the balance for each of them.

drop table if exists loans;
CREATE TABLE loans (
    id INT PRIMARY KEY,
    user_id INT,
    created_at DATETIME,
    status VARCHAR(50),
    type VARCHAR(50)
);
INSERT INTO loans (id, user_id, created_at, status, type) 
VALUES
(1, 100, '2017-04-21', 'prequal_completd_offer', 'Refinance'),
(2, 100, '2017-04-27', 'offer_accepted', 'Refinance'),
(3, 101, '2017-04-22', 'prequal_completd_no_offer', 'Refinance'),
(4, 101, '2017-04-23', 'offer_accepted', 'Refinance'),
(5, 101, '2017-04-25', 'offer_accepted', 'Personal'),
(6, 102, '2017-04-27', 'offer_accepted', 'InSchool'),
(7, 107, '2017-04-27', 'prequal_response_received', 'Personal'),
(8, 108, '2017-04-21', 'form_in_progress', 'Refinance'),
(9, 108, '2017-04-27', 'offer_accepted', 'Refinance'),
(10, 108, '2017-04-27', 'prequal_response_received', 'InSchool'),
(11, 100, '2015-04-21', 'prequal_completd_offer', 'Refinance');

drop table if exists submissions;
CREATE TABLE submissions (
    id INT PRIMARY KEY,
    balance FLOAT,
    interest_rate FLOAT,
    rate_type VARCHAR(50),
    loan_id INT,
    FOREIGN KEY (loan_id) REFERENCES loans(id)
);
INSERT INTO submissions (id, balance, interest_rate, rate_type, loan_id) 
VALUES
(1, 5229.12, 8.75, 'variable', 2),
(2, 12727.52, 11.37, 'fixed', 4),
(3, 14996.58, 8.25, 'fixed', 9),
(4, 21149, 4.75, 'variable', 7),
(5, 14379, 3.75, 'variable', 5),
(6, 6221.12, 6.75, 'variable', 11);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1 - Using cte and row_number
with most_recent_ref as (
	select id, user_id,
		created_at,
		-- MAX(created_at) as recently_refinance,
		ROW_NUMBER() over(partition by user_id order by created_at desc) as rn
	from loans
	where type = 'Refinance'
)
select m.user_id, s.balance
from most_recent_ref as m
join submissions as s
	on m.id = s.loan_id
where m.rn=1;

-- SOLUTION 2 - Using sub-query
select l.user_id, s.balance
from loans as l
join submissions as s
	on l.id = s.loan_id
where l.created_at = (
	select max(created_at)
	from loans
	where user_id = l.user_id
		and type = 'Refinance'
);

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Output share of US users that are active. Active users are the ones with an "open" status in the table.

drop table if exists fb_active_users;
CREATE TABLE fb_active_users (
    user_id INT,
    name VARCHAR(255),
    status VARCHAR(50),
    country VARCHAR(50)
);
INSERT INTO fb_active_users (user_id, name, status, country) 
VALUES
(33, 'Amanda Leon', 'open', 'Australia'),
(27, 'Jessica Farrell', 'open', 'Luxembourg'),
(18, 'Wanda Ramirez', 'open', 'USA'),
(50, 'Samuel Miller', 'closed', 'Brazil'),
(16, 'Jacob York', 'open', 'Australia'),
(25, 'Natasha Bradford', 'closed', 'USA'),
(34, 'Donald Ross', 'closed', 'China'),
(52, 'Michelle Jimenez', 'open', 'USA'),
(11, 'Theresa John', 'open', 'China'),
(37, 'Michael Turner', 'closed', 'Australia'),
(32, 'Catherine Hurst', 'closed', 'Mali'),
(61, 'Tina Turner', 'open', 'Luxembourg'),
(4, 'Ashley Sparks', 'open', 'China'),
(82, 'Jacob York', 'closed', 'USA'),
(87, 'David Taylor', 'closed', 'USA'),
(78, 'Zachary Anderson', 'open', 'China'),
(5, 'Tiger Leon', 'closed', 'China'),
(56, 'Theresa Weaver', 'closed', 'Brazil'),
(21, 'Tonya Johnson', 'closed', 'Mali'),
(89, 'Kyle Curry', 'closed', 'Mali'),
(7, 'Donald Jim', 'open', 'USA'),
(22, 'Michael Bone', 'open', 'Canada'),
(31, 'Sara Michaels', 'open', 'Denmark');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- Calculate total US users
SELECT COUNT(*) AS total_us_users
FROM fb_active_users
WHERE country = 'USA';

-- Calculate total active US users
SELECT COUNT(*) AS active_us_users
FROM fb_active_users
WHERE country = 'USA' AND status = 'open';

-- Calculate the share of active US users
SELECT ROUND((COUNT(CASE WHEN status = 'open' THEN 1 END) * 1.0/ COUNT(*)) * 100, 2) AS share_of_active_us_users
FROM fb_active_users
WHERE country = 'USA';

-- ==================================================================================================================================
