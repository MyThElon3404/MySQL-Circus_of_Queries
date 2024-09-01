# Sales for Retail and Food Services in U.S.A.

---------------------------------------------------------------------------------------------------------------------------------------

- ### Overview :
This project delves into the dynamic world of Retail and Food Services in the U.S.A., leveraging data directly sourced from the U.S. government. By harnessing the power of SQL, we've meticulously crafted a robust database, enabling seamless management and in-depth analysis. Our primary focus lies in uncovering key insights by exploring sales data through the lens of the NAICS (North American Industry Classification System) codes and categories, offering a comprehensive view of industry trends and performance.

---------------------------------------------------------------------------------------------------------------------------------------

- ### Dataset Overview :
The dataset driving this project offers a comprehensive look at historical sales data for Retail and Food Services across the U.S.A. Sourced from the U.S. government website, this dataset is a cornerstone of reliability and accuracy. It encapsulates crucial information, including NAICS codes, business categories, sales figures, geographical regions, and time periods (e.g., monthly or yearly), enabling a nuanced analysis of industry trends.

|Column Name |	Data Type	 | Remarks |
|------------|-------------|---------|
|id	       | Integer | Primary Key
|month	 | Integer |	NOT NULL 
|year	   | Integer | NOT NULL
|naics_Code	       | Integer | NOT NULL
|kind_of_business | VARCHAR(50) | NOT NULL
|industry	 | VARCHAR(50) |	NOT NULL 
|sales	   | float | CAN BE NULL

