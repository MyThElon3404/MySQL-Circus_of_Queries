-- QUESTION : 1
-- 1. Given the customer_purchases and product_list tables, Write a query to calculate the year-over-year growth rate of the 
-- amount spent by each customer (for year 2023 and 2024).
DROP TABLE IF exists customer_purchases;
CREATE TABLE customer_purchases (
    Customer_id VARCHAR(20),
    Product_id VARCHAR(20),
    Purchase_amount DECIMAL(10,2),
    Purchase_date DATE
);
INSERT INTO customer_purchases 
VALUES
    ('Cust1', 'P1', 200.00, '2022-12-20'),  -- Previous year for Cust1
    ('Cust1', 'P2', 180.00, '2023-01-05'),
    ('Cust1', 'P1', 300.00, '2023-07-10'),
    ('Cust1', 'P2', 250.00, '2024-02-15'),
    ('Cust2', 'P3', 150.00, '2022-11-25'),  -- Previous year for Cust2
    ('Cust2', 'P1', 200.00, '2023-03-15'),
    ('Cust2', 'P3', 280.00, '2023-06-20'),
    ('Cust2', 'P1', 320.00, '2024-01-10'),
    ('Cust3', 'P2', 120.00, '2023-12-01'),  -- Previous year for Cust3
    ('Cust3', 'P3', 200.00, '2024-04-05'),
    ('Cust3', 'P2', 180.00, '2024-06-25');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with cust_yearly_spending as (
	select Customer_id,
		YEAR(Purchase_date) as purchase_year,
		sum(purchase_amount) as total_spend
	from customer_purchases
	group by Customer_id,
		YEAR(Purchase_date)
)
select curr.Customer_id,
	curr.purchase_year as curent_year,
	curr.total_spend as curr_year_spending,
	prev.total_spend as prev_year_spending,
	ROUND(((curr.total_spend - prev.total_spend) / 
		prev.total_spend) * 100.0, 2) as  YoY_growth_rate
from cust_yearly_spending as curr
left join cust_yearly_spending as prev
	on curr.Customer_id = prev.Customer_id
	and curr.purchase_year = prev.purchase_year + 1;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. 

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------


-- ==================================================================================================================================
