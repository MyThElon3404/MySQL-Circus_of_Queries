drop schema if exists x_dannys_diner;

CREATE SCHEMA x_dannys_diner_w1d1;
use x_dannys_diner_w1d1;

-- alter schema x_dannys_diner rename to x_dannys_diner

-- alter table new_sales rename to sales;

CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
select * from sales;
select * from menu;
select * from members;
--	------------------------------ -- Case Study Questions	--------------------------------------------------------

-- 1. What is the total amount each customer spent at the restaurant?

select sales.customer_id, sum(menu.price) as total_price
from sales
inner join menu
on sales.product_id = menu.product_id
group by sales.customer_id
order by sales.customer_id asc;
-- --------------------------------------------------------------------------------------------------

-- 2. How many days has each customer visited the restaurant?

select customer_id, count(distinct order_date) from sales
group by customer_id;
-- --------------------------------------------------------------------------------------------------

-- 3. What was the first item from the menu purchased by each customer?

WITH ordered_sales AS (
	SELECT sales.customer_id, sales.order_date, menu.product_name,
	DENSE_RANK() OVER (PARTITION BY sales.customer_id ORDER BY sales.order_date) AS rank_num
	FROM sales
	INNER JOIN menu
	ON sales.product_id = menu.product_id
)
SELECT customer_id, product_name
FROM ordered_sales
WHERE rank_num = 1
GROUP BY customer_id, product_name;
-- --------------------------------------------------------------------------------------------------

-- 4. What was the first item from the menu purchased by each customer?

select distinct sales.customer_id, menu.product_name
from sales
join menu
on sales.product_id = menu.product_id
where sales.order_date = any (
		select min(order_date) from sales
        group by customer_id
);
-- --------------------------------------------------------------------------------------------------
-- 5. What is the most purchased item on the menu and how many times was it purchased by all customers?

select count(sales.product_id) as total_count, menu.product_name
from sales
join menu
on sales.product_id = menu. product_id
group by menu.product_name
order by total_count desc limit 3;
-- --------------------------------------------------------------------------------------------------
-- 	6. Which item was the most popular for each customer?

WITH most_popular AS (
	SELECT sales.customer_id, menu.product_name, COUNT(menu.product_id) AS order_count,
    DENSE_RANK() OVER (PARTITION BY sales.customer_id ORDER BY COUNT(sales.customer_id) DESC) AS rank_num
	FROM menu
	JOIN sales
    ON menu.product_id = sales.product_id
  GROUP BY sales.customer_id, menu.product_name
)
SELECT customer_id, product_name, order_count
FROM most_popular 
WHERE rank_num = 1;

with most_popular as (
	select sales.customer_id, menu.product_name, count(sales.product_id) as total_count,
    dense_rank() over (partition by sales.customer_id order by count(sales.customer_id) desc) as rank_num
    from sales
    join menu
    ON sales.product_id = menu.product_id
    group by sales.customer_id, menu.product_name
)
SELECT customer_id, product_name, total_count
FROM most_popular 
WHERE rank_num = 1;

				-- how to use select statement with with_clause

with most_popular as (
	select sales.customer_id, menu.product_name, count(sales.product_id) as total_count,
    dense_rank() over (partition by sales.customer_id order by count(sales.customer_id) desc) as rank_num
    from sales
    join menu
    ON sales.product_id = menu.product_id
    group by sales.customer_id, menu.product_name
)

select * from most_popular;

-- --------------------------------------------------------------------------------------------------
-- 7. Which item was purchased first by the customer after they became a member?

with joined_as_member as (
	select members.customer_id, sales.product_id,
    row_number() over (partition by members.customer_id order by sales.order_date) as row_num
    from members
    join sales
    on members.customer_id = sales.customer_id
    where sales.order_date > members.join_date
)
-- select * from joined_as_member;
select customer_id, menu.product_name
from joined_as_member
inner join menu
on joined_as_member.product_id = menu.product_id
where row_num = 1
order by customer_id asc;
-- --------------------------------------------------------------------------------------------------
-- 	8. Which item was purchased just before the customer became a member?

with joined_as_member as (
	select members.customer_id, sales.product_id, sales.order_date, members.join_date,
    row_number() over (partition by members.customer_id order by sales.order_date desc) as row_num
    from members
    join sales
    on members.customer_id = sales.customer_id
    where sales.order_date < members.join_date
)
select customer_id, menu.product_name
from joined_as_member
inner join menu
on joined_as_member.product_id = menu.product_id
where row_num = 1
order by customer_id asc;
-- --------------------------------------------------------------------------------------------------
-- 9. What is the total items and amount spent for each member before they became a member?

select sales.customer_id, count(sales.product_id) as total_items, sum(menu.price) as amount_spent
from sales
inner join members
on members.customer_id = sales.customer_id
and sales.order_date < members.join_date
inner join menu
on sales.product_id = menu.product_id
group by sales.customer_id
order by sales.customer_id;
-- --------------------------------------------------------------------------------------------------
-- 10. If each $1 spent equates to 10 points and sushi has a 2x points multiplier — 
-- how many points would each customer have?

with points_tb as (
	select menu.product_id,
    case
		when menu.product_id = 1 then price * 20
        else price * 10
	end as points
    from menu
)
-- select * from points_tb;
select sales.customer_id, sum(points_tb.points) as total_points
from sales
inner join points_tb
on sales.product_id = points_tb.product_id
group by sales.customer_id
order by sales.customer_id;
-- --------------------------------------------------------------------------------------------------
-- 11. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, 
-- not just sushi - how many points do customer A and B have at the end of January?

with valid_member_date_cte as (
	select *,
		DATEADD(DAY, 6, mem.join_date) as member_valid_date,
		EOMONTH('2021-01-01') as last_date
	from members as mem
)
select s.customer_id as customer,
	sum(
		case when s.product_id = 1 then m.price * 20
			when s.order_date between vm.join_date and vm.member_valid_date 
				then m.price * 20
			else m.price * 10
		end
	) as total_points
from valid_member_date_cte as vm
inner join sales as s
	on vm.customer_id = s.customer_id
inner join menu as m
	on m.product_id = s.product_id
where s.order_date <= vm.last_date
group by s.customer_id;

-- --------------------------------------------------------------------------------------------------
					-- Join All The Things -> sales, menu, members
                    
SELECT s.customer_id, s.order_date, m.product_name, m.price,
	CASE 
		WHEN s.order_date >= mem.join_date THEN 'Y'
        ELSE 'N' 
	END AS member_status
FROM sales s
LEFT JOIN members mem ON mem.customer_id = s.customer_id
JOIN menu m ON m.product_id = s.product_id
ORDER BY customer_id, order_date, price DESC;
-- --------------------------------------------------------------------------------------------------
					-- Rank Members — fill non-members with null
                    
WITH membership AS (
  SELECT sales.customer_id, sales.order_date, menu.product_name, menu.price,
    CASE
      WHEN members.join_date > sales.order_date THEN 'N'
      WHEN members.join_date <= sales.order_date THEN 'Y'
      ELSE 'N' 
	END AS member_status
  FROM sales
  LEFT JOIN members ON sales.customer_id = members.customer_id
  INNER JOIN menu ON sales.product_id = menu.product_id
)
-- select * from membership;
select *,
	case 
		when member_status = 'N' then null
        else rank() over (partition by customer_id, member_status order by order_date)
	end as ranking_to_members
from membership;
