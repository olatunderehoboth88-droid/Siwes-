create database Sql_project;
use sql_project;
create table customers(
customer_id int primary key,
first_name varchar(50),
last_name varchar(50),
email varchar(40),
phone varchar(40),
city varchar(30),
state varchar(40),
gender varchar(40),
registration_date date
);

create table products(
product_id int primary key,
product_name varchar(50),
category varchar(50),
price decimal(10,2),
stock_quantity int,
supplier varchar(50),
date_added date
);

create table orders(
order_id int primary key,
customer_id int,
product_id int,
quantity int,
unit_price decimal(10,2),
total_price decimal(10,2),
order_date date,
status varchar(40),
payment_method varchar(50),
foreign key (customer_id) references customers(customer_id),
foreign key (product_id) references products(product_id)
);

/*Question 1*/
-- 1A:  Display the structure of each table.
describe customers;
describe products;
describe orders;

-- 1B: Display the number of records in each table. 
select count(*) as number_of_records 
from customers;
-- ii
select count(*) as number_of_records 
from products;
-- iii
select count(*) as number_of_records 
from orders;

-- 1C: Find the total number of customers, products and orders. 
select count(customer_id) as customer_numbers
from customers;
-- ii 
select count(product_id)as product_numbers
from products;
-- iii
select count(order_id) as order_numbers
from orders;

-- 1D:Find the average, minimum and maximum product price.
select
avg(price) as average_price,
max(price) as highest_price,
min(price) as lowest_price
from products;

-- 1E:  Find the average, minimum and maximum order value.
select
avg(total_price) as average_orderprice,
max(total_price) as highest_orderprice,
min(total_price) as lowest_orderprice
from orders;

/*Question 2*/
-- 2A: Find customers from a particular state.
select * from customers
where state='Oyo';

-- 2B:  Find products above a specified price. 
select * from products
where price> 600000;

-- 2C:  Find products with low stock.
select * from products
where stock_quantity< 50;

-- 2D: Find completed and cancelled orders. 
select * from orders
where status='completed' or status='cancelled';

-- 2E: Display the 10 largest orders by value.
select * from orders
order by total_price desc
limit 10;

/*Question 3*/
-- 3A:  Number of customers by state.
select state,
count(*) as customer_count
from customers
group by state;

-- 3B:Number of products by category.
select category,
count(*) as product_count
from products
group by category;

-- 3C:Number of orders by payment method. 
select payment_method,
count(order_id) as order_number
from orders
group by payment_method;
-- 3D:Total sales by payment method. 
select payment_method,
sum(Total_price) as Total_sales
from orders
group by payment_method;
-- 3E:Total sales by order status. 
select status,
sum(Total_price) as Total_sales
from orders
group by status;
-- 3F:Average product price by category.
select category,
avg(price) as average_price
from products
group by category;

/*Question 4*/
/*Using INNER JOIN, display: 
• Customer name 
• Order ID 
• Order date 
• Product ID 
• Quantity 
• Total amount*/
select concat(c.first_name, ' ', c.last_name) as full_name,
o.order_id,
o.order_date,
o.product_id,
o.quantity,
o.total_price as total_amount
from customers c
inner join orders o on c.customer_id=o.customer_id;
-- 4B: calculate the total amount spent by each customer.
select c.customer_id,
concat(c.first_name, ' ', c.last_name) as full_name,
count(order_id) as no_of_orders,
sum(o.total_price) as total_spent
from customers c
inner join orders o on o.customer_id=c.customer_id
group by c.customer_id, full_name;

/*Question 5*/
-- 5A:
/*
Join all three tables and produce a detailed sales result containing: 
• Customer name 
• City 
• State 
• Product name 
• Category 
• Quantity 
• Unit price 
• Total amount 
• Order date 
• Payment method
*/
select concat(c.first_name,' ', c.last_name) as full_name,
c.city,
c.state,
p.product_name,
p.category,
o.quantity,
o.unit_price,
o.total_price,
o.order_date,
o.payment_method
from customers c 
inner join orders o on o.customer_id=c.customer_id
inner join products p on o.product_id=p.product_id;

