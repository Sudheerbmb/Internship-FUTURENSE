create database mydatabase;
use mydatabase;
create table users(
id INT auto_increment primary key,
username VARCHAR(50) NOT
NULL,
email varchar(20),
age int,
created_at TIMESTAMP default current_timestamp);



create table posts(
id int auto_increment primary key,
user_id int,
foreign key(user_id) references users(id),
title varchar(100) not null,
content text,
created_at timestamp default current_timestamp);

insert into users (username,email,age) values('A','m1',20),('B','m2',21);
insert into posts (user_id,title,content) values (1,"AB","hello"),(2,"CD","aadab");

alter table users add column phone int;
alter table users drop column phone ;
-- truncate table posts;
-- truncate table users;
-- drop database mydatabase;
-- update users set age=100 where username='A';
-- delete from users where age =1000;
select * from users;
select posts.id,posts.title,posts.content,users.username,users.email from posts join users on posts.user_id =users.id;
insert into posts (user_id,title,content) values (3,"HC","nothing");
insert into users (username,email,age) values("N","jk",100);
select b.user_id,b.title,b.content,a.age,a.email from posts b join users a on b.user_id=a.id;
select concat("sudheer"," ","kumar");
select substring("Lovely Professional",1,6);
select length("India");
select replace("sudheer kumar","kumar","Kumar");
select abs(-5),ceil(4.2),floor(5.7),round(100.022,3);
select now(),curtime(),curdate(),datediff("2024-10-10","2024-10-8");
SELECT * FROM posts ORDER BY created_at;
select avg(age),email from users group by email; 

create database abc;
use abc;

CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    salary DECIMAL(10, 2)
);
CREATE TABLE departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100)
);
CREATE TABLE projects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT
);
INSERT INTO departments (name) VALUES ('HR'), ('Engineering'), ('Marketing');
INSERT INTO employees (name, department_id, salary) VALUES
('Alice', 1, 60000.00),
('Bob', 2, 80000.00),
('Charlie', 2, 75000.00),
('David', 3, 50000.00),
('Eve', 1, 70000.00);
INSERT INTO projects (name, department_id) VALUES
('Recruitment Drive', 1),
('Product Launch', 2),
('Ad Campaign', 3);

select e.name,d.name from employees e inner join departments d on e.department_id=d.id;
select e.name,d.name from employees e left join departments d on e.department_id=d.id;
select e.name,d.name from employees e right join departments d on e.department_id=d.id;
select e.name,d.name from employees e left join departments d on e.department_id=d.id union select e.name,d.name from employees e right join departments d on e.department_id=d.id;
select e.name,d.name from employees e cross join departments d on e.department_id=d.id;

-- Create the database
CREATE DATABASE School;

-- Use the database
USE School;

-- Create the Students table
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(100),
    Course VARCHAR(100),
    Instructor VARCHAR(100),
    InstructorPhone VARCHAR(20)
);

-- Insert some data into the Students table
INSERT INTO Students (StudentID, StudentName, Course, Instructor, InstructorPhone) VALUES
(1, 'Alice', 'Math', 'Mr. Smith', '555-1234'),
(2, 'Bob', 'Math', 'Mr. Smith', '555-1234'),
(3, 'Charlie', 'Science', 'Dr. Jones', '555-5678'),
(4, 'David', 'Math', 'Mr. Smith', '555-1234'),
(5, 'Eve', 'Science', 'Dr. Jones', '555-5678');

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Insert data into customers table
INSERT INTO customers (customer_name, email)
VALUES ('John Doe', 'john.doe@example.com'),
       ('Jane Smith', 'jane.smith@example.com'),
       ('Michael Brown', 'michael.brown@example.com');

-- Insert data into orders table
INSERT INTO orders (customer_id, order_date, total_amount)
VALUES (1, '2024-06-24', 150.00),
       (1, '2024-06-25', 200.50),
       (2, '2024-06-24', 75.25),
       (3, '2024-06-23', 300.00);
       
       
DELIMITER //

CREATE PROCEDURE GetCustomerOrders(IN customer_id INT)
BEGIN
    SELECT * FROM orders WHERE customer_id = customer_id;
END//

DELIMITER ;
CALL GetCustomerOrders(3);
 
 
 
DELIMITER //
create procedure gc1(price1 int)
begin
select * from orders where price1<total_amount;
end //


DELIMITER ;
call gc1(100);

delimiter //
create procedure ap1(
id int)
begin
select * from orders where customer_id=id;
end
//
delimiter ;

call ap1(1);
delimiter //
create function cord() returns int
begin
declare total int;
select sum(total_amount) into total from orders ;
return total;
end;//
delimiter ;

delimiter //
create procedure tl()
 begin
select sum(total_amount) from orders;
end //
delimiter ;
call tl();


SELECT 
    customer_id, 
    customer_name,
    (SELECT COUNT(*) FROM orders WHERE orders.customer_id = customers.customer_id) AS num_orders
FROM 
    customers;
    
    



