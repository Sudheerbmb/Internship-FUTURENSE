-- Create database
CREATE DATABASE amazon;

-- Use the database
USE amazon;

-- Create tables

-- Customer table
CREATE TABLE customer (
    cid INT PRIMARY KEY,
    cname VARCHAR(255),
    age INT,
    addr VARCHAR(255)
);

-- Products table
CREATE TABLE products (
    pid INT PRIMARY KEY,
    pname VARCHAR(255),
    price DECIMAL(10, 2),
    stock INT,
    location VARCHAR(255)
);

-- Orders table
CREATE TABLE orders (
    oid INT PRIMARY KEY,
    cid INT,
    amt DECIMAL(10, 2),
    FOREIGN KEY (cid) REFERENCES customer(cid)
);


-- Insert data into customer table
INSERT INTO customer (cid, cname, age, addr) VALUES
(1, 'Alice', 30, 'Mumbai, India'),
(2, 'Bob', 25, 'Delhi, India'),
(3, 'Charlie', 35, 'Bangalore, India'),
(4, 'David', 28, 'Mumbai, India');

-- Insert data into products table
INSERT INTO products (pid, pname, price, stock, location) VALUES
(1, 'Laptop', 45000.00, 15, 'Mumbai'),
(2, 'Mobile', 15000.00, 30, 'Delhi'),
(3, 'Tablet', 20000.00, 5, 'Bangalore'),
(4, 'Headphones', 5000.00, 25, 'Mumbai'),
(5, 'Charger', 1000.00, 50, 'Delhi');

-- Insert data into orders table
INSERT INTO orders (oid, cid, amt) VALUES
(1, 1, 45000.00),
(2, 2, 15000.00),
(3, 3, 20000.00),
(4, 1, 5000.00),
(5, 4, 1000.00),
(6, 2, 2000.00),
(7, 3, 3000.00);


-- GROUP BY Examples
SELECT cname, COUNT(*) AS Number
FROM customer
GROUP BY cname
HAVING Number >= 1;

SELECT location, GROUP_CONCAT(DISTINCT pname) AS product_names
FROM products
GROUP BY location;

-- GROUP BY Questions
SELECT location, SUM(stock) AS total_stock 
FROM products 
GROUP BY location;

SELECT CASE 
 WHEN price BETWEEN 0 AND 10000 THEN '0-10000' 
 WHEN price BETWEEN 10001 AND 20000 THEN '10000-20000'
 WHEN price BETWEEN 20001 AND 50000 THEN '20000-50000' 
 ELSE '50000+' 
 END AS price_range, COUNT(*) AS product_count
 FROM products 
 GROUP BY price_range;

SELECT SUBSTRING(addr, 1, 3) AS location, AVG(age) AS avg_age 
FROM customer 
GROUP BY location;

-- ORDER BY Examples
SELECT pid, pname, price
FROM products
ORDER BY price ASC;

SELECT cid, cname, age
FROM customer
ORDER BY age DESC;

-- ORDER BY Questions
SELECT * 
FROM products 
ORDER BY price DESC;

SELECT * 
FROM customer 
ORDER BY age ASC;

SELECT o.oid, c.cname, o.amt 
FROM orders o 
JOIN customer c ON o.cid = c.cid 
ORDER BY o.amt DESC, c.cname ASC;

-- HAVING BY Examples
SELECT pid, pname, stock
FROM products
GROUP BY pid, pname, stock
HAVING stock < 10;

SELECT location, SUM(stock) AS total_stock
FROM products
GROUP BY location
HAVING SUM(stock) > 50;

-- HAVING Questions
SELECT location, SUM(stock) AS total_stock 
FROM products 
GROUP BY location 
HAVING SUM(stock) > 20;

SELECT c.cid, c.cname, SUM(o.amt) AS total_amount 
FROM customer c 
JOIN orders o ON c.cid = o.cid 
GROUP BY c.cid, c.cname 
HAVING SUM(o.amt) > 10000;

SELECT p.pid, p.pname, p.stock 
FROM products p 
WHERE p.location = 'Mumbai' 
GROUP BY p.pid, p.pname, p.stock 
HAVING p.stock BETWEEN 10 AND 20;

