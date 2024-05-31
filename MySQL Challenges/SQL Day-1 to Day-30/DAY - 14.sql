-- QUESTION : 1
-- 1. Assume you're given a table containing job postings from various companies on the LinkedIn platform. 
-- Write a query to retrieve the count of companies that have posted duplicate job listings.

-- Definition: Duplicate job listings are defined as two job listings within the same company that share identical titles and descriptions.

drop table if exists job_listings;
CREATE TABLE job_listings (
    job_id INTEGER PRIMARY KEY,
    company_id INTEGER,
    title VARCHAR(60),
    description VARCHAR(MAX)
);

INSERT INTO job_listings (job_id, company_id, title, description)
VALUES
    (248, 827, 'Business Analyst', 'Business analyst evaluates past and current business data with the primary goal of improving decision-making processes within organizations.'),
    (149, 845, 'Business Analyst', 'Business analyst evaluates past and current business data with the primary goal of improving decision-making processes within organizations.'),
    (945, 345, 'Data Analyst', 'Data analyst reviews data to identify key insights into a business''s customers and ways the data can be used to solve problems.'),
    (164, 345, 'Data Analyst', 'Data analyst reviews data to identify key insights into a business''s customers and ways the data can be used to solve problems.'),
    (172, 244, 'Data Engineer', 'Data engineer works in a variety of settings to build systems that collect, manage, and convert raw data into usable information for data scientists and business analysts to interpret.'),
    (573, 456, 'Software Engineer', 'Software engineer designs, develops, tests, and maintains software applications.'),
    (324, 789, 'Software Engineer', 'Software engineer designs, develops, tests, and maintains software applications.'),
    (890, 123, 'Data Scientist', 'Data scientist analyzes and interprets complex data to help organizations make informed decisions.'),
    (753, 123, 'Data Scientist', 'Data scientist analyzes and interprets complex data to help organizations make informed decisions.');

select * from job_listings;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with duplicate_jobs as (
	select company_id, title, description,
		count(*) as job_count
	from job_listings
	group by company_id, title, description
	having count(*) > 1
)
-- Companies who posted duplicate jobs
select distinct(company_id) as dublicate_job_by_comapany
from duplicate_jobs;

-- No. of companies who posted dublicate jobs
select count(distinct(company_id)) as no_of_posted_duplicate_job
from duplicate_jobs;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2.  Write a query to calculate the year-over-year growth rate of the amount spent by each customer.

drop table if exists customer_purchases;
CREATE TABLE customer_purchases (
    Customer_id VARCHAR(20),
    Product_id VARCHAR(20),
    Purchase_amount DECIMAL(10, 2),
    Purchase_date DATE
);

INSERT INTO customer_purchases (Customer_id, Product_id, Purchase_amount, Purchase_date) 
VALUES
	('C001', 'P001', 100.00, '2020-05-01'),('C001', 'P002', 150.00, '2021-05-01'),
	('C001', 'P003', 200.00, '2022-05-01'),('C001', 'P004', 250.00, '2023-05-01'),
	('C002', 'P001', 200.00, '2020-06-01'),('C002', 'P002', 300.00, '2021-06-01'),
	('C002', 'P003', 400.00, '2022-06-01'),('C002', 'P004', 500.00, '2023-06-01'),
	('C003', 'P001', 300.00, '2020-07-01'),('C003', 'P002', 450.00, '2021-07-01'),
	('C003', 'P003', 600.00, '2022-07-01'),('C003', 'P004', 750.00, '2023-07-01'),
	('C004', 'P001', 400.00, '2020-08-01'),('C004', 'P002', 600.00, '2021-08-01'),
	('C004', 'P003', 800.00, '2022-08-01'),('C004', 'P004', 1000.00, '2023-08-01'),
	('C005', 'P001', 500.00, '2020-09-01'),('C005', 'P002', 750.00, '2021-09-01'),
	('C005', 'P003', 1000.00, '2022-09-01'),('C005', 'P004', 1250.00, '2023-09-01');

select * from customer_purchases;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with total_yearly_purchase as (
	select Customer_id,
		YEAR(Purchase_date) as purchase_year,
		sum(Purchase_amount) as total_purchase
	from customer_purchases
	group by Customer_id, YEAR(Purchase_date)
),
	yoy_growth as (
		select Customer_id, purchase_year, total_purchase,
			lag(total_purchase) over(partition by Customer_id order by purchase_year) as prev_year_purchase
		from total_yearly_purchase
)

select Customer_id, purchase_year,
	case
		when prev_year_purchase is null then null
		else round(((total_purchase - prev_year_purchase)/prev_year_purchase) * 100, 2)
	end as yoy_growth_rate
from yoy_growth
order by Customer_id, purchase_year;

-- ==================================================================================================================================
