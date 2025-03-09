-- QUESTION : 1
-- 1. Write an SQL query to report the difference between number of apples and oranges sold each day.
-- Return the result table ordered by sale_date in format ('YYYY-MM-DD').

CREATE TABLE Sales (
    sale_date DATE NOT NULL,
    fruit NVARCHAR(10) NOT NULL CHECK (fruit IN ('apples', 'oranges')),
    sold_num INT NOT NULL,
    PRIMARY KEY (sale_date, fruit)
);

INSERT INTO Sales (sale_date, fruit, sold_num) VALUES
('2020-05-01', 'apples', 10),
('2020-05-01', 'oranges', 8),
('2020-05-02', 'apples', 15),
('2020-05-02', 'oranges', 15),
('2020-05-03', 'apples', 20),
('2020-05-03', 'oranges', 0),
('2020-05-04', 'apples', 15),
('2020-05-04', 'oranges', 16);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

select sale_date,
	sum(case
		when fruit = 'apples' then sold_num else 0
	end) -
	sum(case
		when fruit = 'oranges' then sold_num else 0
	end) as apples_oranges_diff
from sales
group by sale_date
order by sale_date;

------------------------------------------- OR --------------------------------------------

Select sale_date, 
	sold_num-sold as diff
from (
	(select *
	from sales
	where fruit = 'apples') a
join 
	(select sale_date as sale, 
		fruit, sold_num as sold
	from sales
	where fruit = 'oranges') o
on a.sale_date = o.sale
);

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Write an SQL query to find all the people who viewed more than one article on the same date, sorted in ascending order by their id.
-- Note - author_id and viewer_id should not be same.

CREATE TABLE Views (
    article_id INT,
    author_id INT,
    viewer_id INT,
    view_date DATE
);
INSERT INTO Views (article_id, author_id, viewer_id, view_date)
VALUES
(1, 3, 5, '2019-08-01'),
(3, 4, 5, '2019-08-01'),
(1, 3, 6, '2019-08-02'),
(2, 7, 7, '2019-08-01'),
(2, 7, 6, '2019-08-02'),
(4, 7, 1, '2019-07-22'),
(3, 4, 4, '2019-07-21'),
(3, 4, 4, '2019-07-21');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with viewer_cnt_cte as (
	select viewer_id, view_date,
		count(*) as viewer_cnt
	from views
	where author_id != viewer_id
	group by viewer_id, view_date
)
select viewer_id
from viewer_cnt_cte
where viewer_cnt > 1;

-- ==================================================================================================================================
