
-- Combine the menu_items and order_details tables into a single table

select od.order_details_id, 
	od.order_id, od.order_date,
	mi.menu_item_id, mi.item_name,
	mi.category, mi.price
from order_details as od
JOIN menu_items as mi
	on od.item_id = mi.menu_item_id;

-- =====================================================================================

-- What were the least and most ordered items? What categories were they in?

-- 1. least ordered items
select TOP 1 item_name,
	COUNT(order_details_id) as num_ordered
from menu_items as mi
left join order_details as od
	on mi.menu_item_id = od.item_id
group by item_name
order by num_ordered asc;

-- 2. most ordered items
select TOP 1 item_name,
	COUNT(order_details_id) as num_ordered
from menu_items as mi
left join order_details as od
	on mi.menu_item_id = od.item_id
group by item_name
order by num_ordered desc;

-- 3. least and most ordered items category wise
	-- least
select TOP 1 item_name, category,
	COUNT(order_details_id) as num_ordered
from menu_items as mi
left join order_details as od
	on mi.menu_item_id = od.item_id
group by item_name, category
order by num_ordered;

	-- most
select TOP 1 item_name, category,
	COUNT(order_details_id) as num_ordered
from menu_items as mi
left join order_details as od
	on mi.menu_item_id = od.item_id
group by item_name, category
order by num_ordered desc;

-- =====================================================================================

-- What were the top 5 orders that spent the most money?

select TOP 5 order_id,
	SUM(price) as total_money_spent
from order_details as od
JOIN menu_items as mi
	on od.item_id = mi.menu_item_id
group by order_id
order by total_money_spent desc;

-- =====================================================================================

-- View the details of the highest spend order. Which specific items were purchased?

-- 1. details of highest spend order
select TOP 1 order_id,
	SUM(price) as high_money_spent_order
from order_details as od
JOIN menu_items as mi
	on od.item_id = mi.menu_item_id
group by order_id
order by high_money_spent_order desc;

-- 2. specific items were purchased in highest spend order

select item_name
from order_details as od
JOIN menu_items as mi
	on od.item_id = mi.menu_item_id
where order_id = (
	select TOP 1 order_id
	from order_details as od
	JOIN menu_items as mi
		on od.item_id = mi.menu_item_id
	group by order_id
	order by SUM(price) desc
);

-- =====================================================================================

-- BONUS: View the details of the top 5 highest spend orders

-- 1. top 5 highest spend orders
select TOP 5 order_id,
	sum(price) as highest_spend
from order_details as od
join menu_items as mi
	on od.item_id = mi.menu_item_id
group by order_id
order by highest_spend desc;

-- 2. details of the top 5 highest spend orders

select *
from order_details as od
join menu_items as mi
	on od.item_id = mi.menu_item_id
where order_id in (
	select TOP 5 order_id
	from order_details as od
	join menu_items as mi
		on od.item_id = mi.menu_item_id
	group by order_id
	order by SUM(price) desc
)
order by order_id asc;

-- =====================================================================================

-- FINAL QUESTION
-- how much was the most expensive order in the dataset?

select TOP 1 order_id,
	sum(price) as highest_spend
from order_details as od
join menu_items as mi
	on od.item_id = mi.menu_item_id
group by order_id
order by highest_spend desc;
