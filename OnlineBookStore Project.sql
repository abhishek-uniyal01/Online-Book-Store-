create database OnlineBookStore

use OnlineBookStore

select * from Books

select * from Orders

select * from Customers

-- 1) Retrieve all books in the "Fiction" genre:
select * from books where Genre = 'Fiction'


-- 2) Find books published after the year 1950:
select * from books where Published_Year>1950


-- 3) List all customers from the Canada:
select * from customers where Country = 'Canada'


-- 4) Show orders placed in November 2023:
select * from orders where Order_Date between '2023-11-01' and '2023-11-30'


-- 5) Retrieve the total stock of books available:
select SUM(stock)[Total Stock] from Books


-- 6) Find the details of the most expensive book:
select * from books where price = (select max(price) from books)

-- 7) Show all customers who ordered more than 1 quantity of a book:
select C.Name from customers C inner join Orders O on C.customer_id = O.Customer_ID where O.Quantity>1

-- 8) Retrieve all orders where the total amount exceeds $20:
select * from orders where Total_Amount>20

-- 9) List all genres available in the Books table:
select Genre from books


-- 10) Find the book with the lowest stock:
select Title,stock[Lowest Stock] from books where Stock = (select min(distinct stock) from books)

-- 11) Calculate the total revenue generated from all orders:
select sum(quantity * Total_Amount)[Total Revenue] from Orders

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:

select B.Genre,sum(O.Quantity)[Books Sold] from Books B inner join Orders O on B.Book_ID = O.Book_ID
group by B.Genre

-- 2) Find the average price of books in the "Fantasy" genre:
Select AVG(Price)[Avg Price Of Books] from Books where Genre = 'Fantasy'


-- 3) List customers who have placed at least 2 orders:
select C.Name,count(O.Order_ID)[Order Count] from Customers C inner join Orders O on C.Customer_ID = O.Customer_ID
group by C.Name
having count(O.Order_ID)>=2

-- 4) Find the most frequently ordered book:
select top 1  o.book_id,b.title,count(o.order_id)[Order Count]
from Orders o
join Books b on o.book_id = b.Book_ID
group by o.Book_ID,b.Title
order by [Order Count] desc 

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
select top 3 * from books
Where Genre = 'Fantasy'
order by price desc

-- 6) Retrieve the total quantity of books sold by each author:
select b.Author,sum(O.Quantity)[Total Quantity Sold] 
from Books b 
join Orders o on b.Book_ID = o.Book_ID
group by b.Author

-- 7) List the cities where customers who spent over $30 are located:
select c.City,SUM(O.Total_Amount)[Total Spent Amount] 
from Customers c join Orders o
on c.Customer_ID = o.Order_ID
group by City having sum(O.Total_Amount)>30

-- 8) Find the customer who spent the most on orders:
select distinct top 1  c.Customer_ID,c.Name, sum(o.Total_Amount)[Total Amount Spent]
from Customers c join orders o
on c.Customer_ID = o.Customer_ID
group by c.Customer_ID,c.Name
order by [Total Amount Spent] desc

--9) Calculate the stock remaining after fulfilling all orders:
 select b.Book_ID,b.Title,b.stock - coalesce(sum(Quantity),0) as [Remaining Quantity]
 from Books b 
 left join orders o
 on b.Book_ID = o.Book_ID
 group by b.Book_ID,b.Title,b.Stock
 order by b.Book_ID desc