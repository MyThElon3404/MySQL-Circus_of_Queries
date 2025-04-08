-- QUESTION : 1
-- 1. Workers Who Are Also Managers
-- Find all employees who have or had a job title that includes manager.
-- Output the first name along with the corresponding title.

CREATE TABLE worker (
    worker_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    salary INT,
    joining_date DATE,
    department VARCHAR(50)
);
INSERT INTO worker 
	VALUES
(1, 'Monika', 'Arora', 100000, '2014-02-20', 'HR'),
(2, 'Niharika', 'Verma', 80000, '2014-06-11', 'Admin'),
(3, 'Vishal', 'Singhal', 300000, '2014-02-20', 'HR'),
(4, 'Amitah', 'Singh', 500000, '2014-02-20', 'Admin'),
(5, 'Vivek', 'Bhati', 500000, '2014-06-11', 'Admin'),
(6, 'Vipul', 'Diwan', 200000, '2014-06-11', 'Account'),
(7, 'Satish', 'Kumar', 75000, '2014-01-20', 'Account'),
(8, 'Geetika', 'Chauhan', 90000, '2014-04-11', 'Admin'),
(9, 'Agepi', 'Argon', 90000, '2015-04-10', 'Admin'),
(10, 'Moe', 'Acharya', 65000, '2015-04-11', 'HR'),
(11, 'Nayah', 'Laghari', 75000, '2014-03-20', 'Account'),
(12, 'Jai', 'Patel', 85000, '2014-03-21', 'HR');

CREATE TABLE title (
    worker_ref_id INT,
    worker_title VARCHAR(50),
    affected_from DATE
);
INSERT INTO title 
	VALUES
(1, 'Manager', '2016-02-20'),
(2, 'Executive', '2016-06-11'),
(8, 'Executive', '2016-06-11'),
(5, 'Manager', '2016-06-11'),
(4, 'Asst. Manager', '2016-06-11'),
(7, 'Executive', '2016-06-11'),
(6, 'Lead', '2016-06-11'),
(3, 'Lead', '2016-06-11');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1 - Using INNER JOIN + WHERE LIKE
select 
	w.worker_id,
	CONCAT(w.first_name,' ', w.last_name) as worker_name,
	t.worker_title
from worker w
inner join title t
	on w.worker_id = t.worker_ref_id
where t.worker_title like '%Manager%';

-- SOLUTION 2 - Using IN with Subquery
select 
	w.worker_id,
	CONCAT(w.first_name,' ', w.last_name) as worker_name,
	t.worker_title
from worker w, title t
where w.worker_id = t.worker_ref_id
and w.worker_id in (
	select worker_ref_id
	from title
	where worker_title like '%Manager%'
);

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Maximum of Two Numbers
-- Given a single column of numbers, consider all possible permutations of two numbers assuming that pairs of numbers 
-- (x,y) and (y,x) are two different permutations. Then, for each permutation, find the maximum of the two numbers.
-- Output three columns: the first number, the second number and the maximum of the two.

CREATE TABLE deloitte_numbers (
    number INT
);
INSERT INTO deloitte_numbers (number) 
	VALUES
(-2),
(-1),
(0),
(1),
(2);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1 - Using CROSS JOIN and CASE Statement
select a.number as n1,
	b.number as n2,
	case when a.number > b.number then a.number
	else b.number
	end as max_number
from deloitte_numbers a
cross join deloitte_numbers b;

-- SOLUTION 2 - Using Self Join and CASE Statement
select a.number as n1,
	b.number as n2,
	case when a.number > b.number then a.number
	else b.number
	end as max_number
from deloitte_numbers a
join deloitte_numbers b
	on 1 = 1;

-- ==================================================================================================================================

-- QUESTION : 3
-- 3. Most Expensive And Cheapest Wine With Ties
-- Find the cheapest and the most expensive variety in each region. Output the region along with the corresponding 
-- most expensive and the cheapest variety. Be aware that there are 2 region columns, the price from that row applies to both of them.
-- Note: The results set contains ties, so your solution should account for this.

-- For example in the event of a tie for the cheapest wine your output should look similar to this:

-- region      | most_expensive_variety        | cheapest_variety
-- region_name | expensive_variety             | cheap_variety_1
-- region_name | expensive_variety             | cheap_variety_2

CREATE TABLE winemag_pd (
    id INT PRIMARY KEY,
    country VARCHAR(100),
    designation VARCHAR(255),
    points INT,
    price DECIMAL(10, 2),
    province VARCHAR(255),
    region_1 VARCHAR(255),
    region_2 VARCHAR(255),
    variety VARCHAR(255),
    winery VARCHAR(255)
);

