-- ============================================================
--  Retail Analytics Database — Sample Data
--  Run schema.sql first before executing this file.
-- ============================================================

USE retail_analytics;

-- ------------------------------------------------------------
-- Customers  (12 records | Regions: North, South, East, West)
-- Note: customers 11 & 12 have no orders → used in Q13
-- ------------------------------------------------------------
INSERT INTO customers VALUES
(1,  'Rahul',   'North'),
(2,  'Priya',   'South'),
(3,  'Aman',    'North'),
(4,  'Neha',    'West'),
(5,  'Ravi',    'East'),
(6,  'Sneha',   'North'),
(7,  'Arjun',   'South'),
(8,  'Pooja',   'West'),
(9,  'Kiran',   'East'),
(10, 'Vikram',  'South'),
(11, 'Ananya',  'West'),
(12, 'Suresh',  'North');

-- ------------------------------------------------------------
-- Products  (12 records | Categories: Electronics, Furniture, Stationery)
-- Prices in INR ₹
-- ------------------------------------------------------------
INSERT INTO products VALUES
(101, 'Laptop',      'Electronics', 55000.00),
(102, 'Mouse',       'Electronics',   800.00),
(103, 'Office Chair','Furniture',    6500.00),
(104, 'Keyboard',    'Electronics',  1500.00),
(105, 'Desk',        'Furniture',    9000.00),
(106, 'Monitor',     'Electronics', 18000.00),
(107, 'Notebook',    'Stationery',    120.00),
(108, 'Printer',     'Electronics', 14500.00),
(109, 'Headphones',  'Electronics',  3500.00),
(110, 'Webcam',      'Electronics',  2500.00),
(111, 'Bookshelf',   'Furniture',    7500.00),
(112, 'Pen Set',     'Stationery',    250.00);

-- ------------------------------------------------------------
-- Orders  (20 records)
-- ------------------------------------------------------------
INSERT INTO orders VALUES
(1001,  1, 101, '2026-01-05',  2),
(1002,  2, 102, '2026-01-07',  5),
(1003,  3, 103, '2026-01-10',  3),
(1004,  4, 104, '2026-01-12',  4),
(1005,  5, 105, '2026-01-15',  2),
(1006,  6, 106, '2026-01-18',  2),
(1007,  7, 107, '2026-01-20', 20),
(1008,  4, 108, '2026-01-22',  1),
(1009,  1, 105, '2026-01-25',  1),
(1010,  3, 106, '2026-01-27',  1),
(1011,  6, 104, '2026-02-02',  3),
(1012,  2, 108, '2026-02-04',  1),
(1013,  9, 109, '2026-02-08',  2),
(1014, 10, 102, '2026-02-10',  3),
(1015,  5, 110, '2026-02-12',  1),
(1016,  7, 111, '2026-02-15',  1),
(1017,  8, 112, '2026-02-18', 10),
(1018,  9, 106, '2026-02-20',  1),
(1019, 10, 103, '2026-02-22',  2),
(1020,  1, 109, '2026-02-25',  1);