-- DQL COMMANDS

-- A) SELECT With DISTINCT Clause
SELECT DISTINCT cname, addr FROM customer;

-- B) SELECT all columns(*)
SELECT * FROM orders;

-- C) SELECT by column name
SELECT oid FROM orders;

-- D) SELECT with LIKE(%)

-- a) "Ra" anywhere
SELECT * FROM customer WHERE cname LIKE "%Ra%";

-- b) Begins With "Ra"
SELECT * FROM customer WHERE cname LIKE "Ra%";

-- c) Ends With "vi"
SELECT * FROM customer WHERE cname LIKE "%vi";

-- E) SELECT with CASE or IF

-- a) CASE
SELECT cid,
       cname,
       CASE WHEN cid > 102 THEN 'Pass' ELSE 'Fail' END AS 'Remark'
FROM customer;

-- b) IF
SELECT cid,
       cname,
       IF(cid > 102, 'Pass', 'Fail') AS 'Remark'
FROM customer;

-- F) SELECT with a LIMIT Clause
SELECT * 
FROM customer
ORDER BY cid
LIMIT 2;

-- G) SELECT with WHERE
SELECT * FROM customer WHERE cname = "Ravi";


-- ------------------------------------------QUESTIONS-------------------------------------------------------------

-- 1)
SELECT DISTINCT location 
FROM products;

-- 2)
SELECT cid, cname, LENGTH(addr) AS address_length
FROM customer;

-- 3)
SELECT o.oid, c.cname, p.pname, CONCAT('Order for ', p.pname, ' by ', c.cname) AS order_description
FROM orders o
JOIN customer c ON o.cid = c.cid
JOIN products p ON o.pid = p.pid;

-- 4)
SELECT pid, pname, price,
       CASE
           WHEN price < 10000 THEN 'Low'
           WHEN price BETWEEN 10000 AND 50000 THEN 'Medium'
           ELSE 'High'
       END AS price_category
FROM products;

-- 5)
SELECT c.cid, c.cname, (
    SELECT SUM(amt)
    FROM orders o
    WHERE o.cid = c.cid
) AS total_order_amount
FROM customer c;





SELECT CHAR_LENGTH('Hello, World!');
SELECT ASCII('A');
SELECT ASCII('abc');
SELECT CONCAT('Hello', ' ', 'World');
SELECT INSTR('Hello, World!', 'o');
SELECT INSTR('Hello, World!', 'x');
SELECT LCASE('HELLO');
SELECT LOWER('SupPorT');
SELECT UCASE('hello');
SELECT UPPER('SupPorT');
SELECT SUBSTR('Hello, World!', 8, 5);
SELECT SUBSTR('Hello, World!', 1, 5);
SELECT LPAD('Hello', 10, '*');
SELECT RPAD('Hello', 10, '*');
SELECT TRIM('   Hello, World!   ');
SELECT RTRIM('   Hello, World!   ');
SELECT LTRIM('   Hello, World!   ');

### Date and Time Functions

SELECT CURRENT_DATE() AS today;
SELECT DATEDIFF('2023-05-10', '2023-05-01') AS day_difference;
SELECT DATE('2023-05-01 12:34:56') AS result;
SELECT CURRENT_TIME() AS now;
SELECT LAST_DAY('2023-05-01') AS last_day_of_may;
SELECT SYSDATE() AS `Timestamp`;
SELECT ADDDATE('2023-05-01', INTERVAL 7 DAY) AS one_week_later;

### Numeric Functions

SELECT AVG(price) AS avg_price
FROM products;

SELECT COUNT(*) AS total_products
FROM products;

SELECT POW(2, 3) AS result;

SELECT MIN(price) AS min_price
FROM products;

SELECT MAX(stock) AS max_stock, location
FROM products
GROUP BY location;

SELECT ROUND(3.1416, 2) AS result;
SELECT ROUND(3.1416) AS result;

SELECT SQRT(25) AS result;

SELECT FLOOR(3.8) AS result;
SELECT FLOOR(-3.8) AS result;

