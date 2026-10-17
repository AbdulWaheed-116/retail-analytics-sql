USE retail_analytics;
SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM products;

-- Q1. Find the total number of orders.
SELECT count(order_id) FROM orders;

-- Q2. Calculate total sales revenue. 
SELECT SUM(o.quantity * p.unit_price) AS total_sales_revenue FROM products AS p
JOIN orders AS o ON p.product_id = o.product_id;

-- Q3. Find total quantity of products sold.
SELECT SUM(quantity) FROM orders;

-- Q4. Calculate the average order-line revenue(quantity * unit price for each order row)
SELECT o.order_id , avg(o.quantity * p.unit_price) as avg_revenue FROM orders AS o
JOIN products AS p ON o.product_id = p.product_id
group by o.order_id;

-- Q5. Find the number of unique customers who placed orders.
SELECT count(DISTINCT c.customer_id) AS unique_customer FROM customers AS c 
LEFT JOIN orders AS o ON o.customer_id = c.customer_id WHERE o.order_id IS NOT NULL;

-- Q6. Show total revenue for each product, highest revenue first.
SELECT p.product, SUM(o.quantity * p.unit_price) AS total_revenue FROM products AS p 
JOIN orders AS o ON p.product_id = o.product_id GROUP BY p.product_id , p.product ORDER BY total_revenue DESC;

-- Q7. Find the highest-revenue product in each category.
WITH pro_cat_revenue AS ( SELECT p.product, p.category, SUM(o.quantity * p.unit_price) AS total_revenue FROM products AS p 
JOIN orders AS o ON p.product_id = o.product_id GROUP BY p.product_id , p.product , p.category 
) , revenues AS (select product , category, total_revenue, ROW_NUMBER() OVER( PARTITION BY category ORDER BY total_revenue DESC) AS revenue_rank
 FROM pro_cat_revenue) SELECT * FROM revenues where revenue_rank = 1 ;
 
-- Q8. Calculate revenue and percentage contribution for each category.
WITH cat_revenue AS ( SELECT p.category, SUM(o.quantity * p.unit_price) AS category_revenue FROM products AS p 
JOIN orders AS o ON p.product_id = o.product_id GROUP BY p.category ) , per_reveneu as ( select category, category_revenue, 
SUM(category_revenue) OVER() AS total_revenue FROM cat_revenue ) select category, category_revenue ,total_revenue, 
 (category_revenue/total_revenue)*100 AS percentage_of_category from per_reveneu;

-- Q9. Find products whose revenue is above the average product revenue.
with pro_revenue as ( SELECT p.product, SUM(o.quantity * p.unit_price) AS product_revenue FROM products AS p 
JOIN orders AS o ON p.product_id = o.product_id GROUP BY p.product_id , p.product ) , avg_revenue as ( 
select product , product_revenue, avg(product_revenue) OVER() as avg_pro_revenue from pro_revenue ) SELECT * FROM avg_revenue where product_revenue > avg_pro_revenue;


-- Q10. Show each category's total_revenue, total_quantity sold and number of order rows.
SELECT p.category, SUM(o.quantity * p.unit_price) AS total_revenue , sum(o.quantity) as total_quantity , count(o.order_id) as no_of_orders  FROM products AS p 
JOIN orders AS o ON p.product_id = o.product_id GROUP BY p.category;

-- Q11. Calculate total spending for each customer, including their name and region.
 select c.customer_id, c.customer_name , c.region, SUM(o.quantity * p.unit_price) AS total_spending from customers as c 
 left join orders as o on c.customer_id = o.customer_id left join products as p on o.product_id = p.product_id group by c.customer_id , c.customer_name;
 
-- Q12. Find the top 3 customers by total spending.
select c.customer_id, c.customer_name , c.region, SUM(o.quantity * p.unit_price) AS total_spending from customers as c 
 left join orders as o on c.customer_id = o.customer_id left join products as p on o.product_id = p.product_id
 group by c.customer_id , c.customer_name order by total_spending desc limit 3;
 
-- Q13. Find customers who have never placed an order.
select c.customer_id, c.customer_name  from customers as c 
 left join orders as o on c.customer_id = o.customer_id 
 where o.order_id is null group by c.customer_id , c.customer_name  ;

-- Q14. Find the highest-spending customer in each region.
with spending_customer as ( select c.customer_id, c.customer_name , c.region, SUM(o.quantity * p.unit_price) AS total_spending from customers as c 
 left join orders as o on c.customer_id = o.customer_id left join products as p on o.product_id = p.product_id
 group by c.customer_id , c.customer_name , c.region) , rank_spending as ( select * , ROW_NUMBER() over( partition by region order by total_spending desc ) as region_spending_rank 
 from spending_customer) select * from rank_spending where region_spending_rank = 1;
 
-- Q15. Find customers whose spending is above the average spending per customer who placed orders.
with spending_customer as ( select c.customer_id, c.customer_name ,  SUM(o.quantity * p.unit_price) AS total_spending from customers as c 
 left join orders as o on c.customer_id = o.customer_id left join products as p on o.product_id = p.product_id
 group by c.customer_id , c.customer_name ) , avg_spending as ( select * , avg(total_spending) over() as avg_spending_customer from spending_customer ) 
 select * from avg_spending where total_spending > avg_spending_customer;
 
-- Q16. Find the category with the highest total revenue.
select p.category , SUM(o.quantity * p.unit_price) as total_revenue from products as p 
join orders as o on p.product_id = o.product_id group by p.category order by total_revenue DESC LIMIT 1;

-- Q17. Find the top 2 products by revenue with in each category.
select p.product_id , p.product , SUM(o.quantity * p.unit_price) as total_revenue from products as p 
join orders as o on p.product_id = o.product_id group by p.product_id , p.product order by total_revenue DESC limit 2;

-- Q18. Calculate each customer's percentage contribution to total sales revenue.
with spending_customer as ( select c.customer_id , c.customer_name, SUM(o.quantity * p.unit_price) as total_spending from customers as c 
left join orders as o on c.customer_id = o.customer_id left join products as p on o.product_id = p.product_id group by c.customer_id , c.customer_name
) , total_customer_spending as ( select * , sum(total_spending) over() as total_revenue from spending_customer
) select * , (total_spending/total_revenue)*100 as percentage_contribution from total_customer_spending;

-- Q19. Find categories whose revenue is greater than 20000.
select p.category , SUM(o.quantity * p.unit_price) as total_revenue from products as p 
join orders as o on p.product_id = o.product_id group by p.category having total_revenue > 20000 ;

-- Q20. Create a final category report showing category, total revenue, percentage of overall revenue, quantity sold and number of order rows.
with cat_revenue as ( select p.category , SUM(o.quantity * p.unit_price) as total_revenue, SUM(o.quantity) as total_sold_quantity , COUNT(o.order_id) as total_orders 
from products as p join orders as o on p.product_id = o.product_id group by p.category ) , per_revenue as ( select * , SUM(total_revenue) over() as overall_revenue 
from cat_revenue ) select * , (total_revenue/overall_revenue)*100 as percentage_of_overall_revenue from per_revenue;

