-- QUESTION : 1
-- 1. You're tasked with analyzing a Spotify-like dataset that captures user listening habits.
-- For each user, calculate the total listening time and the count of unique songs they've listened to. 
-- In the database duration values are displayed in seconds. Round the total listening duration to the nearest whole minute.
-- The output should contain three columns: 'user_id', 'total_listen_duration', and 'unique_song_count'.
DROP TABLE IF EXISTS listening_habits;
CREATE TABLE listening_habits (
    user_id INT,
    song_id INT,
    listen_duration FLOAT
);
INSERT INTO listening_habits (user_id, song_id, listen_duration) 
VALUES
(101, 5001, 240), (101, 5002, 0), (102, 5001, 300),
(102, 5003, 0), (101, 5001, 240), (103, 5004, 180),
(104, 5005, 360), (104, 5006, 0), (105, 5007, 210),
(103, 5004, 180), (106, 5008, 200), (107, 5009, 220),
(108, 5010, 250), (108, 5006, 260), (109, 5011, 0);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------
select user_id,
	ROUND(sum(listen_duration)/60, 0) as listening_duration,
	count(distinct song_id) as unique_songs
from listening_habits
group by user_id;
-- ==================================================================================================================================

-- QUESTION : 2
-- 2. For each week, find the total number of orders. Include only the orders that are from the first quarter of 2023 and stage is 'received'.
-- The output should contain 'week' and 'quantity'.
DROP TABLE IF EXISTS orders_analysis;
CREATE TABLE orders_analysis (
    stage_of_order VARCHAR(50),
    week DATE,
    quantity INT
);
INSERT INTO orders_analysis (stage_of_order, week, quantity)
VALUES
('received', '2023-01-02', 100), ('shipped', '2023-01-02', 101), ('ordered', '2023-01-02', 102), ('received', '2023-01-09', 103),
('shipped', '2023-01-09', 104), ('ordered', '2023-01-09', 105), ('received', '2023-01-16', 106), ('shipped', '2023-01-16', 107),
('ordered', '2023-01-16', 108), ('received', '2023-01-23', 109), ('shipped', '2023-01-23', 110), ('ordered', '2023-01-23', 111),
('received', '2023-01-30', 112), ('shipped', '2023-01-30', 113), ('ordered', '2023-01-30', 114), ('received', '2023-02-06', 115),
('shipped', '2023-02-06', 116), ('ordered', '2023-02-06', 117), ('received', '2023-02-13', 118), ('shipped', '2023-02-13', 119),
('ordered', '2023-02-13', 120), ('received', '2023-02-20', 121), ('shipped', '2023-02-20', 122), ('ordered', '2023-02-20', 123),
('received', '2023-02-27', 124), ('shipped', '2023-02-27', 125), ('ordered', '2023-02-27', 126), ('received', '2023-03-06', 127),
('shipped', '2023-03-06', 128), ('ordered', '2023-03-06', 129), ('received', '2023-03-13', 130), ('shipped', '2023-03-13', 131),
('ordered', '2023-03-13', 132), ('received', '2023-03-20', 133), ('shipped', '2023-03-20', 134), ('ordered', '2023-03-20', 135),
('received', '2023-03-27', 136), ('shipped', '2023-03-27', 137), ('ordered', '2023-03-27', 138), ('received', '2023-04-03', 139),
('shipped', '2023-04-03', 140), ('ordered', '2023-04-03', 141), ('received', '2023-04-10', 142), ('shipped', '2023-04-10', 143),
('ordered', '2023-04-10', 144), ('received', '2023-04-17', 145), ('shipped', '2023-04-17', 146), ('ordered', '2023-04-17', 147),
('received', '2023-04-24', 148), ('shipped', '2023-04-24', 149), ('ordered', '2023-04-24', 100), ('received', '2023-05-01', 101),
('shipped', '2023-05-01', 102), ('ordered', '2023-05-01', 103), ('received', '2023-05-08', 104), ('shipped', '2023-05-08', 105),
('ordered', '2023-05-08', 106), ('received', '2023-05-15', 107), ('shipped', '2023-05-15', 108), ('ordered', '2023-05-15', 109),
('received', '2023-05-22', 110), ('shipped', '2023-05-22', 111), ('ordered', '2023-05-22', 112), ('received', '2023-05-29', 113),
('shipped', '2023-05-29', 114), ('ordered', '2023-05-29', 115), ('received', '2023-06-05', 116), ('shipped', '2023-06-05', 117),
('ordered', '2023-06-05', 118), ('received', '2023-06-12', 119), ('shipped', '2023-06-12', 120), ('ordered', '2023-06-12', 121),
('received', '2023-06-19', 122), ('shipped', '2023-06-19', 123), ('ordered', '2023-06-19', 124), ('received', '2023-06-26', 125),
('shipped', '2023-06-26', 126), ('ordered', '2023-06-26', 127), ('received', '2023-07-03', 128), ('shipped', '2023-07-03', 129),
('ordered', '2023-07-03', 130), ('received', '2023-07-10', 131), ('shipped', '2023-07-10', 132), ('ordered', '2023-07-10', 133),
('received', '2023-07-17', 134), ('shipped', '2023-07-17', 135), ('ordered', '2023-07-17', 136), ('received', '2023-07-24', 137),
('shipped', '2023-07-24', 138), ('ordered', '2023-07-24', 139), ('received', '2023-07-31', 140), ('shipped', '2023-07-31', 141),
('ordered', '2023-07-31', 142), ('received', '2023-08-07', 143), ('shipped', '2023-08-07', 144), ('ordered', '2023-08-07', 145),
('received', '2023-08-14', 146), ('shipped', '2023-08-14', 147), ('ordered', '2023-08-14', 148), ('received', '2023-08-21', 149),
('shipped', '2023-08-21', 100), ('ordered', '2023-08-21', 101), ('received', '2023-08-28', 102), ('shipped', '2023-08-28', 103),
('ordered', '2023-08-28', 104), ('received', '2023-09-04', 105), ('shipped', '2023-09-04', 106), ('ordered', '2023-09-04', 107),
('received', '2023-09-11', 108), ('shipped', '2023-09-11', 109), ('ordered', '2023-09-11', 110), ('received', '2023-09-18', 111),
('shipped', '2023-09-18', 112), ('ordered', '2023-09-18', 113), ('received', '2023-09-25', 114), ('shipped', '2023-09-25', 115),
('ordered', '2023-09-25', 116), ('received', '2023-10-02', 117), ('shipped', '2023-10-02', 118), ('ordered', '2023-10-02', 119),
('received', '2023-10-09', 120), ('shipped', '2023-10-09', 121), ('ordered', '2023-10-09', 122), ('received', '2023-10-16', 123),
('shipped', '2023-10-16', 124), ('ordered', '2023-10-16', 125), ('received', '2023-10-23', 126), ('shipped', '2023-10-23', 127),
('ordered', '2023-10-23', 128), ('received', '2023-10-30', 129), ('shipped', '2023-10-30', 130), ('ordered', '2023-10-30', 131),
('received', '2023-11-06', 132), ('shipped', '2023-11-06', 133), ('ordered', '2023-11-06', 134), ('received', '2023-11-13', 135),
('shipped', '2023-11-13', 136), ('ordered', '2023-11-13', 137), ('received', '2023-11-20', 138), ('shipped', '2023-11-20', 139),
('ordered', '2023-11-20', 140), ('received', '2023-11-27', 141), ('shipped', '2023-11-27', 142), ('ordered', '2023-11-27', 143),
('received', '2023-12-04', 144), ('shipped', '2023-12-04', 145), ('ordered', '2023-12-04', 146), ('received', '2023-12-11', 147),
('shipped', '2023-12-11', 148), ('ordered', '2023-12-11', 149), ('received', '2023-12-18', 100), ('shipped', '2023-12-18', 101),
('ordered', '2023-12-18', 102), ('received', '2023-12-25', 103), ('shipped', '2023-12-25', 104), ('ordered', '2023-12-25', 105),
('shipped', '2023-01-23', 110), ('ordered', '2023-02-13', 120), ('received', '2023-03-13', 130);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

select week,
	sum(quantity) as weekly_total_quantity
from orders_analysis
where week >= '2023-01-01'
	and week <= '2023- 03-31'
	and stage_of_order = 'received' -- here you can take any stage value or remove stage for all weekly_total_quantity
group by week
order by weekly_total_quantity desc;
-- ==================================================================================================================================
