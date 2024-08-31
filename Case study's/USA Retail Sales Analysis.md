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
|sales	   | float | NULL

![image](https://github.com/user-attachments/assets/b8312e2c-099a-4ba1-a5ba-9399a5bfcb45)


---------------------------------------------------------------------------------------------------------------------------------------
## QUESTIONS & ANSWERS :
---------------------------------------------------------------------------------------------------------------------------------------

- Q1. Top-performing industries in terms of sales for a year 2021, and how do their sales compare month-over-month?
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
- ANSWER :

![image](https://github.com/user-attachments/assets/5740da8e-09b4-4e28-91e5-2484a6c55ab2)

---------------------------------------------------------------------------------------------------------------------------------------

- Q2. Top-performing industries in terms of sales for a year 2021, and how do their sales compare month-over-month?
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
- ANSWER :






















