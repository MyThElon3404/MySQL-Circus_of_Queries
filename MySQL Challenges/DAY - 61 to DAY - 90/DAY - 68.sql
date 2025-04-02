-- QUESTION : 1
-- 1. In the reviews table, there is data for product reviews from users, 
-- including the date of the review submission and the number of stars given. 
-- Write a SQL query to calculate the average stars per product for each month.

drop table if exists reviews;
CREATE TABLE reviews (
    review_id INT PRIMARY KEY,
    user_id INT,
    submit_date DATE,
    product_id INT,
    star_rating INT
);
INSERT INTO reviews
	VALUES
(1, 23, '2020-01-06', 1000, 4),
(15, 27, '2020-01-06', 1000, 5),
(2, 34, '2020-01-30', 2000, 5),
(3, 23, '2020-02-01', 1000, 3),
(4, 56, '2020-02-05', 1000, 2),
(5, 12, '2020-03-01', 2000, 4),
(6, 78, '2020-03-10', 3000, 5),
(7, 45, '2020-03-15', 1000, 1),
(8, 89, '2020-04-01', 2000, 3),
(9, 23, '2020-04-05', 3000, 4),
(10, 67, '2020-04-10', 1000, 5),
(11, 45, '2020-04-15', 2000, 2),
(12, 34, '2020-05-01', 1000, 4),
(13, 56, '2020-05-05', 3000, 3),
(14, 78, '2020-05-10', 2000, 5);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- Solution 1 - Using group by
select
	FORMAT(submit_date, 'yyyy-MM') as submit_year_month,
	product_id,
	AVG(star_rating) as avg_star_rating
from reviews
group by FORMAT(submit_date, 'yyyy-MM'), product_id
order by submit_year_month, product_id;

-- Solution 2 - Using window function (if duplicate enter of submit_date and product_id is not present)
select
	FORMAT(submit_date, 'yyyy-MM') as submit_year_month,
	product_id,
	avg(star_rating) over(partition by FORMAT(submit_date, 'yyyy-MM'), product_id) as avg_rn
from reviews;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. NICE is a company that offers a diverse array of digital products to its customers. 
-- In order to understand customer behavior and user engagement, they record the user login activities.
-- They want to understand the peak login time for their users on their platform. For this purpose, 
-- they want to perform an analysis on hourly basis to identify the hour of the day when most logins occur.

-- Given the following example of a user_activity table, 
-- write an SQL query that will return the hour of the day with the highest total user logins.

drop table if exists user_activity;
CREATE TABLE user_activity (
    activity_id INT PRIMARY KEY,
    user_id INT,
    login_time DATETIME
);
INSERT INTO user_activity (activity_id, user_id, login_time) 
	VALUES
(101, 564, '2022-08-07 07:45:00'),
(102, 340, '2022-08-07 12:30:00'),
(103, 123, '2022-08-07 13:00:00'),
(104, 789, '2022-08-07 12:45:00'),
(105, 456, '2022-08-07 19:00:00'),
(106, 890, '2022-08-07 19:30:00'),
(107, 234, '2022-08-07 08:15:00'),
(108, 678, '2022-08-07 09:30:00'),
(109, 321, '2022-08-07 10:45:00'),
(110, 876, '2022-08-07 11:00:00'),
(111, 432, '2022-08-07 12:15:00'),
(112, 987, '2022-08-07 14:30:00'),
(113, 654, '2022-08-07 15:00:00'),
(114, 765, '2022-08-07 19:45:00'),
(115, 852, '2022-08-07 20:00:00');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- Solution 1 - Using GROUP BY and ORDER BY (Simple & Efficient Approach)
select TOP 1
	DATEPART(HOUR, login_time) as login_hour,
	count(user_id) as total_user_login
from user_activity
group by DATEPART(HOUR, login_time)
order by total_user_login desc;

-- Solution 2 - Using RANK() (Handles Multiple Peak Hours if Tied)
with cte as (
	select TOP 1
		DATEPART(HOUR, login_time) as login_hour,
		count(user_id) as total_user_login
	from user_activity
	group by DATEPART(HOUR, login_time)
	order by total_user_login desc
)
select login_hour, total_user_login
from (
	select login_hour, total_user_login,
		rank() over(partition by login_hour order by total_user_login desc) as cte_rn
	from cte
) ranked_hour
where cte_rn = 1;

-- ==================================================================================================================================

-- QUESTION : 3
-- 3. -- Given a table sales that keeps track of the number of each product sold in a certain month, along with its selling price. 
-- Write a SQL query to calculate the total sales, average price, and total number of units sold for each product. 
-- Use mathematical functions and arithmetic operations where appropriate.

drop table if exists sales;
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    month DATE,
    units_sold INT,
    price_per_unit DECIMAL(10,2)
);
INSERT INTO sales
	VALUES
(1, 100, '2022-01-01', 100, 20),
(2, 100, '2022-02-01', 150, 18),
(3, 101, '2022-01-01', 80, 30),
(4, 102, '2022-01-01', 50, 60),
(5, 101, '2022-03-01', 60, 25),
(6, 103, '2022-01-01', 90, 40),
(7, 100, '2022-03-01', 200, 22),
(8, 101, '2022-02-01', 100, 28),
(9, 102, '2022-02-01', 60, 55),
(10, 103, '2022-02-01', 120, 38),
(11, 100, '2022-04-01', 180, 19),
(12, 101, '2022-04-01', 90, 27),
(13, 102, '2022-03-01', 75, 58),
(14, 103, '2022-03-01', 130, 39);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- Solution 1 - Using GROUP BY
SELECT 
    product_id,
    SUM(units_sold * price_per_unit) AS total_sales,
    AVG(price_per_unit) AS avg_price,
    SUM(units_sold) AS total_units_sold
FROM sales
GROUP BY product_id;

-- ==================================================================================================================================
