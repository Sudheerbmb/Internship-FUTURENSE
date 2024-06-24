/*Concepts Explanation:
TCL Commands:

Commit: Saves a transaction to the database permanently.
Rollback: Undoes a transaction or change that hasn't been saved to the database.
Savepoint: Temporarily saves a transaction for later rollback to a specific point.
Triggers:

After Insert: Trigger that activates after data is inserted into a table.
Before Insert: Trigger that activates before data is inserted into a table.
After Update: Trigger that activates after data in a table is updated.
After Delete: Trigger that activates after data is deleted from a table.
Before Delete: Trigger that activates before data is deleted from a table.
Views:

Create or Replace View: Creates a new view or replaces an existing view with the new query provided.
Drop View: Removes a view from the database if it exists.*/

-- Create database
CREATE DATABASE amazon;
USE amazon;

-- Products - pid, pname, price, stock, location (Mumbai or Delhi)
CREATE TABLE products (
    pid INT(3) PRIMARY KEY,
    pname VARCHAR(50) NOT NULL,
    price INT(10) NOT NULL,
    stock INT(5),
    location VARCHAR(30) CHECK(location IN ('Mumbai','Delhi'))
);

-- Customer - cid, cname, age, addr
CREATE TABLE customer (
    cid INT(3) PRIMARY KEY,
    cname VARCHAR(30) NOT NULL,
    age INT(3),
    addr VARCHAR(50)
);

-- Orders - oid, cid, pid, amt
CREATE TABLE orders (
    oid INT(3) PRIMARY KEY,
    cid INT(3),
    pid INT(3),
    amt INT(10) NOT NULL,
    FOREIGN KEY(cid) REFERENCES customer(cid),
    FOREIGN KEY(pid) REFERENCES products(pid)
);

-- Payment - pay_id, oid, amount, mode (upi, credit, debit), status
CREATE TABLE payment (
    pay_id INT(3) PRIMARY KEY,
    oid INT(3),
    amount INT(10) NOT NULL,
    mode VARCHAR(30) CHECK(mode IN('upi','credit','debit')),
    status VARCHAR(30),
    FOREIGN KEY(oid) REFERENCES orders(oid)
);

-- Inserting values into products table
INSERT INTO products VALUES(1,'HP Laptop',50000,15,'Mumbai');
INSERT INTO products VALUES(2,'Realme Mobile',20000,30,'Delhi');
INSERT INTO products VALUES(3,'Boat earpods',3000,50,'Delhi');
INSERT INTO products VALUES(4,'Levono Laptop',40000,15,'Mumbai');
INSERT INTO products VALUES(5,'Charger',1000,0,'Mumbai');
INSERT INTO products VALUES(6, 'Mac Book', 78000, 6, 'Delhi');
INSERT INTO products VALUES(7, 'JBL speaker', 6000, 2, 'Delhi');

-- Inserting values into customer table
INSERT INTO customer VALUES(101,'Ravi',30,'fdslfjl');
INSERT INTO customer VALUES(102,'Rahul',25,'fdslfjl');
INSERT INTO customer VALUES(103,'Simran',32,'fdslfjl');
INSERT INTO customer VALUES(104,'Purvesh',28,'fdslfjl');
INSERT INTO customer VALUES(105,'Sanjana',22,'fdslfjl');

-- Inserting values into orders table
INSERT INTO orders VALUES(10001,102,3,2700);
INSERT INTO orders VALUES(10002,104,2,18000);
INSERT INTO orders VALUES(10003,105,5,900);
INSERT INTO orders VALUES(10004,101,1,46000);

-- Inserting values into payments table
INSERT INTO payment VALUES(1,10001,2700,'upi','completed');
INSERT INTO payment VALUES(2,10002,18000,'credit','completed');
INSERT INTO payment VALUES(3,10003,900,'debit','in process');

-- Triggers

-- SQL Trigger for Logging Product Insertions
DELIMITER //
CREATE TRIGGER products_after_insert
AFTER INSERT ON products
FOR EACH ROW
BEGIN
  INSERT INTO product_log (pid, pname, price, stock, location, inserted_at)
  VALUES (NEW.pid, NEW.pname, NEW.price, NEW.stock, NEW.location, NOW());
END //
DELIMITER ;

-- SQL trigger to automatically update product stock levels after each new order is inserted into the 'orders' table
DELIMITER //
CREATE TRIGGER orders_after_insert
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
  UPDATE products
  SET stock = stock - 1
  WHERE pid = NEW.pid;
END //
DELIMITER ;

-- SQL trigger to log changes made to product information whenever an update occurs in the 'products' table
DELIMITER //
CREATE TRIGGER products_after_update
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
  IF OLD.pid <> NEW.pid OR OLD.pname <> NEW.pname OR OLD.price <> NEW.price OR OLD.stock <> NEW.stock OR OLD.location <> NEW.location THEN
    INSERT INTO product_log (pid, pname, price, stock, location, updated_at)
    VALUES (OLD.pid, OLD.pname, OLD.price, OLD.stock, OLD.location, NOW());
  END IF;
END //
DELIMITER ;

