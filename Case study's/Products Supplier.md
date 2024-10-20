### Product Supplier Case Study

#### -----------------------------------------------------------------------

#### SupplierMaster
|Column Name 	|Data Type	|Remarks|
|-------------|-----------|-------|
|SID	|Integer	|Primary Key
|NAME	|Varchar (40)	|NOT NULL 
|CITY	|Char(6)	|NOT NULL
|GRADE	|Tinyint	|NOT NULL ( 1 to 4)

#### PartMaster
|Column Name 	|Data Type	|Remarks|
|-------------|-----------|-------|
|PID	|TinyInt	|Primary Key
|NAME	|Varchar (40)	|NOT NULL
|PRICE	|Money	|NOT NULL
|CATEGORY	|Tinyint	|NOT NULL ( 1 to 3)
|QTYONHAND	|Integer	|NULL

#### SupplyDetails
|Column Name 	|Data Type	|Remarks|
|-------------|-----------|-------|
|PID	|TinyInt	|Foreign Key
|SID	|Integer	|Foreign Key
|DATEOFSUPPLY	|DateTime	|NOT NULL
|CITY	|Varchar(40)	|NOT NULL
|QTYSUPPLIED	|Integer	|NOT NULL

### Schema is here: 

<details>
	<summary>Click here for solution</summary>
	
