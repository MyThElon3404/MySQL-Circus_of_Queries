
-- QUESTION : 1
-- 1. (business_id, event_type) is the primary key of this table.
-- Each row in the table logs the info that an event of some type occured at some business for a number of times.
-- Write an SQL query to find all active businesses.
-- An active business is a business that has more than one event type with occurences greater than the average occurences of that event type among all businesses.

CREATE TABLE Events (
    business_id INT,
    event_type VARCHAR(50),
    occurences INT
);

INSERT INTO Events (business_id, event_type, occurences) VALUES
(1, 'reviews', 7), (3, 'reviews', 3), (1, 'ads', 11),
(2, 'ads', 7), (3, 'ads', 6), (1, 'page views', 3),
(2, 'page views', 12);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with event_type_avg as (
	select event_type as event,
		AVG(occurences) as occured_avg
	from Events
	group by event_type
),
	avg_occurence_greater as (
		select e.business_id, e.event_type
		from event_type_avg as eta
		join events as e
			on eta.event = e.event_type
		where e.occurences > eta.occured_avg
	)
select business_id
from avg_occurence_greater
group by business_id
having count(event_type) > 1;

-- ---------------------------------- OR ----------------------------------------

select e.business_id
from events as e
where occurences > (
		select avg(occurences)
		from events
		where event_type = e.event_type
	)
group by e.business_id
having count(*) > 1;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. UnitedHealth Group (UHG) has a program called Advocate4Me, which allows policy holders (or, members) to call an advocate 
-- and receive support for their health care needs – whether that's claims and benefits support, drug coverage, pre- and post-authorisation, 
-- medical records, emergency assistance, or member portal services.
-- Write a query to find how many UHG policy holders made three, or more calls, assuming each call is identified by the case_id column.

CREATE TABLE callers (
    policy_holder_id INTEGER,
    case_id VARCHAR(255),
    call_category VARCHAR(255),
    call_date TIMESTAMP,
    call_duration_secs INTEGER
);

INSERT INTO callers (policy_holder_id, case_id, call_category, call_date, call_duration_secs) 
VALUES
(1, 'f1d012f9-9d02-4966-a968-bf6c5bc9a9fe', 'emergency assistance', '2023-04-13T19:16:53Z', 144),
(1, '41ce8fb6-1ddd-4f50-ac31-07bfcce6aaab', 'authorisation', '2023-05-25T09:09:30Z', 815),
(2, '9b1af84b-eedb-4c21-9730-6f099cc2cc5e', 'claims assistance', '2023-01-26T01:21:27Z', 992),
(2, '8471a3d4-6fc7-4bb2-9fc7-4583e3638a9e', 'emergency assistance', '2023-03-09T10:58:54Z', 128),
(2, '38208fae-bad0-49bf-99aa-7842ba2e37bc', 'benefits', '2023-06-05T07:35:43Z', 619);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

SELECT policy_holder_id,
    COUNT(case_id) AS num_calls
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id) >= 3;

-- ==================================================================================================================================

-- QUESTION : 1
-- 1. CVS Health is trying to better understand its pharmacy sales, and how well different products are selling. 
-- Each drug can only be produced by one manufacturer.
-- Write a query to find the top 3 most profitable drugs sold, and how much profit they made. Assume that there are no ties in the profits.
-- Display the result from the highest to the lowest total profit.

CREATE TABLE pharmacy_sales (
    product_id INTEGER,
    units_sold INTEGER,
    total_sales DECIMAL(10, 2),
    cogs DECIMAL(10, 2),
    manufacturer VARCHAR(255),
    drug VARCHAR(255)
);

INSERT INTO pharmacy_sales (product_id, units_sold, total_sales, cogs, manufacturer, drug)
VALUES
(9, 37410, 293452.54, 208876.01, 'Eli Lilly', 'Zyprexa'),
(34, 94698, 600997.19, 521182.16, 'AstraZeneca', 'Surmontil'),
(61, 77023, 500101.61, 419174.97, 'Biogen', 'Varicose Relief'),
(136, 144814, 1084258.00, 1006447.73, 'Biogen', 'Burkhart');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

SELECT drug,
    total_sales - cogs AS profit
FROM pharmacy_sales
ORDER BY profit DESC
LIMIT 3; -- TOP 3

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. UnitedHealth Group (UHG) has a program called Advocate4Me, which allows policy holders (or, members) to call an advocate 
-- and receive support for their health care needs – whether that's claims and benefits support, drug coverage, pre- and post-authorisation, 
-- medical records, emergency assistance, or member portal services.
-- Write a query to find how many UHG policy holders made three, or more calls, assuming each call is identified by the case_id column.

CREATE TABLE callers (
    policy_holder_id INTEGER,
    case_id VARCHAR(255),
    call_category VARCHAR(255),
    call_date TIMESTAMP,
    call_duration_secs INTEGER
);

INSERT INTO callers (policy_holder_id, case_id, call_category, call_date, call_duration_secs) 
VALUES
(1, 'f1d012f9-9d02-4966-a968-bf6c5bc9a9fe', 'emergency assistance', '2023-04-13T19:16:53Z', 144),
(1, '41ce8fb6-1ddd-4f50-ac31-07bfcce6aaab', 'authorisation', '2023-05-25T09:09:30Z', 815),
(2, '9b1af84b-eedb-4c21-9730-6f099cc2cc5e', 'claims assistance', '2023-01-26T01:21:27Z', 992),
(2, '8471a3d4-6fc7-4bb2-9fc7-4583e3638a9e', 'emergency assistance', '2023-03-09T10:58:54Z', 128),
(2, '38208fae-bad0-49bf-99aa-7842ba2e37bc', 'benefits', '2023-06-05T07:35:43Z', 619);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

SELECT policy_holder_id,
    COUNT(case_id) AS num_calls
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id) >= 3;

-- ==================================================================================================================================
