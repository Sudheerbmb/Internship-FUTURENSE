drop database amazon;

CREATE DATABASE amazon;

USE amazon;

CREATE TABLE products (
    pid INT(3) PRIMARY KEY,
    pname VARCHAR(50) NOT NULL,
    price INT(10) NOT NULL,
    stock INT(5),
    location VARCHAR(30) CHECK(location IN ('Mumbai','Delhi'))
);

CREATE TABLE customer (
    cid INT(3) PRIMARY KEY,
    cname VARCHAR(30) NOT NULL,
    age INT(3),
    addr VARCHAR(50)
);

CREATE TABLE orders (
    oid INT(3) PRIMARY KEY,
    cid INT(3),
    pid INT(3),
    amt INT(10) NOT NULL,
    FOREIGN KEY(cid) REFERENCES customer(cid),
    FOREIGN KEY(pid) REFERENCES products(pid)
);

CREATE TABLE payment (
    pay_id INT(3) PRIMARY KEY,
    oid INT(3),
    amount INT(10) NOT NULL,
    mode VARCHAR(30) CHECK(mode IN('upi','credit','debit')),
    status VARCHAR(30),
    FOREIGN KEY(oid) REFERENCES orders(oid)
);

CREATE TABLE employee (
    eid INT(4) PRIMARY KEY,
    ename VARCHAR(40) NOT NULL,
    phone_no INT(10) NOT NULL,
    department VARCHAR(40) NOT NULL,
    manager_id INT(4)
);

INSERT INTO products VALUES (1, 'HP Laptop', 50000, 15, 'Mumbai');
INSERT INTO products VALUES (2, 'Realme Mobile', 20000, 30, 'Delhi');
INSERT INTO products VALUES (3, 'Boat earpods', 3000, 50, 'Delhi');
INSERT INTO products VALUES (4, 'Levono Laptop', 40000, 15, 'Mumbai');
INSERT INTO products VALUES (5, 'Charger', 1000, 0, 'Mumbai');
INSERT INTO products VALUES (6, 'Mac Book', 78000, 6, 'Delhi');
INSERT INTO products VALUES (7, 'JBL speaker', 6000, 2, 'Delhi');

INSERT INTO customer VALUES (101, 'Ravi', 30, 'fdslfjl');
INSERT INTO customer VALUES (102, 'Rahul', 25, 'fdslfjl');
INSERT INTO customer VALUES (103, 'Simran', 32, 'fdslfjl');
INSERT INTO customer VALUES (104, 'Purvesh', 28, 'fdslfjl');
INSERT INTO customer VALUES (105, 'Sanjana', 22, 'fdslfjl');

INSERT INTO orders VALUES (10001, 102, 3, 2700);
INSERT INTO orders VALUES (10002, 104, 2, 18000);
INSERT INTO orders VALUES (10003, 105, 5, 900);
INSERT INTO orders VALUES (10004, 101, 1, 46000);

INSERT INTO payment VALUES (1, 10001, 2700, 'upi', 'completed');
INSERT INTO payment VALUES (2, 10002, 18000, 'credit', 'completed');
INSERT INTO payment VALUES (3, 10003, 900, 'debit', 'in process');

INSERT INTO employee VALUES (401, 'Rohan', 364832549, 'Analysis', 404);
INSERT INTO employee VALUES (402, 'Rahul', 782654123, 'Delivery', 406);
INSERT INTO employee VALUES (403, 'Shyam', 856471235, 'Delivery', 402);
INSERT INTO employee VALUES (404, 'Neha', 724863287, 'Sales', 402);
INSERT INTO employee VALUES (405, 'Sanjana', 125478954, 'HR', 404);
INSERT INTO employee VALUES (406, 'Sanjay', 956478535, 'Tech', NULL);

SELECT * FROM products;
SELECT * FROM customer;
SELECT * FROM orders;
SELECT * FROM payment;
SELECT * FROM employee;

SELECT customer.cid, cname, orders.oid FROM orders 
INNER JOIN customer ON orders.cid = customer.cid;

SELECT customer.cid, cname, products.pid, pname, oid FROM orders
INNER JOIN products ON orders.pid = products.pid
INNER JOIN customer ON orders.cid = customer.cid;

SELECT products.pid, pname, amt, orders.oid FROM products
LEFT JOIN orders ON orders.pid = products.pid;

SELECT * FROM payment 
RIGHT JOIN orders ON orders.oid = payment.oid;

SELECT orders.oid, products.pid, pname, amt, price, stock, location FROM orders
LEFT JOIN products ON orders.pid = products.pid
UNION
SELECT orders.oid, products.pid, pname, amt, price, stock, location FROM orders
RIGHT JOIN products ON orders.pid = products.pid;

SELECT e1.ename AS Employee, e2.ename AS Manager FROM employee e1
INNER JOIN employee e2 ON e1.manager_id = e2.eid;

SELECT customer.cid, cname, orders.oid, amt FROM customer
CROSS JOIN orders ON customer.cid = orders.cid
WHERE amt > 3000;

