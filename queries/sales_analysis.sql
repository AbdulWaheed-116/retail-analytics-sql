-- ============================================================
--  Retail Analytics — Sales Analysis Queries
--  Database : retail_analytics
--  Dialect  : MySQL 8+
--  Author   : (your name)
--  Date     : 2024
-- ============================================================
--
--  Run order:
--    1. schema.sql
--    2. data/sample_data.sql
--    3. queries/sales_analysis.sql   ← this file
--
-- ============================================================

USE retail_analytics;

-- ============================================================
--  SECTION 1: OVERVIEW CHECKS
-- ============================================================

SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM products;


-- ============================================================
--  SECTION 2: BASIC AGGREGATIONS
-- ============================================================

-- Q1. Find the total number of orders.
SELECT COUNT(order_id) AS total_orders
FROM orders;


-- Q2. Calculate total sales revenue.
SELECT
    SUM(o.quantity * p.unit_price) AS total_sales_revenue
FROM products AS p
JOIN orders AS o ON p.product_id = o.product_id;


-- Q3. Find the total quantity of products sold.
SELECT SUM(quantity) AS total_quantity_sold
FROM orders;


-- Q4. Calculate the average order-line revenue
--     (quantity × unit_price for each order row).
SELECT
    o.order_id,
    AVG(o.quantity * p.unit_price) AS avg_line_revenue
FROM orders AS o
JOIN products AS p ON o.product_id = p.product_id
GROUP BY o.order_id;


-- Q5. Find the number of unique customers who placed at least one order.
SELECT
    COUNT(DISTINCT c.customer_id) AS unique_customers_with_orders
FROM customers AS c
LEFT JOIN orders AS o ON o.customer_id = c.customer_id
WHERE o.order_id IS NOT NULL;


-- ============================================================
--  SECTION 3: PRODUCT ANALYSIS
-- ============================================================

-- Q6. Show total revenue for each product, highest revenue first.
SELECT
    p.product,
    SUM(o.quantity * p.unit_price) AS total_revenue
FROM products AS p
JOIN orders AS o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product
ORDER BY total_revenue DESC;


-- Q7. Find the highest-revenue product in each category.
WITH product_category_revenue AS (
    SELECT
        p.product,
        p.category,
        SUM(o.quantity * p.unit_price) AS total_revenue
    FROM products AS p
    JOIN orders AS o ON p.product_id = o.product_id
    GROUP BY p.product_id, p.product, p.category
),
ranked_products AS (
    SELECT
        product,
        category,
        total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY total_revenue DESC
        ) AS revenue_rank
    FROM product_category_revenue
)
SELECT product, category, total_revenue
FROM ranked_products
WHERE revenue_rank = 1;


-- Q9. Find products whose revenue is above the average product revenue.
WITH product_revenue AS (
    SELECT
        p.product,
        SUM(o.quantity * p.unit_price) AS product_revenue
    FROM products AS p
    JOIN orders AS o ON p.product_id = o.product_id
    GROUP BY p.product_id, p.product
),
with_avg AS (
    SELECT
        product,
        product_revenue,
        AVG(product_revenue) OVER () AS avg_product_revenue
    FROM product_revenue
)
SELECT product, product_revenue, avg_product_revenue
FROM with_avg
WHERE product_revenue > avg_product_revenue;


-- Q17. Find the top 2 products by revenue within each category.
WITH product_category_revenue AS (
    SELECT
        p.product_id,
        p.product,
        p.category,
        SUM(o.quantity * p.unit_price) AS total_revenue
    FROM products AS p
    JOIN orders AS o ON p.product_id = o.product_id
    GROUP BY p.product_id, p.product, p.category
),
ranked AS (
    SELECT
        product_id,
        product,
        category,
        total_revenue,
        RANK() OVER (
            PARTITION BY category
            ORDER BY total_revenue DESC
        ) AS revenue_rank
    FROM product_category_revenue
)
SELECT product_id, product, category, total_revenue
FROM ranked
WHERE revenue_rank <= 2;


-- ============================================================
--  SECTION 4: CATEGORY ANALYSIS
-- ============================================================

-- Q8. Calculate revenue and percentage contribution for each category.
WITH category_revenue AS (
    SELECT
        p.category,
        SUM(o.quantity * p.unit_price) AS category_revenue
    FROM products AS p
    JOIN orders AS o ON p.product_id = o.product_id
    GROUP BY p.category
),
with_total AS (
    SELECT
        category,
        category_revenue,
        SUM(category_revenue) OVER () AS total_revenue
    FROM category_revenue
)
SELECT
    category,
    category_revenue,
    total_revenue,
    ROUND((category_revenue / total_revenue) * 100, 2) AS percentage_of_total
FROM with_total
ORDER BY category_revenue DESC;


