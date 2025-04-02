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
-- 2. 



-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================

-- QUESTION : 3
-- 3. 



-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================
