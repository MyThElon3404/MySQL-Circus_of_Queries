-- QUESTION : 1
-- 1. Population Density - You are working on a data analysis project at Deloitte where you need to analyze a dataset containing information
--about various cities. Your task is to calculate the population density of these cities, rounded to the nearest integer, and identify the cities with the minimum and maximum densities.
--The population density should be calculated as (Population / Area).
--The output should contain 'city', 'country', 'density'.

DROP TABLE IF EXISTS cities_population;
CREATE TABLE cities_population (
    city VARCHAR(50),
    country VARCHAR(50),
    population INT,
    area FLOAT
);
INSERT INTO cities_population (city, country, population, area)
VALUES
('City1', 'Country1', 100000, 50.25),
('City2', 'Country2', 150000, 75.50),
('City3', 'Country3', 200000, 100.75),

('City4', 'Country4', 120000, 60.30),
('City5', 'Country5', 180000, 90.45),
('City6', 'Country6', 220000, 110.60),

('City7', 'Country7', 130000, 65.75),
('City8', 'Country8', 160000, 80.40),
('City9', 'Country9', 190000, 95.25),

('City10', 'Country10', 140000, 70.50),
('City11', 'Country11', 170000, 85.25),
('City12', 'Country12', 210000, 105.75);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------
-- 1. SOLUTION 1
with population_density as (
	select city, country, 
	case 
		when area <> 0 then ROUND(cast(population as float)/area, 0)
		else null
	end as density
	from cities_population
)
select city, country, density
from population_density
where density = (select min(density) from population_density where density is not null)
	or density = (select max(density) from population_density where density is not null);

-- 2. SOLUTION 2
with population_density as (
	select city, country, 
	case 
		when area <> 0 then ROUND(cast(population as float)/area, 0)
		else null
	end as density
	from cities_population
)
select city, country, density, 'min_density' as density_type
from population_density
where density = (select min(density) from population_density where density is not null)
union
select city, country, density, 'max_density' as density_type
from population_density
where density = (select max(density) from population_density where density is not null)
-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Customer Feedback Analysis - Capital One's marketing team is working on a project to analyze customer feedback from their feedback surveys.
-- The team sorted the words from the feedback into three different categories;
-- • short_comments
-- • mid_length_comments
-- • long_comments
-- The team wants to find comments that are not short and that come from social media. 
-- The output should include 'feedback_id,' 'feedback_text,' 'source_channel,' and a calculated category.