-- 5B: calculate total revenue by product and category.
select p.product_id,
p.category,
sum(o.total_price) as total_revenue
from products p
inner join orders o on o.product_id=p.product_id
group by p.product_id,p.category;

/*Question 6*/
-- 6A: Display every customer and their orders. 
select *
from customers c
left join orders o on o.customer_id=c.customer_id;
-- 6B: Find customers who have never placed an order. 
select*
from customers c
left join orders o on o.customer_id=c.customer_id
where order_id is null;
-- 6C: Display every product and its orders. 
select * 
from products p 
left join orders o on o.product_id=p.product_id;
-- 6D:Find products that have never been ordered. 
select * 
from products p 
left join orders o on o.product_id=p.product_id
where order_id is null;
-- 6E: Calculate total spending for every customer, including customers with zero spending.
select c.customer_id,
concat(c.first_name,' ',c.last_name) as full_name,
coalesce(sum(o.total_price), 0)as total_spending
from customers c
left join orders o on o.customer_id=c.customer_id
group by c.customer_id,full_name;

/*Question 7*/
-- 7A: Use RIGHT JOIN to display all products and their orders.
select * 
from orders o
right join products p  on o.product_id=p.product_id;
-- 7B: Rewrite the same query using LEFT JOIN. 
select * 
from products p
left join orders o on o.product_id=p.product_id;
-- 7C:
/*
Right Join keeps all the products from the right table
Left Join keeps all the products from the left table
they are inverse of each other
*/
-- 7D:
select c.customer_id,
concat(c.first_name,' ',c.last_name) as full_name,
o.order_id,
o.order_date
from customers c
left join orders o on o.customer_id=c.customer_id

union

select c.customer_id,
concat(c.first_name,' ',c.last_name) as full_name,
o.order_id,
o.order_date
from customers c
right join orders o on o.customer_id=c.customer_id;

-- 7E: 
select c.customer_id,
concat(c.first_name,' ',c.last_name) as full_name,
p.product_id,
p.product_name
from customers c
cross join products p;

/*Question 8*/
-- 8A:  The top 10 customers by total spending. 
select c.customer_id,
concat(c.first_name,' ',c.last_name) as full_name,
sum(o.total_price) as total_spending
from customers c
left join orders o on o.customer_id=c.customer_id
group by c.customer_id,full_name
order by total_spending desc
limit 10;

-- 8B:Customers with more than 10 orders. 
select c.customer_id,
concat(c.first_name,' ',c.last_name) as full_name,
count(o.order_id) as order_number
from customers c
left join orders o on o.customer_id=c.customer_id
group by c.customer_id,full_name
having order_number> 10;
-- 8C: The top 10 products by revenue. 
select p.product_id,
p.product_name,
sum(o.total_price) as revenue
from products p
left join orders o on p.product_id=o.product_id
group by p.product_id,p.product_name
order by revenue desc
limit 10;
-- 8D: The top 10 products by quantity sold.
select p.product_id,
p.product_name,
sum(o.quantity) as quantity
from products p
left join orders o on p.product_id=o.product_id
group by p.product_id,p.product_name
order by quantity desc
limit 10;
-- 8E: Products with low stock but high sales. 
select p.product_id,
p.product_name,
p.stock_quantity,
sum(o.total_price) as Sales
from products p
left join orders o on o.product_id=p.product_id
group by p.product_id,p.product_name
having p.stock_quantity< 1000 and sales> 500000;

/*Question 9*/
-- 9A:
/*
Classify customers as: 
Low Spender 
Medium Spender 
High Spender
*/
select c.customer_id,
concat(c.first_name,' ',c.last_name) as full_name,
sum(o.total_price) as total_spent,
case when sum(o.total_price)>= 20000000 then 'High Spender'
when sum(o.total_price)< 20000000 and sum(o.total_price)>= 15000000 then 'Medium Spender'
when sum(o.total_price)<15000000 then 'Low Spender'
end as Spending_status
from customers c
left join orders o on o.customer_id=c.customer_id
group by customer_id,full_name;
-- 9B: Classify products according to price.
select product_id,
product_name,
price,
case when price>500000 then 'High Class Product'
else 'Low Class Product'
end as Product_Class
from products;
-- 9C: Classify products according to stock level.
select product_id,
product_name,
stock_quantity,
case when stock_quantity> 100 then 'Plenty Stocks'
else 'Few Stocks'
end as Stock_Level
from products;
-- 9D:Classify orders according to order value. 
select order_id,
total_price,
status,
case when total_price >500000 then 'High value'
when total_price >200000 then 'Medium value'
else 'low Value'
end as order_class
from orders;