![image](https://github.com/user-attachments/assets/b8312e2c-099a-4ba1-a5ba-9399a5bfcb45)


---------------------------------------------------------------------------------------------------------------------------------------
## QUESTIONS & ANSWERS :
---------------------------------------------------------------------------------------------------------------------------------------

- Q1. 1. Top-performing industries in terms of sales for a year 2021, and how do their sales compare month-over-month?
``` sql
with monthly_sales as (
	select month, year, industry,
		SUM(sales) as total_sales
	from retail_sales
	where year = 2021
	group by month, year, industry
),
	industries_performance as (
		select *,
			RANK() over(partition by month, year order by total_sales desc) as sales_rn
		from monthly_sales
	)
select *
from industries_performance
where sales_rn = 1
order by total_sales desc;
```
- SAMPLE ANSWER :

![image](https://github.com/user-attachments/assets/5740da8e-09b4-4e28-91e5-2484a6c55ab2)

- Q1. 2. Top-performing industries in terms of sales for a year 2022, and how do their sales compare month-over-month?
``` sql
with monthly_sales as (
	select month, year, industry,
		SUM(sales) as total_sales
	from retail_sales
	where year = 2022
	group by month, year, industry
),
	industries_performance as (
		select *,
			RANK() over(partition by month, year order by total_sales desc) as sales_rn
		from monthly_sales
	)
select *
from industries_performance
where sales_rn = 1
order by total_sales desc;
```
- SAMPLE ANSWER :

![image](https://github.com/user-attachments/assets/8758093f-3e29-4ab6-b184-d0288de48280)

- Q1. 3. Top-performing industries in terms of sales for a year 2020, and how do their sales compare month-over-month?
``` sql
with monthly_sales as (
	select month, year, industry,
		SUM(sales) as total_sales
	from retail_sales
	where year = 2020
	group by month, year, industry
),
	industries_performance as (
		select *,
			RANK() over(partition by month, year order by total_sales desc) as sales_rn
		from monthly_sales
	)
select *
from industries_performance
where sales_rn = 1
order by total_sales desc;
```
- SAMPLE ANSWER :

![image](https://github.com/user-attachments/assets/b00fa71f-2f53-467b-a0de-e0c3b0e6496a)

- Like this you can calculate `Top-performing industries in terms of sales` for any year.

---------------------------------------------------------------------------------------------------------------------------------------

- Q2. Which specific kind of businesses contribute the most to total sales, and it's belongs to which industries?
``` sql
WITH ts_cte AS (
    SELECT SUM(sales) AS total_sales
    FROM retail_sales
),
business_wise_total_sales AS (
    SELECT kind_of_business,
           SUM(sales) AS business_total_sales
    FROM retail_sales
    GROUP BY kind_of_business
),
most_contributer_business AS (
    SELECT TOP 1 kind_of_business,
           business_total_sales,
           total_sales,
           ROUND((business_total_sales * 100.0 / total_sales), 2) AS business_contribe
    FROM ts_cte
    JOIN business_wise_total_sales
        ON 1 = 1
	ORDER BY business_contribe DESC
)
SELECT distinct b.industry, a.kind_of_business,
	a.business_total_sales, a.business_contribe
FROM most_contributer_business as a
JOIN retail_sales as b
	ON a.kind_of_business = b.kind_of_business;
```
- SAMPLE ANSWER :

![image](https://github.com/user-attachments/assets/00347ad6-91d2-441f-8f0c-9607dfc08402)

---------------------------------------------------------------------------------------------------------------------------------------

- Q3. Is there any seasonality in sales for specific industries, and how do they perform month-over-month?
``` sql
select month, year, industry,
	SUM(sales) as total_sales
from retail_sales
group by industry, month, year
order by month, year;
```
- SAMPLE ANSWER :

![image](https://github.com/user-attachments/assets/a65c9150-fd15-4ca6-81b6-53d8c3fb4ea3)

---------------------------------------------------------------------------------------------------------------------------------------

- Q4. How does the sales distribution vary among industries based on their North American Industry Classification System (NAICS) codes?
``` sql
select naics_Code, industry,
	SUM(sales) as total_sales
from retail_sales
group by naics_Code, industry
order by total_sales desc;
```
- SAMPLE ANSWER :

![image](https://github.com/user-attachments/assets/2c292ed7-69cf-4736-9015-835f6da01dea)

----------------------------------------------------------------------------------------------------------------------------------------

- Q5. Are there significant higher (more than 1.5 times) than the sales in the previous or next month in sales for specific industries?
``` sql
with total_sales_cte as (
	select industry, month, year,
		SUM(sales) as total_sales
	from retail_sales
	group by industry, month, year
), lag_lead_sales as (
	select industry, month, year, total_sales,
		LAG(total_sales) over(partition by industry order by month, year) as prev_sale,
		LEAD(total_sales) over(partition by industry order by month, year) as next_sale
	from total_sales_cte
)
select  industry, month, year, total_sales
from lag_lead_sales
where total_sales > 1.5 * COALESCE(prev_sale, 0)
	OR total_sales > 1.5 * COALESCE(next_sale, 0)
order by industry, month, year;
```
- SAMPLE ANSWER :

![image](https://github.com/user-attachments/assets/0f008ba1-8429-4ee3-b768-aadd7856fe7c)

----------------------------------------------------------------------------------------------------------------------------------------

- Q6. Which businesses all-time average sale was above 10 billion dollars?
``` sql
select kind_of_business,
	AVG(sales) as avg_sales
from retail_sales
group by kind_of_business
having AVG(sales) > 10000
order by avg_sales desc;
```
- SAMPLE ANSWER :

![image](https://github.com/user-attachments/assets/e557c8c6-b5de-4c2e-ae37-c9c32536d370)

----------------------------------------------------------------------------------------------------------------------------------------

- Q7. Which kind of businesses within the automotive industry had the highest sales revenue for 2022?
``` sql
select kind_of_business,
	SUM(sales) as total_sales
from retail_sales
where industry = 'Automotive'
	and year = 2022
group by kind_of_business
order by total_sales desc;
```
- SAMPLE ANSWER :

![image](https://github.com/user-attachments/assets/d8b9a19e-379b-4391-871d-557913e220a6)


----------------------------------------------------------------------------------------------------------------------------------------

- Q8. What is the contribution percentage of each business in the automotive industry this year?
``` sql
with automotive_sales as (
	select industry, kind_of_business,
		SUM(sales) as automotive_sales
	from retail_sales
	where industry = 'Automotive'
	group by industry, kind_of_business
),
	total_sale_cte as (
		select
			SUM(sales) as total_sales
		from retail_sales
		where industry = 'Automotive'
	)
select *,
	round((100.0 * automotive_sales / total_sales), 2) as contribute_prec
from automotive_sales as a
join total_sale_cte as b
	on 1=1
order by contribute_prec desc;
```
- SAMPLE ANSWER :

![image](https://github.com/user-attachments/assets/33b1f2a6-b182-4283-9dd3-204b052c6b44)

----------------------------------------------------------------------------------------------------------------------------------------

- Q9. What are the year-over-year growth rates for each industry per year?
``` sql
with total_sales_cte as (
	select year, industry,
		sum(sales) as total_sales
	from retail_sales
	group by year, industry
),
	sale_cte as (
		select *,
			lag(total_sales) over(partition by industry order by year) as prev_sales,
			lag(year) over(partition by industry order by year) as prev_year
		from total_sales_cte
	)
select industry, year, prev_year, total_sales, prev_sales,
	(prev_sales - total_sales)*100.0 / prev_sales as yoy_growth
from sale_cte
where prev_sales is not null
order by year, industry, yoy_growth desc;
```
- SAMPLE ANSWER :

![image](https://github.com/user-attachments/assets/c307f60d-35c6-4536-b608-20775ae53f78)

----------------------------------------------------------------------------------------------------------------------------------------

- Q10. What are the yearly total sales for women's clothing stores and men's clothing stores?
``` sql
select year,
	sum(case when kind_of_business='Women''s clothing stores' then sales
		else 0 end) as women_store_sales,
	sum(case when kind_of_business='Men''s clothing stores' then sales
		else 0 end) as men_store_sales
from retail_sales
group by year
order by year;
```
- SAMPLE ANSWER :

![image](https://github.com/user-attachments/assets/b3183d34-969a-4aa9-94d0-4103fb9dd332)

----------------------------------------------------------------------------------------------------------------------------------------

- Q11. What is the yearly ratio of total sales for women's clothing stores to total sales for men's clothing stores?
``` sql
with cte as (
	select year,
		sum(case when kind_of_business='Women''s clothing stores' then sales
			else 0 end) as women_store_sales,
		sum(case when kind_of_business='Men''s clothing stores' then sales
			else 0 end) as men_store_sales
	from retail_sales
	group by year
)
select *,
	case when men_store_sales!=0 and women_store_sales!=0
		then women_store_sales / men_store_sales else 0
	end as women_men_ratio
from cte
order by  year;
```
- SAMPLE ANSWER :

![image](https://github.com/user-attachments/assets/bda9a5b9-200a-43be-aee5-42f0a6550779)

----------------------------------------------------------------------------------------------------------------------------------------

- Q12. What is the year-to-date total sale of each month for 2019, 2020, 2021, and 2022 for the womenâ€™s clothing stores?
``` sql
with filter_cte as (
	select year, month, sales
	from retail_sales
	where kind_of_business = 'Women''s clothing stores'
),
	ytd_sales as (
		select year, month, sales,
			sum(sales) over(partition by year order by month 
				ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as ytd_total_sales
		from filter_cte
	)
select *
from ytd_sales;
```
- SAMPLE ANSWER :

![image](https://github.com/user-attachments/assets/06b2bffa-3b65-4b95-933c-1b7f0ca8bdde)

----------------------------------------------------------------------------------------------------------------------------------------

- Q13. What is the month-over-month growth rate of women's clothing businesses in 2022?
``` sql
with filter_cte as (
	select month, sales,
		lag(sales) over(partition by kind_of_business order by month) as prev_sales
	from retail_sales
	where kind_of_business='Women''s clothing stores'
		and year = 2022
),
	mom_growth_rate as (
		select *,
			100.0*(sales - prev_sales)/prev_sales as mom_gr
		from filter_cte
	)
select *
from mom_growth_rate
order by month;
```
- SAMPLE ANSWER :

![image](https://github.com/user-attachments/assets/42d1db67-9f81-41cf-ab02-72fc3351a498)

----------------------------------------------------------------------------------------------------------------------------------------

