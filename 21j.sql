-- Create database
CREATE DATABASE amazon;

-- Use the created database
USE amazon;

-- Create products table
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

-- Create orders table
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    status VARCHAR(20)
);

-- Create payment table
CREATE TABLE payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    amount DECIMAL(10,2),
    status VARCHAR(20),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Create customer table
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100)
);

-- Insert sample data into products table
INSERT INTO products (name, category, price) VALUES
('HP Laptop', 'Electronics', 1000.00),
('Dell Laptop', 'Electronics', 1200.00),
('iPhone', 'Electronics', 800.00),
('Samsung TV', 'Electronics', 1500.00),
('Sony Headphones', 'Electronics', 200.00),
('Nike Shoes', 'Apparel', 150.00),
('Adidas Shoes', 'Apparel', 120.00);

-- Insert sample data into orders table
INSERT INTO orders (status) VALUES
('Completed'),
('Pending'),
('Completed'),
('Shipped');

-- Insert sample data into payment table
INSERT INTO payment (order_id, amount, status) VALUES
(1, 1500.00, 'completed'),
(2, 1200.00, 'pending'),
(1, 500.00, 'completed'),
(3, 800.00, 'completed');

-- Insert sample data into customer table
INSERT INTO customer (name) VALUES
('John Doe'),
('Jane Smith'),
('Alice Johnson');

-- Create procedures and functions

-- PROCEDURE to select all products
DELIMITER $$
CREATE PROCEDURE select_all_products()
BEGIN
    SELECT * FROM products;
END$$
DELIMITER ;

-- FUNCTION to calculate total revenue for completed orders
DELIMITER $$
CREATE FUNCTION get_total_revenue()
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_revenue DECIMAL(10,2);
    SELECT SUM(p.amount) INTO total_revenue
    FROM payment p
    INNER JOIN orders o ON p.order_id = o.order_id
    WHERE o.status = 'Completed';
    RETURN total_revenue;
END$$
DELIMITER ;

-- PROCEDURE to get product details by product ID (IN parameter)
DELIMITER $$
CREATE PROCEDURE get_product_details(IN product_id INT)
BEGIN
    SELECT * FROM products WHERE product_id = product_id;
END$$
DELIMITER ;

-- PROCEDURE to get product count (OUT parameter)
DELIMITER $$
CREATE PROCEDURE get_product_count(OUT total_count INT)
BEGIN
    SELECT COUNT(*) INTO total_count FROM products;
END$$
DELIMITER ;

-- PROCEDURE to calculate total price of electronics products using predefined SUM()
DELIMITER $$
CREATE PROCEDURE calc_total_electronics_price(OUT total_price DECIMAL(10,2))
BEGIN
    SELECT SUM(price) INTO total_price
    FROM products
    WHERE category = 'Electronics';
END$$
DELIMITER ;

-- PROCEDURE to declare and use a cursor to iterate through products and print names
DELIMITER //
CREATE PROCEDURE print_product_names()
BEGIN
    DECLARE product_name VARCHAR(100);
    DECLARE done INT DEFAULT FALSE;
    DECLARE product_cursor CURSOR FOR SELECT name FROM products;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN product_cursor;

    get_names: LOOP
        FETCH product_cursor INTO product_name;
        IF done THEN
            LEAVE get_names;
        END IF;
        SELECT product_name;
    END LOOP get_names;

    CLOSE product_cursor;
END//
DELIMITER ;

/*



1. **IN Parameter**:
   - Used in stored procedures to pass values into the procedure. These values are read-only and cannot be modified within the procedure.

2. **OUT Parameter**:
   - Used in stored procedures to return values from the procedure. These values can be accessed by the calling program after the procedure execution.

3. **Cursors**:
   - Used to retrieve and process rows one by one from the result set of a query. 
   - Declared using the `DECLARE CURSOR` statement, opened with the `OPEN` statement, fetched using the `FETCH` statement, and closed with the `CLOSE` statement.
   - Example provided to declare a cursor, iterate through the `products` table, and print product names.

4. **DELIMITER Command**:
   - Used to change the standard delimiter (semicolon) to a different character, which is useful when defining stored procedures or functions that contain semicolons within their body. 
   - After defining the stored procedure or function, the delimiter is reset back to the standard semicolon.
*/
