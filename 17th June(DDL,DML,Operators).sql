create database flipkart;
use flipkart;
create table products(
pid  int(3) primary key,
pname varchar(20) not null,
price int(10) not null,
stcok int(5),
location varchar(30) check(location in ("Hyderabad","Mumbai","Delhi"))


);

create table customer(
cid int(3) primary key,
cname varchar(30) not null,
age int(3),
addr varchar(50)

)

;
show tables;
create table orders(
oid int(3) primary key,
cid int(3),
pid int(3),
amt int(10) not  null,
foreign key(cid) references customer(cid),
foreign key(pid) references products(pid)
);

create table payment(
pay_id int(3) primary key,
oid int(3),
amount int(10) not null,
mode varchar(30) check (mode in ('upi','credit','debit')),
status varchar(30),
foreign key(oid) references orders(oid) );


alter table orders
rename column amt to amount;
alter table products modify column location varchar(30) check (location in ('Mumbai','Delhi','chennai'));
 truncate table products;
 alter table customer modify column age int(2) not null;
 alter table customer add column phone varchar(10) not null;
 alter table customer
modify column phone varchar(10) unique;

alter table payment
modify column status varchar(30) check( status in ('pending' , 'cancelled' , 'completed'));

alter table products
modify column location varchar(30) default 'Mumbai' check(location in ('Mumbai','Delhi' , 'chennai'));
insert into products values(1,"HP",50000,15,'Mumbai');
insert into products values(2,'Realme Mobile',20000,30,'Delhi');
insert into products values(3,'Boat earpods',3000,50,'Delhi');
insert into products values(4,'Levono Laptop',40000,15,'Mumbai');
insert into products values(5,'Charger',1000,0,'Mumbai');
insert into products values(6, 'Mac Book', 78000, 6, 'Delhi');
insert into products values(7, 'JBL speaker', 6000, 2, 'Delhi');
insert into customer values(101,'Ravi',30,'fsghd',982743),(102,'siva',31,'fshjd',9832765);

insert into customer (cid, cname, age, addr,phone) values
(105,'Ravi',30,'fdslfjl',2908327),
(107,'Rahul',25,'fdslfjl',21093876),
(103,'Simran',32,'fdslfjl',20913847),
(104,'Purvesh',28,'fdslfjl',02193874),
(109,'Sanjana',22,'fdslfjl',02913874);


insert into orders values(10001,102,3,2700);
insert into orders values(10002,104,2,18000);
insert into orders values(10003,105,5,900);
insert into orders values(10004,101,1,46000);

insert into payment values(1,10001,2700,'upi','completed');
insert into payment values(2,10002,18000,'credit','completed');
insert into payment values(3,10003,900,'debit','completed');

delete from customer where cname="Ravi";

CREATE TABLE employees (
  id INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  position VARCHAR(100) NOT NULL,
  salary DECIMAL(10, 2) NOT NULL
);

INSERT INTO employees (id, name, position, salary)
VALUES (1, 'John Doe', 'Software Engineer', 75000.00);
update employees set salary = 80000 where id=1;
delete from employees where id=1;

CREATE TABLE students (
  student_id INT PRIMARY KEY,       
  name VARCHAR(100) NOT NULL,        
  email VARCHAR(100) UNIQUE,       
  age INT CHECK (age >= 18),        
  course_id INT,                    
  grade CHAR(1) DEFAULT 'F'          
);

CREATE TABLE courses (
  course_id INT PRIMARY KEY,          
  course_name VARCHAR(100) NOT NULL   
);

alter table students add constraint fk_course foreign key (course_id) references courses(course_id) on delete cascade;

INSERT INTO students (student_id, name, email, age, course_id, grade)
VALUES (1, 'Alice Johnson', 'alice@example.com', 21, 101, 'A');  

select * from products where price>100 ;
alter table products add column last_updated datetime  default null;
update products set price=10000 ,last_updated=NOW() ;
delete from products where stcok <100;

create table heroes(
age int ,
name varchar(20),
id varchar(2) primary key);
alter table heroes add column  langauge varchar(10);
create database abcd;
drop database abcd;
truncate table heroes;

insert into heroes values
(20,"srk",1,"hinid"),(21,"slm",2,"hindi");
insert into heroes values (21,"rnvr",3,"hindi");
update heroes set langauge="Global";
delete from heroes where id=2;
select * from heroes;
alter table heroes drop primary key ;
alter table heroes add primary key (id);



