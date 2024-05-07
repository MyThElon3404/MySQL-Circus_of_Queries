-- QUESTION : 1
-- 1. Write a query to identify the top two highest-grossing products 
-- within each category in the year 2022. 
-- Output should include the category, product, and total spend.

drop table if exists product_spend;
CREATE TABLE product_spend (
    category VARCHAR(255),
    product VARCHAR(255),
    user_id INTEGER,
    spend DECIMAL(10, 2),
    transaction_date DATETIME
);

-- Insert sample records
INSERT INTO product_spend (category, product, user_id, spend, transaction_date) 
VALUES
('appliance', 'refrigerator', 165, 246.00, '2021-12-26 12:00:00'),
('appliance', 'refrigerator', 123, 299.99, '2022-03-02 12:00:00'),
('appliance', 'washing machine', 123, 219.80, '2022-03-02 12:00:00'),
('electronics', 'vacuum', 178, 152.00, '2022-04-05 12:00:00'),
('electronics', 'wireless headset', 156, 249.90, '2022-07-08 12:00:00'),
('electronics', 'vacuum', 145, 189.00, '2022-07-15 12:00:00');

select * from product_spend;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with product_spend_cte as (
  select category, product,
    sum(spend) as total_spend,
    row_number() over(partition by category order by sum(spend) desc) as product_rn
  from product_spend
  where year(transaction_date) = '2022'
  group by category, product
)
select category, product, total_spend
from product_spend_cte
where product_rn <= 2;

-- ==================================================================================================================================
