# Credit Card Transaction Analysis of Indian Customer

- Dataset for this case study download from here - [Dataset](https://www.kaggle.com/datasets/thedevastator/analyzing-credit-card-spending-habits-in-india)

## Dataset Schema information - 
- city(String) - City name where transaction took place
- date(Date) - Transaction date
- card_type(String) - Type of card used for transaction
- exp_type(String) - Type of expence associated with transaction
- gender(String) - Gender of card holder
- amount(number) - Amount of transaction

----------------------------------------------------------------------------------------------------------------------------

## EDA of Transaction data
  <details>
	  <summary>✅check null values per column</summary>
	  select
	sum(case when "index" is null then 1 else 0 end) as index_null_cnt,
	sum(case when City is null then 1 else 0 end) as city_null_cnt,
	sum(case when "Date" is null then 1 else 0 end) as date_null_cnt,
	sum(case when Card_Type is null then 1 else 0 end) as card_type_null_cnt,
	sum(case when Exp_Type is null then 1 else 0 end) as exp_type_null_cnt,
	sum(case when Gender is null then 1 else 0 end) as gender_null_cnt,
	sum(case when Amount is null then 1 else 0 end) as amount_null_cnt
from cct;
  </details>



- ## Question & Answer for case study

- Q1. write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends
<details>
	<summary> Click Here for Answer </summary>
	
</details>