DROP TABLE IF EXISTS customer_feedback;
CREATE TABLE customer_feedback (
    feedback_id INT,
    feedback_text VARCHAR(255),
    source_channel VARCHAR(50),
    comment_category VARCHAR(50)
);
INSERT INTO customer_feedback (feedback_id, feedback_text, source_channel, comment_category)
VALUES
(1, 'Great service, but the app crashes occasionally.', 'email', 'mid_length_comments'),
(2, 'Loved the friendly staff and quick response. Highly recommended.', 'survey', 'mid_length_comments'),
(3, 'Difficult to navigate the website, and customer support is slow.', 'email', 'mid_length_comments'),
(4, 'Fantastic experience with the new update!', 'email', 'mid_length_comments'),
(5, 'The app is good, but it lacks some features.', 'email', 'mid_length_comments'),
(6, 'Not satisfied with the service. It needs improvement.', 'email', 'mid_length_comments'),
(7, 'Amazing staff, very helpful and caring.', 'survey', 'short_comments'),
(8, 'The website could be more user-friendly.', 'email', 'short_comments'),
(9, 'Had some issues with billing, but they were resolved quickly.', 'social_media', 'mid_length_comments'),
(10, 'Good, but not great. The app needs more updates.', 'email', 'mid_length_comments'),
(11, 'Excellent service and prompt response.', 'social_media', 'short_comments'),
(12, 'User-friendly website and great customer support.', 'email', 'mid_length_comments'),
(13, 'I like the app, but it can be improved.', 'email', 'short_comments'),
(14, 'The new update made the app even better!', 'social_media', 'short_comments'),
(15, 'Terrible experience, the app crashes all the time.', 'social_media', 'mid_length_comments'),
(16, 'Staff is not very helpful, and the service is slow.', 'social_media', 'mid_length_comments'),
(17, 'Website navigation needs improvement.', 'survey', 'short_comments'),
(18, 'The app lacks essential features.', 'survey', 'short_comments'),
(19, 'I had a remarkable experience with the service. The staff was incredibly helpful and the response time was quick. Highly recommended for anyone looking for reliable support.', 'email', 'long_comments'),
(20, 'Navigating the website was challenging, and the customer support response time was slower than expected. Improvements in these areas would greatly enhance the user experience.', 'social_media', 'long_comments'),
(21, 'The latest app update has brought significant improvements. The user interface is now more intuitive, and I have encountered fewer issues. Keep up the good work!', 'email', 'long_comments'),
(22, 'While the app has some positive aspects, it lacks certain essential features that would greatly enhance its functionality. I hope to see these improvements in future updates.', 'survey', 'long_comments'),
(23, 'My experience with the service was less than satisfactory. The frequent app crashes were frustrating and need urgent attention. I also found the staff to be unhelpful and the service slow.', 'survey', 'long_comments'),
(24, 'The website layout could use some improvement to make it more user-friendly. Additionally, there are several missing features in the app that need to be addressed for a better user experience.', 'survey', 'long_comments'),
(25, 'App crashes frequently, needs fixing.', 'survey', 'short_comments'),
(26, 'Friendly staff but slow response time.', 'social_media', 'short_comments'),
(27, 'Website navigation is confusing.', 'survey', 'short_comments'),
(28, 'The app is missing critical features.', 'email', 'short_comments'),
(29, 'Service could be better, not fully satisfied.', 'social_media', 'mid_length_comments'),
(30, 'Great support from the staff.', 'social_media', 'short_comments'),
(31, 'Website design is intuitive and user-friendly.', 'survey', 'mid_length_comments'),
(32, 'Billing problems were resolved efficiently.', 'survey', 'mid_length_comments'),
(33, 'App needs more updates to be competitive.', 'email', 'mid_length_comments'),
(34, 'Service quality is excellent.', 'survey', 'short_comments'),
(35, 'Quick response from the support team.', 'email', 'short_comments'),
(36, 'App crashes frequently, frustrating experience.', 'social_media', 'mid_length_comments'),
(37, 'Unhelpful staff and slow service.', 'social_media', 'short_comments'),
(38, 'Website layout needs improvement.', 'social_media', 'short_comments'),
(39, 'Missing features in the app.', 'survey', 'short_comments'),
(40, 'Service needs enhancement for better satisfaction.', 'social_media', 'mid_length_comments'),
(41, 'Friendly and helpful staff members.', 'email', 'short_comments'),
(42, 'Easy-to-use website with fast support.', 'social_media', 'short_comments'),
(43, 'Billing issues were resolved to my satisfaction.', 'survey', 'mid_length_comments'),
(44, 'App updates are needed for improvement.', 'email', 'short_comments'),
(45, 'Outstanding service and support.', 'social_media', 'short_comments'),
(46, 'Responsive and efficient support team.', 'social_media', 'short_comments'),
(47, 'Frequent app crashes, needs urgent fixing.', 'social_media', 'mid_length_comments'),
(48, 'Slow response from staff, disappointing service.', 'survey', 'mid_length_comments'),
(49, 'Website navigation is not user-friendly.', 'email', 'short_comments'),
(50, 'App lacks important features.', 'survey', 'short_comments'),
(51, 'Service should be improved for better customer experience.', 'email', 'mid_length_comments');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------
select feedback_id, feedback_text,
	source_channel, comment_category
from customer_feedback
where comment_category <> 'short_comments'
	and source_channel = 'social_media'
order by feedback_id asc;

-- total number of comments that are not short and that come from social media.
with total_comments_cte as (
	select feedback_id, feedback_text,
		source_channel, comment_category
	from customer_feedback
	where comment_category <> 'short_comments'
		and source_channel = 'social_media'
)
select count(*) as total_comments
from total_comments_cte;
-- ==================================================================================================================================
