-- 1.1 Select the names of all the products in the store.
select Name from Products;

-- 1.2 Select the names and the prices of all the products in the store.
select name, price from products;

-- 1.3 Select the name of the products with a price less than or equal to $200.
select name from products where price <= 200;


-- 1.4 Select all the products with a price between $60 and $120.
select * from products where price between 60 and 120;
                        -- OR
select * from products where price >= 60 and price <= 120;

-- 1.5 Select the name and price in cents (i.e., the price must be multiplied by 100).
select name, price*100 from products;
-- OR
select name, concat(price*100, ' cents') from products;

-- 1.6 Compute the average price of all the products.
select avg(price) from products;
              -- OR
select sum(price)/count(price) from products;

-- 1.9 Select the name and price of all products with a price larger than or equal to $180, and sort first by price (in descending order), and then by name (in ascending order).
select name, price from products where price>=180 order by price desc, name asc;

-- 1.10 Select all the data from the products, including all the data for each product's manufacturer.
select a.*, b.name from products a join Manufacturers b on(a.manufacturer = b.code);
                                    -- OR
select a.*, b.name from products a, Manufacturers b where a.manufacturer = b.code;

-- 1.11 Select the product name, price, and manufacturer name of all the products.
select a.name, a.price, b.name from products a join Manufacturers b on(a.manufacturer = b.code);
                                  -- OR
SELECT Products.Name, Price, Manufacturers.Name FROM Products INNER JOIN Manufacturers
ON Products.Manufacturer = Manufacturers.Code;

-- 1.12 Select the average price of each manufacturer's products, showing only the manufacturer's code.
SELECT AVG(Price), Manufacturer FROM Products GROUP BY Manufacturer;

-- 1.13 Select the average price of each manufacturer's products, showing the manufacturer's name.
select avg(a.price), b.name 
from Products a join Manufacturers b 
on a.manufacturer = b.code
group by b.name;


-- 1.14 Select the names of manufacturer whose products have an average price larger than or equal to $150.
select avg(a.price), b.name 
from Manufacturers b join Products a 
on b.code = a.Manufacturer
group by b.name
having avg(a.price)>=150;

-- 1.15 Select the name and price of the cheapest product.
select name, price from Products 
where price = (
select min(price)
from products);
                -- OR
SELECT name, price
FROM Products
ORDER BY price ASC
LIMIT 1;

-- 1.16 Select the name of each manufacturer along with the name and price of its most expensive product.
select max_price_mapping.name as manu_name, max_price_mapping.price, products_with_manu_name.name as product_name
from 
    (SELECT Manufacturers.Name, MAX(Price) price
     FROM Products, Manufacturers
     WHERE Manufacturer = Manufacturers.Code
     GROUP BY Manufacturers.Name)
     as max_price_mapping
   left join
     (select products.*, manufacturers.name manu_name
      from products join manufacturers
      on (products.manufacturer = manufacturers.code))
      as products_with_manu_name
 on
   (max_price_mapping.name = products_with_manu_name.manu_name
    and
    max_price_mapping.price = products_with_manu_name.price);

                            -- OR

with manufacturer_insight as (
	SELECT m.name as manufacturer_name, p.name as product_name, p.price as product_price,
  		dense_rank() over (partition by m.name ORDER by p.price desc) as product_rank
  	from Manufacturers m 
  	join Products p on m.Code = p.Manufacturer
)
select manufacturer_name, product_name, product_price
from manufacturer_insight 
WHERE product_rank = 1;

-- 1.17 Add a new product: Loudspeakers, $70, manufacturer 2.
insert into Products values (11, 'Loudspeakers', 70, 2);


-- 1.18 Update the name of product 8 to "Laser Printer".
update products
set name = 'Laser Printer'
where code=8;

-- 1.19 Apply a 10% discount to all products.
update products
set price=price*0.9;


-- 1.20 Apply a 10% discount to all products with a price larger than or equal to $120.
update products
set price = price * 0.9
where price >= 120; 


