-- QUESTION : 1
-- 1. Write a query to replace rent value at null value

create table tb (
	id int,
  	rent int
);

insert into tb
value
(1, 150),
(2, null),
(3, null),
(4, null),
(5, 100),
(6, null),
(7, null),
(8, null);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- 1. Using CTE
with cte_1 as (
	SELECT id, rent,
		count(rent) OVER (ORDER BY id) AS rn
	FROM tb
)
select id,
	max(rent) over(partition by rn) as new_rent
from cte_1;

-- 2. Using recursive CTE
WITH RECURSIVE cte AS (
    -- Base case: Select the first row
    SELECT id, rent
    FROM tb
    WHERE id = 1

    UNION ALL

    -- Recursive case: Propagate the previous value for subsequent rows
    SELECT t.id, 
           CASE
               WHEN t.rent IS NOT NULL THEN t.rent
               ELSE cte.rent
           END AS rent
    FROM tb t
    JOIN cte ON t.id = cte.id + 1
)
SELECT id, rent
FROM cte;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Write a query to replace brands value at null value

create table brands (
category varchar(20),
brand_name varchar(20)
);
insert into brands 
values ('chocolates','5-star')
,(null,'dairy milk')
,(null,'perk')
,(null,'eclair')
,('Biscuits','britannia')
,(null,'good day')
,(null,'boost');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================