/*Question 10*/
-- 10A: Find products whose price is above the average product price.
select * 
from products
where price> (
select avg(price) from products);
-- 10B:Find orders above the average order value. 
select *
from orders
where total_price> (
select avg(total_price) from orders
);
-- 10C:Find customers whose spending is above average.
with customer_spending as (
    select c.customer_id,
           CONCAT(c.first_name, ' ', c.last_name) as full_name,
           SUM(o.total_price) as total_spending
    from customers c
    inner join orders o
        on o.customer_id = c.customer_id
    group by c.customer_id, full_name
)
select *
from customer_spending
where total_spending > (
    select avg(total_spending)
    from customer_spending
);

-- 10D:  Find the highest-revenue products.
with product_revenue as (
select p.product_id,
p.product_name,
sum(o.total_price) as total_revenue
from products p
inner join orders o on o.product_id=p.product_id
group by o.product_id
)
select * 
 from product_revenue
 where total_revenue=(
 select max(total_revenue)
 from product_revenue
 );
-- 10E: Calculate total spending by customer using a CTE.
with customer_spending as (
    select c.customer_id,
           CONCAT(c.first_name, ' ', c.last_name) as full_name,
           SUM(o.total_price) as total_spending
    from customers c
    inner join orders o
        on o.customer_id = c.customer_id
    group by c.customer_id, full_name
)
select *
from customer_spending;
/*Question 11*/
-- 11A: Calculate daily sales. 
select
order_date,
 sum(total_price) as daily_sales
 from orders
 group by order_date
 order by order_date asc;
-- 11B: Calculate monthly sales.
select
monthname(order_date) as order_month,
year(order_date) as order_year,
sum(total_price) as monthly_sales
from orders
group by order_month,order_year;

-- 11C:Calculate yearly sales. 
select year(order_date) as order_year,
sum(total_price) as Yearly_sales
from orders
group by order_year;
-- 11D:Find the month with the highest sales. 
with month_sales as (select
monthname(order_date) as order_month,
year(order_date) as order_year,
sum(total_price) as monthly_sales
from orders
group by order_month,order_year)

select *
from month_sales
where monthly_sales=(
select max(monthly_sales)
from month_sales
);
-- 11E: Find the month with the lowest sales.
with month_sales as (select
monthname(order_date) as order_month,
year(order_date) as order_year,
sum(total_price) as monthly_sales
from orders
group by order_month,order_year)

select *
from month_sales
where monthly_sales=(
select min(monthly_sales)
from month_sales
);
-- 11f: Compare each month's sales with the previous month.

/*Question 12*/
-- 12A: Rank customers by total spending.
with customer_spending as(
select 
c.customer_id,
concat(c.first_name,' ', c.last_name) as full_name,
sum(o.total_price) as total_spending
from customers c 
inner join orders o on o.customer_id=c.customer_id
group by c.customer_id,full_name
)
select *,
rank() over (order by total_spending desc) as spending_rank
from customer_spending;

-- 12B: Rank products by revenue.
with product_revenue as (
select 
p.product_id,
p.product_name,
sum(o.total_price) as total_revenue
from products p
inner join orders o on o.product_id=p.product_id
group by p.product_id,p.product_name
)
select*,
rank() over(order by total_revenue desc) as revenue_rank
from product_revenue; 

-- 12C:Number each customer's orders using ROW_NUMBER().
select
    order_id,
    customer_id,
    order_date,
    total_price,
    row_number() over(
        partition by customer_id
        order by order_date
    ) as order_number
from orders;
-- 12D: Rank products by quantity sold using DENSE_RANK(). 

-- 12E:  Calculate each customer's percentage contribution to total sales.