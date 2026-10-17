# 🛒 Retail Analytics — SQL Project

A hands-on SQL project performing end-to-end sales analysis on a simulated retail dataset using **MySQL 8+**.  
It covers aggregations, JOINs, subqueries, window functions, and CTEs across 20 business questions.

> **Dataset:** 12 customers · 12 products · 20 orders · Prices in ₹ INR · 3 product categories

---

## 📁 Project Structure

```
First-sql-project/
├── schema.sql                  # CREATE TABLE definitions
├── data/
│   └── sample_data.sql         # Realistic INSERT seed data
├── queries/
│   └── sales_analysis.sql      # All 20 analysis queries (formatted)
├── .gitignore
└── README.md
```

---

## 🗄️ Database Schema

The project uses three related tables inside the `retail_analytics` database:

### `customers`
| Column        | Type         | Description               |
|---------------|--------------|---------------------------|
| customer_id   | INT (PK)     | Manual primary key        |
| customer_name | VARCHAR(100) | Full name of the customer |
| region        | VARCHAR(30)  | Geographic region         |

### `products`
| Column     | Type          | Description                   |
|------------|---------------|-------------------------------|
| product_id | INT (PK)      | Manual primary key            |
| product    | VARCHAR(100)  | Product name                  |
| category   | VARCHAR(50)   | Product category              |
| unit_price | DECIMAL(12,2) | Price per unit (in ₹ INR)     |

### `orders`
| Column      | Type     | Description                         |
|-------------|----------|-------------------------------------|
| order_id    | INT (PK) | Manual primary key                  |
| customer_id | INT (FK) | References `customers.customer_id`  |
| product_id  | INT (FK) | References `products.product_id`    |
| order_date  | DATE     | Date the order was placed           |
| quantity    | INT      | Number of units ordered             |

---

## ❓ Analysis Questions

The queries are grouped into four themes:

### 📊 Basic Aggregations
| # | Question |
|---|----------|
| Q1  | Total number of orders |
| Q2  | Total sales revenue |
| Q3  | Total quantity of products sold |
| Q4  | Average order-line revenue |
| Q5  | Unique customers who placed orders |

### 📦 Product Analysis
| # | Question |
|---|----------|
| Q6  | Total revenue per product (ranked) |
| Q7  | Highest-revenue product in each category |
| Q9  | Products with revenue above the average |
| Q17 | Top 2 products by revenue within each category |

### 🗂️ Category Analysis
| # | Question |
|---|----------|
| Q8  | Revenue and % contribution per category |
| Q10 | Category report: revenue, quantity, order count |
| Q16 | Category with the highest total revenue |
| Q19 | Categories with revenue > 20,000 |
| Q20 | Final category summary report |

### 👤 Customer Analysis
| # | Question |
|---|----------|
| Q11 | Total spending per customer with region |
| Q12 | Top 3 customers by spending |
| Q13 | Customers who never placed an order |
| Q14 | Highest-spending customer per region |
| Q15 | Customers above average spending |
| Q18 | Each customer's % contribution to total revenue |

---

## 🚀 Getting Started

### Prerequisites
- MySQL 8.0 or higher
- A MySQL client (MySQL Workbench, DBeaver, or the `mysql` CLI)

### Setup Instructions

**Step 1 — Create the schema:**
```sql
SOURCE schema.sql;
```

**Step 2 — Load sample data:**
```sql
SOURCE data/sample_data.sql;
```

**Step 3 — Run the analysis queries:**
```sql
SOURCE queries/sales_analysis.sql;
```

> Or open each file individually in your SQL client and execute.

---

## 🧠 SQL Concepts Covered

| Concept | Used In |
|---------|---------|
| `GROUP BY` + Aggregates | Q1–Q3, Q6, Q10 |
| `JOIN` (INNER, LEFT) | Q2, Q5, Q11–Q15 |
| Subqueries / CTEs | Q7–Q9, Q14–Q15, Q17–Q20 |
| Window Functions (`ROW_NUMBER`, `RANK`, `AVG OVER`) | Q7, Q9, Q14, Q15, Q17 |
| `HAVING` clause | Q19 |
| Percentage calculations | Q8, Q18, Q20 |

---

## 📌 Notes

- Revenue is calculated as `quantity × unit_price` throughout all queries.
- Customers with **no orders** are preserved using `LEFT JOIN` (see Q13).
- Window functions require **MySQL 8.0+**.

---

## 👤 Author

**Abdul WAheed**  
📧 waheedfq5327tu@gmail.com  
🔗 [LinkedIn](https://linkedin.com/in/awaheedu116) | [GitHub](https://github.com/AbdulWaheed-116)

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
