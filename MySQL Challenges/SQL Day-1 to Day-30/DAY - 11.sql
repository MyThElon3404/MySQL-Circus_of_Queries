-- QUESTION : 1
-- 1. write a query to retrieve the average star rating for each product, grouped by month. 
-- The output should display the month as a numerical value, product ID, and average star rating rounded to two decimal places. 
-- Sort the output first by month and then by product ID.

drop table if exists reviews;
create table reviews (
	review_id int not null,
	user_id int not null,
	submit_date datetime not null,
	product_id int not null,
	stars int check(stars >= 1 and stars <= 5) not null
);

insert into reviews
values
	(6171, 123, '2022-06-08 00:00:00', 50001, 4),
	(7802, 265, '2022-06-10 00:00:00', 69852, 4),
	(5293, 362, '2022-06-18 00:00:00', 50001, 3),
	(6352, 192, '2022-07-26 00:00:00', 69852, 3),
	(4517, 981, '2022-07-05 00:00:00', 69852, 2);

select * from reviews;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

select MONTH(submit_date) as month, product_id,
	ROUND(AVG(stars), 2) as avg_star_rating
from reviews
group by MONTH(submit_date), product_id
order by month asc, product_id asc;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Write a SQL query to find top 2 sub_category for category based on it's price.
-- if we've only one sub_category then check price is >50 and then include in output.

drop table if exists categories;
create table categories (
	category varchar(20),
	sub_category varchar(20),
	price int
);
insert into categories
values ('chips', 'bingo', 10), ('chips', 'Lays', 40),
	('chips', 'kurkure', 60), ('choclate', 'dairy milk', 120),
	('choclate', 'five star', 40), ('choclate', 'perk', 25),
	('choclate', 'munch', 5), ('biscuits', 'oreo', 120);

select * from categories;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with category_sub_category_cte as (
	 SELECT *,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY price DESC) AS category_rn,
        COUNT(sub_category) OVER (PARTITION BY category) AS sub_category_cnt
    FROM
        categories
)
select category, sub_category
from category_sub_category_cte
where (category_rn in (1,2) and sub_category_cnt > 1)
	or (price > 50 and sub_category_cnt = 1);

-- ==================================================================================================================================
