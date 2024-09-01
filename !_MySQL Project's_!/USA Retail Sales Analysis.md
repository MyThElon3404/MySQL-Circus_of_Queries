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

- Q8. Which kind of businesses within the automotive industry had the highest sales revenue for 2022?
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



----------------------------------------------------------------------------------------------------------------------------------------













