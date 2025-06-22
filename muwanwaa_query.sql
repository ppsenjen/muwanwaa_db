-- counting occurrences of fnames and lnames combinations
select 
customer_fname,
customer_lname,
count(*) AS name_count
from muwanwaa.customers
group by 
customer_fname,
customer_lname
having
 count(*)  > 1 
order by 
name_count desc;

-- confrming the duplicates

select customer_id,customer_fname,customer_lname,customer_street,customer_zipcode
from muwanwaa.customers
where ( customer_fname = 'mary' and customer_lname = 'smith')
;

-- identifying the null values
SELECT
    COUNT(*) AS total_rows,
    COUNT(customer_id) AS non_null_id,
    COUNT(customer_fname) AS non_null_fname,
    COUNT(customer_lname) AS non_null_lname,
    COUNT(customer_email) AS non_null_email,
    COUNT(customer_password) AS non_null_password,
    COUNT(customer_street) AS non_null_street,
    COUNT(customer_city) AS non_null_city,
    COUNT(customer_state) AS non_null_state,
    COUNT(customer_zipcode) AS non_null_zipcode
FROM
    muwanwaa.customers;

-- confriming that the 'not null' values are equal to the number of total rows
select count(customer_id)
from muwanwaa.customers;


-- Customer Demographics - Where are our customers located by states and cities
select 
customer_city,
customer_state, 
count(customer_id) As number_of_customers
from muwanwaa.customers
group by 
customer_city,
customer_state
order by  number_of_customers desc,customer_city,customer_state
limit 20;

-- counting number of customers by states only

select 
customer_state,
count(customer_id) as number_of_customers
from muwanwaa.customers
group by customer_state
order by count(customer_id) desc;

-- counting number of customers by cities only
select 
customer_city,
count(customer_id) as number_of_customers
from muwanwaa.customers
group by customer_city
order by count(customer_id) desc;

-- Categories Analysis - What are the most popular product categories?
-- Objective: Identify which product categories are available and which ones are most relevant.

select 
category_name,
count(*) as number_categories
from muwanwaa.categories
group by category_name
having count(*) > 1
order by number_categories;

-- counting products per category
select 
c.category_name,
count(p.product_id) as total_products
from muwanwaa.categories c
JOIN products p ON c.category_id = p.product_category_id
group by c.category_name
order by total_products desc;

--  Customer Activity - How many orders do customers place and who are the most active customers?
-- Objective: Analyze customer engagement based on order placement.
select 
c.customer_id,
c.customer_fname,
c.customer_lname,
count(o.order_id) as total_orders_placed
from muwanwaa.customers c 
JOIN muwanwaa.orders o
ON 
c.customer_id = o.order_customer_id
group by 
c.customer_id,
c.customer_fname,
c.customer_lname
order by total_orders_placed desc;

-- Calculate the average number of orders per customer using a subquery 
select 
avg(orders_per_customer) as average_orders_per_customer
from (
select 
count(order_id) as orders_per_customer
from muwanwaa.orders
group by order_id
) as customer_order_counts ;


-- using a CTE for the same above

with customer_order_counts as (
select 
order_customer_id,
count(*) as orders_per_customer
from muwanwaa.orders
group by order_customer_id
)
select avg(orders_per_customer) as avg_orders_per_customer
from customer_order_counts;

--  Sales Performance - What are the top-selling products/categories by revenue or quantity?
--  Objective: Identify the most successful products or categories.
-- Top 10 products by revenue:
with productRevenue as (
select
 oi.order_item_product_id,
 round(sum(order_item_subtotal),4) as total_revenue
 from 
 muwanwaa.order_items oi 
 group by 
 oi.order_item_product_id
)
 select 
p.product_name,
pr.total_revenue

from 
productRevenue pr
 JOIN 
 muwanwaa.products p ON pr.order_item_product_id = p.product_id
 order by 
 pr.total_revenue desc
 limit 10
 ;
 
-- Top 10 categories by revenue:
with CategoryRevenue as (
select
c.category_name,
sum(oi.order_item_subtotal) as total_revenue
from muwanwaa.order_items oi
JOIN 
 muwanwaa.products p ON oi.order_item_product_id = p.product_id
JOIN 
muwanwaa.categories c on p.product_category_id = c.category_id
group by c.category_name
)
select 
category_name,
total_revenue

from CategoryRevenue
order by 
total_revenue desc 
limit 10;


--  Order Status Analysis - What is the distribution of order statuses?
-- Objective: Understand the number of orders that are complete,pending etc

select order_status,
count(order_id) as number_of_orders
from 
orders
group by order_status
order by number_of_orders desc;

--  Sales Trend Analysis - How has revenue changed over time?
-- Objective: Identify periods of high/low sales and also understand trends.
-- monthly Revenue trend

select date_format(order_date, '%Y-%M') As sales_month,
sum(oi.order_item_subtotal)  as monthly_revenue
from orders o 
JOIN 
order_items oi ON o.order_id = oi.order_item_order_id
group by 
sales_month
order by monthly_revenue asc
limit 10;

-- Daily Average
WITH DailyRevenue AS (
    SELECT
        DATE(order_date) AS order_day,
        SUM(oi.order_item_subtotal) AS daily_total
    FROM
        orders o
    JOIN
        order_items oi ON o.order_id = oi.order_item_order_id
    GROUP BY
        order_day
)
SELECT
    AVG(daily_total) AS average_daily_revenue
FROM
    DailyRevenue;

-- ranking products by sales within each category
SELECT
    p.product_name,
    c.category_name,
    oi.order_item_subtotal,
    RANK() OVER (PARTITION BY c.category_name ORDER BY oi.order_item_subtotal DESC) AS sales_rank_in_category
FROM
    products p
JOIN
    categories c ON p.product_category_id = c.category_id
JOIN
    order_items oi ON p.product_id = oi.order_item_product_id;
