```sql
drop table if exists SupplierMaster;
create table SupplierMaster (
	SID Int Primary Key,
	Name Varchar(40) not null,
	City varchar(20) not null,
	Grade Tinyint not null check(Grade > 0 and Grade < 5)
);
insert into SupplierMaster values(10,'Usman Khan','Delhi',1);
insert into SupplierMaster values(20,'Nitish K','Kanpur',2);
insert into SupplierMaster values(30,'Shiva','Mumbai',2);
insert into SupplierMaster values(40,'Simran','Raipur',3);
insert into SupplierMaster values(50,'Srikanth','HYD',4);
insert into SupplierMaster values(60,'Neeraj','Delhi',1);
insert into SupplierMaster values(70,'Hament','Delhi',4);
insert into SupplierMaster values(80,'SKumar','Surat',2);
insert into SupplierMaster values(90,'Sanjay','Nagpur',1);
insert into SupplierMaster values(100,'Amit','Kanpur',3);
insert into SupplierMaster values(110,'Animesh','Bhopal',3);
insert into SupplierMaster values(120,'Gaurav','Chennai',1);
insert into SupplierMaster values(130,'Hilay','Rajkot',4);
insert into SupplierMaster values(140,'Bhavik','Durgapur',4);
insert into SupplierMaster values(150,'Shyamlal','Dehradun',2);
insert into SupplierMaster values(160,'Anamika','Roorkee',3);
insert into SupplierMaster values(170,'harpreet','Madras',2);
insert into SupplierMaster values(180,'Venugopal','Mumbai',1);
insert into SupplierMaster values(190,'Hament','Mumbai',1);
insert into SupplierMaster values(200,'SKumar','Madras',4);
insert into SupplierMaster values(210,'Sanjay','Dehradun',2);
insert into SupplierMaster values(220,'Amit','Durgapur',3);
insert into SupplierMaster values(230,'Animesh','Delhi',1);
insert into SupplierMaster values(240,'Gaurav','Delhi',4);

drop table if exists PartMaster;
create table PartMaster(	
	PID Tinyint Primary Key,
	Name Varchar(40) not null,	
	Price Money not null,
	Category Tinyint not null, --- Category 1,2,3
	QtyOnHand Int null,
);
insert into	PartMaster values(1,'Lights',1000,1,1200);
insert into	PartMaster values(2,'Batteries',5600,1,500);
insert into	PartMaster values(3,'Engines',67000,2,4000);
insert into	PartMaster values(4,'Tyres',2400,3,5000);
insert into	PartMaster values(5,'Tubes',700,3,7800);
insert into	PartMaster values(6,'Screws',15,2,2000);
insert into	PartMaster values(7,'Mirrors',1000,1,400);
insert into	PartMaster values(8,'Clutches',1500,3,1000);
insert into	PartMaster values(9,'Bolts',400,1,12000);
insert into	PartMaster values(10,'Nuts',200,1,25000);
insert into	PartMaster values(11,'Washers',300,2,4000);
insert into	PartMaster values(12,'Gaskets',2400,3,5000);
insert into	PartMaster values(13,'Hammers',2000,2,1800);
insert into	PartMaster values(14,'Bedsheets',150,1,2200);
insert into	PartMaster values(15,'Blankets',350,1,850);
insert into	PartMaster values(16,'Windscreens',1800,3,350);

drop table if exists SuplDetl;
create table SuplDetl (
	P_ID Tinyint not null Foreign Key references PartMaster(PID),
	S_ID Int not null Foreign Key references SupplierMaster(SID),
	DOS DateTime not null,
	CITY Varchar(40) not null,
	QTYSUPPLIED Int not null
);
insert into SuplDetl values(2,30,'2019/5/21','Delhi',45);
insert into SuplDetl values(3,60,'2019/6/25','Mumbai',80);
insert into SuplDetl values(1,40,'2019/6/30','Mumbai',120);
insert into SuplDetl values(5,10,'2019/7/02','Delhi',45);
insert into SuplDetl values(2,30,'2019/7/10','Kanpur',50);
insert into SuplDetl values(4,50,'2019/7/11','HYD',150);
insert into SuplDetl values(11,20,'2020/5/21','Bhopal',85);
insert into SuplDetl values(13,70,'2020/6/15','Chennai',100);
insert into SuplDetl values(11,20,'2020/6/10','Dehradun',110);
insert into SuplDetl values(15,50,'2022/7/02','Dehradun',50);
insert into SuplDetl values(12,40,'2022/7/10','HYD',250);
insert into SuplDetl values(14,30,'2022/7/11','Bhopal',450);
insert into SuplDetl values(16,30,'2022/9/1','Bhopal',155);
insert into SuplDetl values(3,60,'2022/9/5','Madras',180);
insert into SuplDetl values(1,40,'2021/6/30','HYD',200);
insert into SuplDetl values(5,10,'2022/7/02','Delhi',255);
insert into SuplDetl values(12,30,'2022/7/10','Kanpur',350);
insert into SuplDetl values(8,50,'2019/11/11','HYD',185);
insert into SuplDetl values(6,70,'2021/5/21','Rajkot',150);
insert into SuplDetl values(10,100,'2022/6/25','Roorkee',600);
insert into SuplDetl values(8,80,'2022/7/30','Surat',720);
insert into SuplDetl values(7,90,'2020/7/02','Mumbai',450);
insert into SuplDetl values(9,110,'2020/7/10','Nagpur',350);
insert into SuplDetl values(10,150,'2020/7/11','Madras',225);
insert into SuplDetl values(6,70,'2022/5/21','Chennai',150);
insert into SuplDetl values(10,100,'2022/5/15','HYD',600);
insert into SuplDetl values(8,80,'2022/6/13','Nagpur',720);
insert into SuplDetl values(7,90,'2022/7/12','Dehradun',450);
insert into SuplDetl values(9,110,'2022/7/11','Bhopal',350);
insert into SuplDetl values(10,150,'2022/8/15','HYD',225);
insert into SuplDetl values(16,70,'2019/4/11','Chennai',100);
insert into SuplDetl values(1,100,'2021/8/20','HYD',700);
insert into SuplDetl values(12,80,'2020/4/15','Nagpur',740);
insert into SuplDetl values(11,110,'2020/6/05','Bhopal',300);
insert into SuplDetl values(10,150,'2021/8/05','HYD',160);

select * from SupplierMaster;
select * from PartMaster;
select * from SuplDetl;
```
</details>

### Questions :

- Q.1. List the month-wise average supply of parts supplied for all parts. Provide the information only if the average is higher than 250.
```sql

```

Q.2. List the names of the Suppliers who do not supply part with PID ‘1’.
```sql

```

Q.3. List the part id, name, price and difference between price and average price of all parts.
```sql

 ```

Q.4. List the names of the suppliers who have supplied at least Two parts where the quantity supplied is lower than 500.
```sql

```

Q.5. List the names of the suppliers who live in a city where no supply has been made.
--		it means supplier iD should matched in both table but city should not be matched.
```sql

```

Q.6. List the names of the parts which have not been supplied in the month of May 2019.
```sql

```

Q.7.  List name and Price category for all parts. Price category has to be displayed as “Cheap” 
--		if price is less than 200, “Medium” if the price is greater than or equal to 200 and less than 500,
--		and “Costly” if the price is greater than or equal to 500.
```sql

```

Q.8. List the names of the suppliers who have supplied exactly 100 units of part P16.
```sql

```

Q.9. List the names of the parts whose price is more than the average price of parts.
```sql  

```

Q.10. For all products supplied by Supplier S70, List the part name and total quantity SUPPLIED.
```sql 

```
