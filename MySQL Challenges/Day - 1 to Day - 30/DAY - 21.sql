-- QUESTION : 1
-- 1. You are provided with a transactional dataset from Amazon that contains detailed information about sales across different 
-- products and marketplaces. Your task is to list the top 3 sellers in each product category for January.
-- The output should contain 'seller_id' , 'total_sales' ,'product_category' , 'market_place', and 'month'.
DROP TABLE IF EXISTS sales_data;
CREATE TABLE sales_data (
    seller_id VARCHAR(50),
    total_sales FLOAT,
    product_category VARCHAR(50),
    market_place VARCHAR(50),
    month DATETIME
);
INSERT INTO sales_data (seller_id, total_sales, product_category, market_place, month) 
VALUES
('s236', 36486.73, 'electronics', 'in', '2024-01-01'),
('s918', 24286.4, 'books', 'uk', '2024-01-01'),
('s163', 18846.34, 'electronics', 'us', '2024-01-01'),
('s836', 35687.65, 'electronics', 'uk', '2024-01-01'),
('s790', 31050.13, 'clothing', 'in', '2024-01-01'),
('s195', 14299, 'books', 'de', '2024-01-01'),
('s483', 49361.62, 'clothing', 'uk', '2024-01-01'),
('s891', 48847.68, 'electronics', 'de', '2024-01-01'),
('s272', 11324.61, 'toys', 'us', '2024-01-01'),
('s712', 43739.86, 'toys', 'in', '2024-01-01'),
('s968', 36042.66, 'electronics', 'jp', '2024-01-01'),
('s728', 29158.51, 'books', 'us', '2024-01-01'),
('s415', 24593.5, 'electronics', 'uk', '2024-01-01'),
('s454', 35520.67, 'toys', 'in', '2024-01-01'),
('s560', 27320.16, 'electronics', 'jp', '2024-01-01'),
('s486', 37009.18, 'electronics', 'us', '2024-01-01'),
('s749', 36277.83, 'toys', 'de', '2024-01-01'),
('s798', 31162.45, 'electronics', 'in', '2024-01-01'),
('s515', 26372.16, 'toys', 'in', '2024-01-01'),
('s662', 22157.87, 'books', 'in', '2024-01-01'),
('s919', 24963.97, 'toys', 'de', '2024-01-01'),
('s863', 46652.67, 'electronics', 'us', '2024-01-01'),
('s375', 18107.08, 'clothing', 'de', '2024-01-01'),
('s583', 20268.34, 'toys', 'jp', '2024-01-01'),
('s778', 19962.89, 'electronics', 'in', '2024-01-01'),
('s694', 36519.05, 'electronics', 'in', '2024-01-01'),
('s214', 18948.55, 'electronics', 'de', '2024-01-01'),
('s830', 39169.01, 'toys', 'us', '2024-01-01'),
('s383', 12310.73, 'books', 'in', '2024-01-01'),
('s195', 45633.35, 'books', 'de', '2024-01-01'),
('s196', 13643.27, 'books', 'jp', '2024-01-01'),
('s796', 19637.44, 'electronics', 'jp', '2024-01-01'),
('s334', 11999.1, 'clothing', 'de', '2024-01-01'),
('s217', 23481.03, 'books', 'in', '2024-01-01'),
('s123', 36277.83, 'toys', 'uk', '2024-01-01'),
('s383', 17337.392, 'electronics', 'de', '2024-02-01'),
('s515', 13998.997, 'electronics', 'jp', '2024-02-01'),
('s583', 36035.539, 'books', 'jp', '2024-02-01'),
('s195', 18493.564, 'toys', 'de', '2024-02-01'),
('s728', 34466.126, 'electronics', 'de', '2024-02-01'),
('s830', 48950.221, 'electronics', 'us', '2024-02-01'),
('s483', 16820.965, 'electronics', 'uk', '2024-02-01'),
('s778', 48625.281, 'toys', 'in', '2024-02-01'),
('s918', 37369.321, 'clothing', 'de', '2024-02-01'),
('s123', 46372.816, 'electronics', 'uk', '2024-02-01');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with product_sale as (
	select *,
		ROW_NUMBER() 
			over(partition by product_category order by total_sales desc) as rn
	from sales_data
	where month = '2024-01-01'
)
select seller_id, total_sales, product_category,
	market_place, month
