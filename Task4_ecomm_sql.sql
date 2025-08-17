create database ecomm;
use ecomm;

create table ecomm_sql(
invoice_no int,
stock_code varchar(20),
descp varchar(50),
quantity int,
invoice_date datetime,
unit_price decimal(10,2),
customer_id int,
country varchar(30)
);

select * from ecomm_sql;

INSERT INTO ecomm_sql VALUES
('536365', '85123A', 'WHITE HANGING HEART T-LIGHT HOLDER', 6, '2010-12-01 08:26:00', 2.55, 17850, 'United Kingdom'),
('536365', '71053', 'WHITE METAL LANTERN', 6, '2010-12-01 08:26:00', 3.39, 17850, 'United Kingdom'),
('536366', '84406B', 'CREAM CUPID HEARTS COAT HANGER', 8, '2010-12-01 08:28:00', 2.75, 17850, 'United Kingdom'),
('536367', '84029G', 'KNITTED UNION FLAG HOT WATER BOTTLE', 6, '2010-12-01 08:34:00', 3.39, 13047, 'United Kingdom'),
('536368', '22960', 'JAM MAKING SET PRINTED', 6, '2010-12-01 08:34:00', 4.25, 13047, 'France'),
('536369', '21730', 'GLASS STAR FROSTED T-LIGHT HOLDER', 6, '2010-12-01 08:45:00', 4.25, 12583, 'Germany');

select * from ecomm_sql
WHERE country = 'Germany';

select * from ecomm_sql
where quantity > 5;

select customer_id,
sum(quantity * unit_price) as total_purchase
from ecomm_sql
group by customer_id
order by total_purchase desc;

create table product_category(
stock_code varchar(20),
category varchar(50)
);

insert into product_category values
('85123A', 'Home Decor'),
('71053', 'Lighting'),
('84406B', 'Furniture'),
('84029G', 'Bedding'),
('22960', 'Kitchen'),
('21730', 'Glassware');

-- JOINS Queries:-
-- INNER JOIN: Show products with their categories
SELECT e.invoice_no, e.descp, c.category, e.quantity, e.quantity * unit_price
FROM ecomm_sql e
INNER JOIN product_category c
ON e.stock_code = c.stock_code;

-- LEFT JOIN: Show all sales, even if product has no category
SELECT e.descp, c.category, e.quantity * unit_price
FROM ecomm_sql e
LEFT JOIN product_category c
ON e.stock_code = c.stock_code;

-- RIGHT JOIN: Show all categories, even if no sales happened
SELECT e.descp, c.category
FROM ecomm_sql e
RIGHT JOIN product_category c
ON e.stock_code = c.stock_code;

-- SubQueries
-- 1. Customers who spent more than average spending
SELECT customer_id,
SUM(quantity * unit_price) AS total_spent
FROM ecomm_sql
GROUP BY customer_id
HAVING total_spent > (
SELECT AVG(quantity * unit_price)
FROM ecomm_sql
);

-- 2. Find top-selling product using subquery
SELECT descp, SUM(quantity * unit_price) AS revenue
FROM ecomm_sql
GROUP BY descp
HAVING SUM(quantity * unit_price) = (
    SELECT MAX(revenue) 
    FROM (
        SELECT SUM(quantity * unit_price) AS revenue
        FROM ecomm_sql
        GROUP BY descp
    ) AS t
);

-- AGGREGATE FUCNTIONS
-- Total revenue
SELECT SUM(quantity * unit_price) AS total_revenue 
FROM ecomm_sql;

-- Average order value
SELECT AVG(quantity * unit_price) AS avg_order_value 
FROM ecomm_sql;

-- Total number of invoices
SELECT COUNT(DISTINCT invoice_no) AS total_invoices 
FROM ecomm_sql;

-- Min & Max quantity sold
SELECT MIN(quantity) AS min_qty, MAX(quantity) AS max_qty 
FROM ecomm_sql;

-- VIEWS
-- View for monthly sales
CREATE VIEW monthly_sales AS
SELECT DATE_FORMAT(invoice_date, '%Y-%m') AS month, SUM(quantity * unit_price) AS total_sales
FROM ecomm_sql
GROUP BY DATE_FORMAT(invoice_date, '%Y-%m');

-- View for top 5 customers
CREATE VIEW top_customers AS
SELECT customer_id, SUM(quantity * unit_price) AS total_spent
FROM ecomm_sql
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;

SELECT * FROM monthly_sales;
SELECT * FROM top_customers;


-- INDEX OPTIMIZATION
-- Add index on customer_id for faster customer lookups
CREATE INDEX idx_customer ON ecomm_sql(customer_id);

-- Add composite index on (invoice_date, country) for time + region analysis
CREATE INDEX idx_date_country ON ecomm_sql(invoice_date, country);

SHOW INDEXES FROM ecomm_sql;

