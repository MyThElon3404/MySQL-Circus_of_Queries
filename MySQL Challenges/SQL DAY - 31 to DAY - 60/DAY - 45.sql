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
	where fruit = 'oranges') b
	on a.sale_date = b.sale);

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. 



-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================