CREATE DATABASE practice1;

USE practice1;

CREATE TABLE products (
    pid INT(3) PRIMARY KEY,
    pname VARCHAR(50) NOT NULL,
    price INT(10) NOT NULL,
    stock INT(5),
    location VARCHAR(30) CHECK(location IN ('Mumbai', 'Delhi', 'Chennai')),
    last_updated DATETIME DEFAULT NULL
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
    FOREIGN KEY (cid) REFERENCES customer(cid),
    FOREIGN KEY (pid) REFERENCES products(pid)
);

CREATE TABLE payment (
    pay_id INT(3) PRIMARY KEY,
    oid INT(3),
    amount INT(10) NOT NULL,
    mode VARCHAR(30) CHECK(mode IN ('upi', 'credit', 'debit')),
    status VARCHAR(30),
    FOREIGN KEY (oid) REFERENCES orders(oid)
);

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    position VARCHAR(50),
    salary INT
);

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    age INT CHECK (age >= 18),
    course_id INT,
    grade CHAR(1) DEFAULT 'F'
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL
);

ALTER TABLE students
ADD CONSTRAINT fk_course
FOREIGN KEY (course_id)
REFERENCES courses(course_id)
ON DELETE CASCADE;

INSERT INTO products (pid, pname, price, stock, location, last_updated) VALUES
(1, 'HP Laptop', 50000, 15, 'Mumbai', NULL),
(2, 'Realme Mobile', 20000, 30, 'Delhi', NULL),
(3, 'Boat Earpods', 3000, 50, 'Delhi', NULL),
(4, 'Lenovo Laptop', 40000, 15, 'Mumbai', NULL),
(5, 'Charger', 1000, 0, 'Mumbai', NULL),
(6, 'Mac Book', 78000, 6, 'Delhi', NULL),
(7, 'JBL Speaker', 6000, 2, 'Delhi', NULL);

INSERT INTO customer (cid, cname, age, addr) VALUES
(101, 'Ravi', 30, 'Mumbai'),
(102, 'Rahul', 25, 'Delhi'),
(103, 'Simran', 32, 'Mumbai'),
(104, 'Purvesh', 28, 'Delhi'),
(105, 'Sanjana', 22, 'Mumbai');

INSERT INTO orders (oid, cid, pid, amt) VALUES
(10001, 102, 3, 2700),
(10002, 104, 2, 18000),
(10003, 105, 5, 900),
(10004, 101, 1, 46000);

INSERT INTO payment (pay_id, oid, amount, mode, status) VALUES
(1, 10001, 2700, 'upi', 'completed'),
(2, 10002, 18000, 'credit', 'completed'),
(3, 10003, 900, 'debit', 'in process');

INSERT INTO employees (id, name, position, salary) VALUES
(1, 'John Doe', 'Software Engineer', 75000),
(2, 'Jane Smith', 'Project Manager', 85000),
(3, 'Emily Davis', 'Analyst', 65000);

INSERT INTO courses (course_id, course_name) VALUES
(101, 'Computer Science'),
(102, 'Mathematics'),
(103, 'Physics');

INSERT INTO students (student_id, name, email, age, course_id, grade) VALUES
(1, 'Alice Johnson', 'alice@example.com', 21, 101, 'A'),
(2, 'Bob Smith', 'bob@example.com', 22, 102, 'B'),
(3, 'Charlie Brown', 'charlie@example.com', 19, 103, 'C');

select sum(Price) from products;
select * from products where Price%3=0;
select pid,pname,price,(price -(select avg(price) from products) ) as pavg from products;
select * from products where price >=5000;
SELECT pid, pname, price, 
(price - (SELECT AVG(price) FROM products)) AS price_difference 
FROM products;

select * from customer where age !=30;
select * from orders where amt<=10000;

select 5 & 3;
select 5 | 3;
select 5 ^ 3;
 select * from products where location ='Mumbai' and stock<100;
  select * from products where location ='Mumbai' or stock<100;
  select * from payment where mode!='upi' and status='completed';
  update products set price=100000 where pid=8;

 SELECT s.student_id, s.name, c.course_name 
FROM students s 
JOIN courses c 
ON s.course_id = c.course_id;