SELECT * FROM orders 
LEFT JOIN products ON orders.pid = products.pid
WHERE location = 'Mumbai';

SELECT * FROM orders
RIGHT JOIN payment ON orders.oid = payment.oid
WHERE mode = 'UPI';

SELECT orders.oid, cname, amt, mode FROM orders
INNER JOIN payment ON orders.oid = payment.oid
INNER JOIN customer ON orders.cid = customer.cid
WHERE age < 30;

SELECT orders.oid, cname, amt, mode FROM orders
INNER JOIN payment ON orders.oid = payment.oid
INNER JOIN customer ON orders.cid = customer.cid
WHERE age < 30 AND mode = 'credit';

SELECT orders.oid, cname, pname, amount, status, location FROM orders
CROSS JOIN products ON orders.pid = products.pid
CROSS JOIN customer ON orders.cid = customer.cid
CROSS JOIN payment ON orders.oid = payment.oid
WHERE status IN ('in process', 'pending');

SELECT orders.cid, cname, pname FROM orders
INNER JOIN customer ON orders.cid = customer.cid
INNER JOIN products ON orders.pid = products.pid;



-- Update Anomaly
UPDATE Products SET price = 52000 WHERE pid = 1;

-- Delete Anomaly
DELETE FROM Products WHERE pid = 5;

-- Insertion Anomaly
INSERT INTO Orders (oid, cid, pid, amt) VALUES (10005, 106, 2, 1);

-- Candidate Keys and Primary Key
SELECT pid, pname, price, stock, location FROM Products;

-- Foreign Keys
SELECT o.oid, c.cname, o.pid FROM Orders o INNER JOIN Customer c ON o.cid = c.cid WHERE o.cid = 102;

-- Creating a table with Primary Key
CREATE TABLE products (
    pid int(3) PRIMARY KEY,
    pname varchar(50) NOT NULL,
    price int(10) NOT NULL,
    stock int(5),
    location varchar(30) CHECK(location IN ('Mumbai', 'Delhi'))
);

-- Adding Primary Key to an already existing table
ALTER TABLE products ADD PRIMARY KEY (pid);

-- Deleting Primary Key from a table
ALTER TABLE products DROP PRIMARY KEY;

-- Creating a table with Foreign Key
CREATE TABLE orders (
    oid int(3) PRIMARY KEY,
    cid int(3),
    pid int(3),
    amt int(10) NOT NULL,
    FOREIGN KEY (cid) REFERENCES customer(cid),
    FOREIGN KEY (pid) REFERENCES products(pid)
);

-- Adding Foreign Key to an already existing table
ALTER TABLE orders ADD FOREIGN KEY (pid) REFERENCES products(pid);

-- Removing Foreign Key from a table
ALTER TABLE products DROP FOREIGN KEY products_ibfk_1;

-- Decomposing to BCNF
CREATE TABLE order_info (
    oid int(3) PRIMARY KEY,
    amt int(10) NOT NULL,
    FOREIGN KEY (oid) REFERENCES orders(oid)
);

CREATE TABLE order_details (
    oid int(3),
    cid int(3),
    pid int(3),
    PRIMARY KEY (oid, cid, pid),
    FOREIGN KEY (oid) REFERENCES orders(oid),
    FOREIGN KEY (cid) REFERENCES customer(cid),
    FOREIGN KEY (pid) REFERENCES products(pid)
);





-- ANOMALIES: Undesirable conditions in a relational database leading to data inconsistency.
-- Insertion Anomalies: Occur when you cannot insert valid data due to table structure.
-- Deletion Anomalies: Occur when deleting a row also deletes unrelated data.
-- Update Anomalies: Occur when updating a value in one row requires changes in other rows to maintain consistency.

-- CANDIDATE KEYS: Attributes or combinations of attributes that uniquely identify each row in a table.
-- PRIMARY KEY: A column or set of columns that uniquely identifies each record in a table. Must be unique and not null.

-- FOREIGN KEY: A column or group of columns in a table that establishes a link between data in two tables by referencing the primary key of another table.

-- NORMALIZATION: Process of minimizing redundancy and dependency by organizing fields and table of a database.
-- 1NF (First Normal Form): Ensures table has only single-valued attributes and no repeating groups.
-- 2NF (Second Normal Form): Achieved when table is in 1NF and all non-key attributes depend on the entire primary key.
-- 3NF (Third Normal Form): Achieved when table is in 2NF and all non-key attributes depend only on the primary key.
-- BCNF (Boyce-Codd Normal Form): A stricter version of 3NF where every determinant must be a candidate key.

-- SQL Queries to demonstrate:
-- Update Anomaly: Issues when updating product prices in multiple tables.
-- Delete Anomaly: Issues when deleting products with existing orders.
-- Insertion Anomaly: Issues when inserting orders for non-existent customers.
-- Creating tables with primary and foreign keys.
-- Altering tables to add or remove primary and foreign keys.
-- Decomposing tables to achieve BCNF.


