-- ============================================================
--  Retail Analytics Database — Schema
--  Database : retail_analytics
--  Dialect  : MySQL 8+
-- ============================================================

CREATE DATABASE IF NOT EXISTS retail_analytics;
USE retail_analytics;

-- Drop in order to respect foreign key constraints
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;

-- ------------------------------------------------------------
-- Table: customers
-- ------------------------------------------------------------
CREATE TABLE customers (
    customer_id   INT          PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    region        VARCHAR(30)  NOT NULL
);

-- ------------------------------------------------------------
-- Table: products
-- ------------------------------------------------------------
CREATE TABLE products (
    product_id INT            PRIMARY KEY,
    product    VARCHAR(100)   NOT NULL,
    category   VARCHAR(50)    NOT NULL,
    unit_price DECIMAL(12, 2) NOT NULL
);

-- ------------------------------------------------------------
-- Table: orders
-- ------------------------------------------------------------
CREATE TABLE orders (
    order_id    INT  PRIMARY KEY,
    customer_id INT  NOT NULL,
    product_id  INT  NOT NULL,
    order_date  DATE NOT NULL,
    quantity    INT  NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
    FOREIGN KEY (product_id)  REFERENCES products  (product_id)
);
