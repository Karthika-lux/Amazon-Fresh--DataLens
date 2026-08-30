CREATE DATABASE amazon_fresh;
select * from amazon_fresh.customers;
select* from amazon_fresh.order_details;
select* from amazon_fresh.orders;
select* from amazon_fresh.products;
select* from amazon_fresh.reviews;
select* from amazon_fresh.suppliers;
-- Task 3: 
-- 1 Retrieve all customers from a specific city.
select * from amazon_fresh.customers
where city='Christopherland';

-- 2 Fetch all products under the "Fruits" category. 
select * from amazon_fresh.products
where category="Fruits";

--  Task 4:  DDL statements
-- CustomerID as the primary key.
--  Ensure Age cannot be null and must be greater than 18.
--  Add a unique constraint for Name. 

drop table if exists  customers;
create table customers(
CustomerID varchar(50) primary key,
Name varchar(50) unique,
Age int not null check (age>18),
Gender varchar(10),
City varchar(50),
State varchar(50),
Country varchar(50),
Signupdate DATE,
Primemember varchar(10));

-- Task 5: Insert 3 new rows into the Products table using INSERT statements.
select * from amazon_fresh.products;
insert into amazon_fresh.products(ProductID,ProductName,Category,SubCategory,PricePerUnit,StockQuantity,SupplierID)
values
('a001','cherry',"Fruits","Sub-Fruitss-5",101,35,'f005'),
('a002',"jackfruit","Fruits","Sub-Fruits-6",117,89,"m008"),
('a003',"Butter","dairy","Sub_dairy-4",300,149,"s190");

select * from amazon_fresh.products where ProductID in ('a001', 'a002', 'a003');

-- Task 6: Update the stock quantity of a product where ProductID matches a specific ID.
set sql_safe_updates=0;
update amazon_fresh.products
set StockQuantity = 90 where ProductID ="a002";

select	* from amazon_fresh.products where ProductID="a002";

-- Task 7: Delete a supplier from the Suppliers table where their city matches a specific value. 

delete from amazon_fresh.suppliers
where city="Schneidermouth"; 

select * from amazon_fresh.suppliers where city="Scheidermouth";

-- Task 8: Use SQL constraints to:
-- 1.Add a CHECK constraint to ensure that ratings in the Reviews table are between 1 and 5.

alter table amazon_fresh.reviews
drop check chk_rating;
alter table amazon_fresh.reviews
add constraint chk_rating check (Rating between 1 and 5);

-- 2.Add a DEFAULT constraint for the PrimeMember column in the Customers table (default value: "No"). 
alter table amazon_fresh.customers
modify column PrimeMember varchar(5) default 'no';

-- Task 9: Write queries using:

--  1.WHERE clause to find orders placed after 2024-01-01.
select * from amazon_fresh.orders
where OrderDate>2024-01-01;

-- 2 HAVING clause to list products with average ratings greater than 4.
select ProductID,avg(rating) as avgrating from amazon_fresh.reviews
group by ProductID having avg(rating)>4;

--  3 GROUP BY and ORDER BY clauses to rank products by total sales. 
select ProductID,sum(Quantity*UnitPrice )as t_sales from amazon_fresh.order_details
group by ProductID order by t_sales desc;


-- Task 10: Identifying High-Value Customers 
-- 1. Calculate each customer's total spending.
select CustomerID,sum(OrderAmount) as t_spending
from amazon_fresh.orders group by CustomerID;

-- 2. Rank customers based on their spending.
select CustomerID,sum(OrderAmount) as t_spending from amazon_fresh.orders
group by CustomerID order by t_spending desc;

-- 3. Identify customers who have spent more than ₹5,000. 
select CustomerID,sum(OrderAmount) as t_spending from amazon_fresh.orders
group by CustomerID having sum(OrderAmount)>5000 order by t_spending desc;


-- Task 11: Use SQL to:
--  Join the Orders and OrderDetails tables to calculate total revenue per order.
select o.OrderID, SUM(od.Quantity * od.UnitPrice) as T_Revenue
from amazon_fresh.orders as o join amazon_fresh.order_details as od on o.OrderID = od.OrderID
group by o.OrderID
order by T_Revenue desc; 

-- Identify customers who placed the most orders in a specific time period.

select CustomerID, COUNT(OrderID) as N_order from amazon_fresh.orders
where OrderDate = '2025-01-01' group by CustomerID
order by N_order desc limit 20;


-- Find the supplier with the most products in stock. 

select s.SupplierID, s.SupplierName, SUM(p.StockQuantity) as T_Stock from amazon_fresh.suppliers s
join amazon_fresh.products p on s.SupplierID = p.SupplierID
group by s.SupplierID, s.SupplierName
order by T_Stock desc limit 6;


-- Task 12: Normalize the Products table to 3NF:
--  Separate product categories and subcategories into a new table.
--  Create foreign keys to maintain relationships. 
drop table amazon_fresh.categories;
create table amazon_fresh.categories(
categoryID int auto_increment primary key,
category varchar(50),
subcategory varchar(50));

insert into amazon_fresh.categories(category,subcategory)
select distinct category,subcategory
from amazon_fresh.products;

alter table amazon_fresh.products
add column categoryID int;

set sql_safe_updates=0;
update amazon_fresh.products p
join amazon_fresh.categories c on 
p.category=c.category and p.subcategory=c.subcategory
set p.categoryID=c.categoryID;

alter table amazon_fresh.products
add constraint fk_category foreign key (CategoryID) references amazon_fresh.categories(CategoryID);

-- Task 13: Write a subquery to:
-- 1 Identify the top 3 products based on sales revenue.

select productID,sum(quantity*unitprice) as t_revenue from amazon_fresh.order_details
group by productID ;

select * from (select productID,sum(quantity*unitprice) as t_revenue from amazon_fresh.order_details
group by productID )as Productrevenue order by t_revenue desc limit 5;

-- 2  Find customers who haven’t placed any orders yet. 
select CustomerID,name from amazon_fresh.customers
where CustomerID not in (select distinct CustomerID from amazon_fresh.orders);

-- Task 14
select City, COUNT(*) as PrimeMemberCount from amazon_fresh.customers
where PrimeMember = 'Yes' group by City
order by PrimeMemberCount desc limit 10;

select c.Category, SUM(od.Quantity) as T_Quan_Order from amazon_fresh.order_details od
join amazon_fresh.products p on od.ProductID = p.ProductID
join amazon_fresh.categories c on p.CategoryID = c.CategoryID
group by c.Category order by T_Quan_Order desc limit 3;





