INSERT INTO winemag_pd (
    id, country, designation, points, price, province, region_1, region_2, variety, winery
) VALUES
(0, 'Italy', 'Vulkà Bianco', 87, 16.00, 'Sicily & Sardinia', 'Etna', NULL, 'White Blend', 'Nicosia'),
(1, 'Portugal', 'Avidagos', 87, 15.00, 'Douro', NULL, NULL, 'Portuguese Red', 'Quinta dos Avidagos'),
(2, 'US', 'Reserve Late Harvest', 87, 13.00, 'Michigan', 'Lake Michigan Shore', NULL, 'Riesling', 'St. Julian'),
(3, 'US', 'Vintner''s Reserve Wild Child Block', 87, 65.00, 'Oregon', 'Willamette Valley', 'Willamette Valley', 'Pinot Noir', 'Sweet Cheeks'),
(4, 'US', 'Mountain Cuvée', 87, 39.00, 'California', 'Napa', 'Sonoma', 'Cabernet Sauvignon', 'Justin'),
(5, 'Spain', 'Ermita D''Espiells', 87, 20.00, 'Catalonia', 'Cava', NULL, 'Sparkling Blend', 'Juvé y Camps'),
(6, 'France', 'Les Natures', 87, 24.00, 'Alsace', 'Alsace', NULL, 'Pinot Gris', 'Joseph Cattin'),
(7, 'Italy', 'San Gregorio', 87, 26.00, 'Campania', 'Irpinia', NULL, 'Aglianico', 'Tenuta Ponte'),
(8, 'US', 'Barrel Select', 87, 15.00, 'New York', 'Finger Lakes', NULL, 'Cabernet Franc', 'Dr. Konstantin Frank'),
(9, 'France', 'Kritt', 87, 30.00, 'Alsace', 'Alsace', NULL, 'Riesling', 'Marc Kreydenweiss'),
(10, 'Germany', 'Urziger Wurzgarten Spatlese', 87, 30.00, 'Mosel', 'Mosel', NULL, 'Riesling', 'Dr. H. Thanisch (Erben Müller-Burggraef)'),
(11, 'US', 'Signature', 87, 52.00, 'New York', 'Finger Lakes', NULL, 'Gewürztraminer', 'Lamoreaux Landing'),
(12, 'Italy', 'Nero d''Avola', 87, 18.00, 'Sicily & Sardinia', 'Sicilia', NULL, 'Nero d''Avola', 'Feudo Principi di Butera'),
(13, 'US', 'Amphora Series Tempranillo', 87, 32.00, 'Virginia', 'Virginia', NULL, 'Tempranillo', 'Williamsburg Winery'),
(14, 'US', 'Cabernet Sauvignon', 87, 45.00, 'California', 'Napa Valley', 'Napa', 'Cabernet Sauvignon', 'Robert Mondavi'),
(15, 'US', 'Merlot', 87, 35.00, 'Washington', 'Columbia Valley', 'Columbia Valley', 'Merlot', 'Chateau Ste. Michelle'),
(16, 'Argentina', 'Malbec', 87, 20.00, 'Mendoza Province', 'Mendoza', NULL, 'Malbec', 'Trapiche'),
(17, 'US', 'Chardonnay', 87, 18.00, 'California', 'Sonoma Coast', 'Sonoma', 'Chardonnay', 'La Crema'),
(18, 'US', 'Pinot Noir', 87, 50.00, 'California', 'Sonoma Coast', 'Sonoma', 'Pinot Noir', 'La Crema'),
(19, 'US', 'Zinfandel', 87, 22.00, 'California', 'Sonoma Valley', 'Sonoma', 'Zinfandel', 'Ravenswood');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1 - Window Functions (ROW_NUMBER or RANK)
WITH flattened AS (
    SELECT region_1 AS region, variety, price
    FROM winemag_pd
    WHERE region_1 IS NOT NULL
    UNION ALL
    SELECT region_2 AS region, variety, price
    FROM winemag_pd
    WHERE region_2 IS NOT NULL
),
ranked AS (
    SELECT *,
        RANK() OVER (PARTITION BY region ORDER BY price ASC) AS min_rank,
        RANK() OVER (PARTITION BY region ORDER BY price DESC) AS max_rank
    FROM flattened
),
cheapest AS (
    SELECT region, variety
    FROM ranked
    WHERE min_rank = 1
),
most_expensive AS (
    SELECT region, variety
    FROM ranked
    WHERE max_rank = 1
)
SELECT DISTINCT
    c.region,
    m.variety AS most_expensive_variety,
    c.variety AS cheapest_variety
FROM cheapest c
JOIN most_expensive m ON c.region = m.region
ORDER BY c.region;

-- SOLUTION 2 - Using CTE and INNER JOIN
WITH wine_varieties AS (
    SELECT region_1 AS region, variety, price
    FROM winemag_pd
    WHERE region_1 IS NOT NULL AND price IS NOT NULL
    
    UNION 
    
    SELECT region_2 AS region, variety, price
    FROM winemag_pd
    WHERE region_2 IS NOT NULL AND price IS NOT NULL
),
cheapest_varieties AS (
    SELECT
        region,
        cheapest_variety
    FROM (
        SELECT
            region,variety AS cheapest_variety,
            RANK() OVER(PARTITION BY region ORDER BY price) AS rank_num
        FROM wine_varieties
    ) r
    WHERE rank_num = 1
),
expensivest_varieties AS (
    SELECT
        region,
        expensivest_variety
    FROM (
        SELECT
            region,
            variety AS expensivest_variety,
            RANK() OVER(PARTITION BY region ORDER BY price DESC) AS rank_num
        FROM wine_varieties
    ) r
    WHERE rank_num = 1
)
SELECT
    c.region,
    c.cheapest_variety,
    e.expensivest_variety
FROM cheapest_varieties c
INNER JOIN expensivest_varieties e 
	ON c.region = e.region;

-- ==================================================================================================================================
