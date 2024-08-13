### Product Supplier Case Study

#### --------------------------------------------------------------------------------------------

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
