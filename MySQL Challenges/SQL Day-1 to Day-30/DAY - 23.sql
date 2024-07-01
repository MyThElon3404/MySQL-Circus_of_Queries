-- QUESTION : 1
-- 1. Given a table of tweet data over a specified time period, calculate the 3-day rolling average of tweets for each user. 
-- Output the user ID, tweet date, and rolling averages rounded to 2 decimal places.
-- Notes:
	-- 1. A rolling average, also known as a moving average or running mean is a time-series technique that examines trends 
		-- in data over a specified period of time.
	-- 2. In this case, we want to determine how the tweet count for each user changes over a 3-day period. 

DROP TABLE IF EXISTS tweets;
CREATE TABLE tweets (
    user_id INTEGER,
    tweet_date DATETIME,
    tweet_count INTEGER
);
INSERT INTO tweets (user_id, tweet_date, tweet_count) 
VALUES
(111, '2022-06-01 00:00:00', 2),
(111, '2022-06-02 00:00:00', 1),
(111, '2022-06-03 00:00:00', 3),
(111, '2022-06-04 00:00:00', 4),
(111, '2022-06-05 00:00:00', 5),
(111, '2022-06-06 00:00:00', 4),
(111, '2022-06-07 00:00:00', 6),
(199, '2022-06-01 00:00:00', 7),
(199, '2022-06-02 00:00:00', 5),
(199, '2022-06-03 00:00:00', 9),
(199, '2022-06-04 00:00:00', 1),
(199, '2022-06-05 00:00:00', 8),
(199, '2022-06-06 00:00:00', 2),
(199, '2022-06-07 00:00:00', 2),
(254, '2022-06-01 00:00:00', 1),
(254, '2022-06-02 00:00:00', 1),
(254, '2022-06-03 00:00:00', 2),
(254, '2022-06-04 00:00:00', 1),
(254, '2022-06-05 00:00:00', 3),
(254, '2022-06-06 00:00:00', 1),
(254, '2022-06-07 00:00:00', 3);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1 - Using a Common Table Expression (CTE)
SELECT user_id, tweet_date,
  ROUND(AVG(tweet_count)
    OVER(PARTITION BY user_id ORDER BY tweet_date
      ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) as rolling_avg
FROM tweets;

-- SOLUTION 2 - Using a Self-Join
SELECT 
    t1.user_id,
    t1.tweet_date,
    ROUND(AVG(t2.tweet_count), 2) AS rolling_avg
FROM tweets t1
JOIN tweets t2 
	ON t1.user_id = t2.user_id
    AND t2.tweet_date BETWEEN DATEADD(DAY, -2, t1.tweet_date) AND t1.tweet_date
GROUP BY t1.user_id, t1.tweet_date
ORDER BY t1.user_id, t1.tweet_date;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Assume you're given a table containing data on Amazon customers and their spending on products in different category, 
-- write a query to identify the top two highest-grossing products within each category in the year 2022. 
-- The output should include the category, product, and total spend.

DROP TABLE IF EXISTS product_spend;
CREATE TABLE product_spend (
    category VARCHAR(50),
    product VARCHAR(50),
    user_id INTEGER,
    spend DECIMAL(10, 2),
    transaction_date DATETIME
);
INSERT INTO product_spend (category, product, user_id, spend, transaction_date) 
VALUES
('appliance', 'refrigerator', 165, 246.00, '2021-12-26 12:00:00'),
('appliance', 'refrigerator', 123, 299.99, '2022-03-02 12:00:00'),
('appliance', 'washing machine', 123, 219.80, '2022-03-02 12:00:00'),
('electronics', 'vacuum', 178, 152.00, '2022-04-05 12:00:00'),
('electronics', 'wireless headset', 156, 249.90, '2022-07-08 12:00:00'),
('electronics', 'vacuum', 145, 189.00, '2022-07-15 12:00:00');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with customer_product as (
  SELECT category, product,
    sum(spend) as total_spend,
    row_number() 
      OVER(PARTITION BY category ORDER BY sum(spend) DESC)
      as product_rn
  FROM product_spend
  WHERE EXTRACT(year FROM transaction_date) = 2022
  GROUP BY category, product
)
SELECT category, product, total_spend
FROM customer_product
WHERE product_rn <= 2;

-- ==================================================================================================================================
