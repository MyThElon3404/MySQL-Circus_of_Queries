-- QUESTION : 1
-- 1. CVS Health is trying to better understand its pharmacy sales, and how well different products are selling. Each drug can only be produced by one manufacturer.
-- Write a query to find the top 3 most profitable drugs sold, and how much profit they made. Assume that there are no ties in the profits. ----- Display the result from the highest to the lowest total profit.

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
-- 2. UnitedHealth Group (UHG) has a program called Advocate4Me, which allows policy holders (or, members) to call an advocate and receive support for their health care needs – whether that's claims and benefits support, drug coverage, pre- and post-authorisation, medical records, emergency assistance, or member portal services.
-- Write a query to find how many UHG policy holders made three, or more calls, assuming each call is identified by the case_id column.

CREATE TABLE callers (
    policy_holder_id INTEGER,
    case_id VARCHAR(255),
    call_category VARCHAR(255),
    call_date TIMESTAMP,
    call_duration_secs INTEGER
);
INSERT INTO callers (policy_holder_id, case_id, call_category, call_date, call_duration_secs) VALUES
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