-- Q10. Show each category's total revenue, quantity sold, and order count.
SELECT
    p.category,
    SUM(o.quantity * p.unit_price) AS total_revenue,
    SUM(o.quantity)               AS total_quantity_sold,
    COUNT(o.order_id)             AS number_of_order_rows
FROM products AS p
JOIN orders AS o ON p.product_id = o.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;


-- Q16. Find the category with the highest total revenue.
SELECT
    p.category,
    SUM(o.quantity * p.unit_price) AS total_revenue
FROM products AS p
JOIN orders AS o ON p.product_id = o.product_id
GROUP BY p.category
ORDER BY total_revenue DESC
LIMIT 1;


-- Q19. Find categories whose total revenue exceeds 20,000.
SELECT
    p.category,
    SUM(o.quantity * p.unit_price) AS total_revenue
FROM products AS p
JOIN orders AS o ON p.product_id = o.product_id
GROUP BY p.category
HAVING total_revenue > 20000
ORDER BY total_revenue DESC;


-- Q20. Final category report:
--      category | total_revenue | % of overall | quantity_sold | order_rows
WITH category_stats AS (
    SELECT
        p.category,
        SUM(o.quantity * p.unit_price) AS total_revenue,
        SUM(o.quantity)               AS total_quantity_sold,
        COUNT(o.order_id)             AS total_orders
    FROM products AS p
    JOIN orders AS o ON p.product_id = o.product_id
    GROUP BY p.category
),
with_overall AS (
    SELECT
        *,
        SUM(total_revenue) OVER () AS overall_revenue
    FROM category_stats
)
SELECT
    category,
    total_revenue,
    ROUND((total_revenue / overall_revenue) * 100, 2) AS percentage_of_overall_revenue,
    total_quantity_sold,
    total_orders
FROM with_overall
ORDER BY total_revenue DESC;


-- ============================================================
--  SECTION 5: CUSTOMER ANALYSIS
-- ============================================================

-- Q11. Calculate total spending per customer, including name and region.
SELECT
    c.customer_id,
    c.customer_name,
    c.region,
    COALESCE(SUM(o.quantity * p.unit_price), 0) AS total_spending
FROM customers AS c
LEFT JOIN orders   AS o ON c.customer_id  = o.customer_id
LEFT JOIN products AS p ON o.product_id   = p.product_id
GROUP BY c.customer_id, c.customer_name, c.region
ORDER BY total_spending DESC;


-- Q12. Find the top 3 customers by total spending.
SELECT
    c.customer_id,
    c.customer_name,
    c.region,
    SUM(o.quantity * p.unit_price) AS total_spending
FROM customers AS c
LEFT JOIN orders   AS o ON c.customer_id = o.customer_id
LEFT JOIN products AS p ON o.product_id  = p.product_id
GROUP BY c.customer_id, c.customer_name, c.region
ORDER BY total_spending DESC
LIMIT 3;


-- Q13. Find customers who have never placed an order.
SELECT
    c.customer_id,
    c.customer_name
FROM customers AS c
LEFT JOIN orders AS o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- Q14. Find the highest-spending customer in each region.
WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.region,
        SUM(o.quantity * p.unit_price) AS total_spending
    FROM customers AS c
    LEFT JOIN orders   AS o ON c.customer_id = o.customer_id
    LEFT JOIN products AS p ON o.product_id  = p.product_id
    GROUP BY c.customer_id, c.customer_name, c.region
),
ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY region
            ORDER BY total_spending DESC
        ) AS spending_rank
    FROM customer_spending
)
SELECT customer_id, customer_name, region, total_spending
FROM ranked
WHERE spending_rank = 1;


-- Q15. Find customers whose spending is above the average
--      spending per customer (among those who placed orders).
WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(o.quantity * p.unit_price) AS total_spending
    FROM customers AS c
    JOIN orders   AS o ON c.customer_id = o.customer_id
    JOIN products AS p ON o.product_id  = p.product_id
    GROUP BY c.customer_id, c.customer_name
),
with_avg AS (
    SELECT
        *,
        AVG(total_spending) OVER () AS avg_spending_per_customer
    FROM customer_spending
)
SELECT customer_id, customer_name, total_spending, avg_spending_per_customer
FROM with_avg
WHERE total_spending > avg_spending_per_customer
ORDER BY total_spending DESC;


-- Q18. Calculate each customer's percentage contribution to total sales revenue.
WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(o.quantity * p.unit_price) AS total_spending
    FROM customers AS c
    LEFT JOIN orders   AS o ON c.customer_id = o.customer_id
    LEFT JOIN products AS p ON o.product_id  = p.product_id
    GROUP BY c.customer_id, c.customer_name
),
with_total AS (
    SELECT
        *,
        SUM(total_spending) OVER () AS total_revenue
    FROM customer_spending
)
SELECT
    customer_id,
    customer_name,
    total_spending,
    ROUND((total_spending / total_revenue) * 100, 2) AS percentage_contribution
FROM with_total
ORDER BY percentage_contribution DESC;
