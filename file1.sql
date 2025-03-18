-- to create database
create database bookstore;

-- to check database
SELECT current_database();

--drop table 
drop table if exists books;

--show table
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public';

--creata tables
create table books(
Book_ID	serial primary key,
Title varchar(100),
Author varchar(100),
Genre varchar(50),
Published_Year int,
Price numeric(10,2),
Stock INT
);
--drop table
drop table if exists customers;

--create table customers
create table customers(
Customer_ID	serial primary key,
Name varchar(100),
Email varchar(100),	
Phone varchar(15),
City varchar(50),
Country varchar(150)
);

--drop table
drop table if exists orders;

--create table customers
create table orders(
Order_ID serial primary key,
Customer_ID	int references customers(customer_ID),
Book_ID	int references books(book_ID),
Order_Date date,
Quantity int,
Total_Amount numeric(10,2)
);


--import data from csv
copy books(Book_ID,Title,Author,Genre,Published_Year,Price,Stock)
from 'G:\project\books.csv'
csv header;

copy customers(Customer_ID,Name,Email,Phone,City,Country)
from 'G:\project\customers.csv'
csv header;

copy orders(Order_ID,Customer_ID,Book_ID,Order_Date,Quantity,Total_Amount)
from 'G:\project\orders.csv'
csv header;

select * from books;
select * from customers;
select * from orders;

--Basic Queries
--1) Retrieve all books in the "Fiction" genre
select * from books where lower(genre) = 'fiction';

--2) Find books published after the year 1950
select * from books where published_year>1950;

--3) List all customers from the Canada
select * from customers where lower(country) = 'canada';

 --4) Show orders placed in November 2023
SELECT * FROM orders where EXTRACT(year FROM order_date)='2023' and extract(month from order_Date)='11';
 
--5) Retrieve the total stock of books available
select sum(stock) as total_stock from books;

--6) Find the details of the most expensive book
select * from books order by price desc limit 1;

--7) Show all customers who ordered more than 1 quantity of a book
select customer_id, sum(quantity) as totalorder from orders group by customer_id having sum(quantity)>1;

--8) Retrieve all orders where the total amount exceeds $20
select * from orders where total_amount>20;

--9) List all genres available in the Books table
select distinct(genre) from books;

--10) Find the book with the lowest stock
select * from books where stock=(select stock from books order by stock asc limit 1);

--11) Calculate the total revenue generated from all orders
select sum(total_amount) as total_revenue_generated from orders;


--Advance Queries
--1) Retrieve the total number of books sold for each genre
select b.genre,sum(o.quantity) from books b
inner join orders o on b.book_id=o.book_id
group by b.genre;

--2) Find the average price of books in the "Fantasy" genre
select avg(price) as avg_price from books where lower(genre) ='fantasy';

--3) List customers who have placed at least 2 orders
select o.customer_id,c.name,count(o.customer_id) no_of_orders from orders o
inner join customers c on c.customer_id=o.customer_id
group by o.customer_id,c.customer_id having count(o.customer_id)>1;

--4) Find the most frequently ordered book
select book_id,count(order_id) totalordered from orders 
group by book_id order by totalordered desc limit 1;

--5) Show the top 3 most expensive books of 'Fantasy' Genre
select * from books where lower(genre)='fantasy' order by price desc limit 3;

--6) Retrieve the total quantity of books sold by each author
select b.author,sum(o.quantity) from books b
inner join orders o on b.book_id=o.book_id
group by b.author;

--7) List the cities where customers who spent over $30 are located
select distinct c.city from orders o 
inner join customers c on c.customer_id=o.customer_id 
group by c.customer_id
having sum(o.total_amount)>30;

--8) Find the customer who spent the most on orders
select o.customer_id,c.name, sum(o.total_amount) totalspent,c.email,c.city  from orders o 
inner join customers c on c.customer_id=o.customer_id 
group by o.customer_id,c.customer_id order by totalspent desc limit 1;

--9) Calculate the stock remaining after fulfilling all orders
select b.book_id,b.title,b.stock-coalesce(sum(o.quantity),0) remainstock from books b
full join orders o on b.book_id=o.book_id
group by b.book_id;