from product_sale
where rn <= 3;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. You are given a dataset from Amazon that tracks and aggregates user activity on their platform in certain time periods. 
-- For each device type, find the time period with the highest number of active users.
-- The output should contain 'user_count', 'time_period', and 'device_type', where 'time_period' 
-- is a concatenation of 'start_timestamp' and 'end_timestamp', like ; "start_timestamp to end_timestamp".
DROP TABLE IF EXISTS user_activity;
CREATE TABLE user_activity (
    start_timestamp DATETIME,
    end_timestamp DATETIME,
    user_count INT,
    device_type VARCHAR(50),
    time_difference FLOAT
);
INSERT INTO user_activity (start_timestamp, end_timestamp, user_count, device_type, time_difference) VALUES
('2024-01-25 03:32:00', '2024-01-25 04:31:00', 64, 'desktop', 59),
('2024-01-25 15:43:00', '2024-01-25 16:40:00', 71, 'desktop', 57),
('2024-01-25 02:32:00', '2024-01-25 02:48:00', 78, 'mobile', 16),
('2024-01-25 00:45:00', '2024-01-25 02:21:00', 23, 'mobile', 96),
('2024-01-25 16:30:00', '2024-01-25 18:05:00', 2, 'desktop', 95),
('2024-01-25 21:45:00', '2024-01-25 23:34:00', 70, 'desktop', 109),
('2024-01-25 10:16:00', '2024-01-25 10:34:00', 59, 'desktop', 18),
('2024-01-25 15:09:00', '2024-01-25 16:16:00', 81, 'desktop', 67),
('2024-01-25 21:56:00', '2024-01-25 23:53:00', 29, 'mobile', 117),
('2024-01-25 07:57:00', '2024-01-25 08:21:00', 9, 'desktop', 24),
('2024-01-25 03:27:00', '2024-01-25 04:15:00', 50, 'mobile', 48),
('2024-01-25 14:10:00', '2024-01-25 14:46:00', 88, 'desktop', 36),
('2024-01-25 13:14:00', '2024-01-25 14:18:00', 90, 'mobile', 64),
('2024-01-25 16:31:00', '2024-01-25 17:25:00', 70, 'mobile', 54),
('2024-01-25 04:38:00', '2024-01-25 05:08:00', 68, 'desktop', 30),
('2024-01-25 14:09:00', '2024-01-25 15:15:00', 89, 'mobile', 66),
('2024-01-25 22:24:00', '2024-01-25 23:12:00', 55, 'desktop', 48),
('2024-01-25 17:36:00', '2024-01-25 18:15:00', 46, 'desktop', 39),
('2024-01-25 05:16:00', '2024-01-25 06:38:00', 83, 'desktop', 82),
('2024-01-25 08:21:00', '2024-01-25 08:49:00', 14, 'desktop', 28),
('2024-01-25 22:31:00', '2024-01-25 22:59:00', 26, 'mobile', 28),
('2024-01-25 08:21:00', '2024-01-25 09:27:00', 72, 'desktop', 66),
('2024-01-25 08:29:00', '2024-01-25 08:49:00', 59, 'mobile', 20),
('2024-01-25 20:07:00', '2024-01-25 21:05:00', 43, 'desktop', 58),
('2024-01-25 13:38:00', '2024-01-25 14:30:00', 98, 'mobile', 52),
('2024-01-25 14:47:00', '2024-01-25 15:54:00', 81, 'mobile', 67),
('2024-01-25 04:47:00', '2024-01-25 06:15:00', 61, 'desktop', 88),
('2024-01-25 09:13:00', '2024-01-25 11:04:00', 32, 'mobile', 111),
('2024-01-25 19:12:00', '2024-01-25 21:07:00', 52, 'desktop', 115),
('2024-01-25 01:49:00', '2024-01-25 03:09:00', 84, 'mobile', 80),
('2024-01-25 03:48:00', '2024-01-25 04:07:00', 21, 'mobile', 19),
('2024-01-25 11:50:00', '2024-01-25 13:25:00', 96, 'desktop', 95),
('2024-01-25 14:19:00', '2024-01-25 15:15:00', 25, 'mobile', 56),
('2024-01-25 15:29:00', '2024-01-25 17:17:00', 4, 'mobile', 108),
('2024-01-25 15:49:00', '2024-01-25 16:03:00', 95, 'mobile', 14),
('2024-01-25 22:38:00', '2024-01-26 00:04:00', 14, 'mobile', 86),
('2024-01-25 06:28:00', '2024-01-25 08:27:00', 77, 'mobile', 119),
('2024-01-25 00:09:00', '2024-01-25 01:51:00', 10, 'mobile', 102),
('2024-01-25 23:06:00', '2024-01-25 23:32:00', 5, 'mobile', 26),
('2024-01-25 18:11:00', '2024-01-25 18:37:00', 92, 'mobile', 26),
('2024-01-25 15:10:00', '2024-01-25 16:06:00', 48, 'desktop', 56),
('2024-01-25 19:06:00', '2024-01-25 20:58:00', 74, 'mobile', 112),
('2024-01-25 01:09:00', '2024-01-25 01:40:00', 85, 'desktop', 31),
('2024-01-25 16:08:00', '2024-01-25 17:28:00', 41, 'desktop', 80),
('2024-01-25 12:20:00', '2024-01-25 13:19:00', 80, 'desktop', 59),
('2024-01-25 15:18:00', '2024-01-25 15:47:00', 40, 'desktop', 29),
('2024-01-25 07:31:00', '2024-01-25 08:25:00', 60, 'desktop', 54),
('2024-01-25 00:11:00', '2024-01-25 00:27:00', 99, 'mobile', 16),
('2024-01-25 22:39:00', '2024-01-25 23:45:00', 35, 'mobile', 66),
('2024-01-25 16:47:00', '2024-01-25 18:41:00', 5, 'desktop', 114),
('2024-01-25 05:54:00', '2024-01-25 07:43:00', 29, 'desktop', 109),
('2024-01-25 05:01:00', '2024-01-25 05:29:00', 3, 'desktop', 28),
('2024-01-25 08:03:00', '2024-01-25 08:24:00', 66, 'desktop', 21);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with active_user_timestamp as (
	select device_type,
		CONCAT(start_timestamp, ' to ', end_timestamp) as time_period,
		user_count,
		ROW_NUMBER()
			over (partition by device_type order by user_count desc) rn
	from user_activity
)
select device_type, time_period, user_count
from active_user_timestamp
where rn = 1
order by user_count;
-- ==================================================================================================================================
