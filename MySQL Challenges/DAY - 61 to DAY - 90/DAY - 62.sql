-- QUESTION : 1
-- 1. Write an SQL query to find the id and the name of active users.
-- Active users are those who logged in to their accounts for 5 or more consecutive days.

CREATE TABLE Accounts (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);
CREATE TABLE Logins (
    id INT,
    login_date DATE
);

INSERT INTO Accounts (id, name) 
	VALUES
(1, 'Winston'),
(7, 'Jonathan');
INSERT INTO Logins (id, login_date) 
	VALUES
(7, '2020-05-30'),
(1, '2020-05-30'),
(7, '2020-05-31'),
(7, '2020-06-01'),
(7, '2020-06-02'),
(7, '2020-06-02'),
(7, '2020-06-03'),
(1, '2020-06-07'),
(7, '2020-06-10');


-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1 - Using ROW_NUMBER() to Detect Gaps
-- we apply row_numbers to get partition by id, login_date
with logins_rn as (
	select id, login_date,
		row_number() over(partition by id order by login_date) as rn
	from (select distinct id, login_date from logins) as distinct_logins
),	-- find grp of dates using dateadd
	consecutiveGroups as (
		select id, login_date,
			dateadd(day, -rn, login_date) as grp
		from logins_rn
	),	-- find id in logins where they logins for consecutively 5 days or more than 5
		consecutiveLogins as (
			select id
			from ConsecutiveGroups
			group by id, grp
			having count(*) >= 5
		)
		select a.id, a.name
		from consecutiveLogins cl
		join accounts a
			on cl.id = a.id;

-- SOLUTION 2 - 

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. 



-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================

-- QUESTION : 3
-- 3. 



-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================