-- SQL trigger to prevent the deletion of a product from the 'products' table if there are existing orders referencing that product in the 'orders' table
DELIMITER //
CREATE TRIGGER products_after_delete
AFTER DELETE ON products
FOR EACH ROW
BEGIN
  DECLARE has_orders INT DEFAULT (0);

  SELECT COUNT(*) INTO has_orders
  FROM orders
  WHERE pid = OLD.pid;

  IF has_orders > 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete product with existing orders. Update or delete orders first.';
  END IF;
END //
DELIMITER ;

-- Trigger for Automatic Payment Status on Payment Insert
DELIMITER //
CREATE TRIGGER set_default_payment_status
BEFORE INSERT ON payment
FOR EACH ROW
BEGIN
  IF NEW.status IS NULL THEN
    SET NEW.status = 'Pending';
  END IF;
END //
DELIMITER ;

-- Create or Replace Views

CREATE OR REPLACE VIEW active_customers_mumbai AS
SELECT c.cid, c.cname, c.addr
FROM customer c
WHERE c.age > 25 AND c.addr LIKE '%Mumbai%';

CREATE VIEW CustomerOrders AS
SELECT c.cid, c.cname, o.oid, o.amt, p.pname
FROM customer c
JOIN orders o ON c.cid = o.cid
JOIN products p ON o.pid = p.pid;

CREATE VIEW TotalOrdersByLocation AS
SELECT p.location, p.pname, COUNT(o.oid) AS total_orders
FROM products p
JOIN orders o ON p.pid = o.pid
GROUP BY p.location, p.pname;

CREATE VIEW OrderPaymentStatus AS
SELECT o.oid, o.amt, p.mode, p.status
FROM orders o
JOIN payment p ON o.oid = p.oid;

-- Drop Views
DROP VIEW active_customers_mumbai;
DROP VIEW TotalOrdersByLocation;

-- Questions

-- 1) Trigger to update status in payment table after an order is completed:
DELIMITER //
CREATE TRIGGER update_payment_status
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    IF NEW.status = 'completed' THEN
        UPDATE payment
        SET status = 'completed'
        WHERE oid = NEW.oid;
    END IF;
END //
DELIMITER ;

-- 2) Trigger to check stock availability before inserting an order:
DELIMITER //
CREATE TRIGGER check_stock_before_order
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    DECLARE available_stock INT;
    SELECT stock INTO available_stock FROM products WHERE pid = NEW.pid;
    IF available_stock < NEW.amt THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock for this product';
    END IF;
END //
DELIMITER ;

-- 3) Trigger to update stock after an order is placed:
DELIMITER //
CREATE TRIGGER update_stock_after_order
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    UPDATE products
    SET stock = stock - NEW.amt
    WHERE pid = NEW.pid;
END // 
DELIMITER ;

-- TCL Commands

-- 1) Saving the command permanently after running successfully
START TRANSACTION;
INSERT INTO products (pid, pname, price, stock, location) VALUES (8, 'iPhone 12', 79900, 10, 'Delhi');
INSERT INTO customer (cid, cname, age, addr) VALUES (106, 'John Doe', 35, '123 Main Street');
INSERT INTO orders (oid, cid, pid, amt) VALUES (10005, 106, 8, 79900);
INSERT INTO payment (pay_id, oid, amount, mode, status) VALUES (1, 10005, 79900, 'credit', 'completed');
COMMIT;

-- 2) Going to the previous command
START TRANSACTION;
INSERT INTO products (pid, pname, price, stock, location) VALUES (8, 'iPhone 12', 79900, 10, 'Delhi');
INSERT INTO customer (cid, cname, age, addr) VALUES (106, 'John Doe', 35, '123 Main Street');
INSERT INTO orders (oid, cid, pid, amt) VALUES (10005, 106, 8, 79900);
INSERT INTO payment (pay_id, oid, amount, mode, status) VALUES (1, 10005, 79900, 'credit', 'completed');
ROLLBACK;

-- 3) Going to a checkpoint where you want to go after saving the checkpoint
START TRANSACTION;
INSERT INTO products (pid, pname, price, stock, location) VALUES (8, 'iPhone 12', 79900, 10, 'Delhi');
INSERT INTO customer (cid, cname, age, addr) VALUES (106, 'John Doe', 35, '123 Main Street');
INSERT INTO orders (oid, cid, pid, amt) VALUES (10005, 106, 8, 79900);
INSERT INTO payment (pay_id, oid, amount, mode, status) VALUES (1, 10005, 79900, 'credit', 'completed');
SAVEPOINT A;
ROLLBACK TO A;

-- Views

-- 1) Create a view that displays the customers with their corresponding orders.
CREATE VIEW CustomerOrders AS
SELECT c.cid, c.cname, o.oid, o.amt, p.pname
FROM customer c
JOIN orders o ON c.cid = o.cid
JOIN products p ON o.pid = p.pid;

-- 2) Create or Replace View to show payment details with order and customer information
CREATE OR REPLACE VIEW payment_order_customer_details AS
SELECT p.pay_id, p.oid, o.cid, c.cname, c.age, c.addr, p.amount, p.mode, p.status
FROM payment p
JOIN orders o ON p.oid = o.oid
JOIN customer c ON o.cid = c.cid;

-- 3) Drop View if it exists
DROP VIEW IF EXISTS payment_order_customer_details;
