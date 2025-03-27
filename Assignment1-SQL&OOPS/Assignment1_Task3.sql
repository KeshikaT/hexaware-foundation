--query to retrieve a list of all orders along with customer information
select c.FirstName, c.LastName,c.Email,c.Phone
from Customers c
join Orders o on c.CustomerID=o.CustomerId

--total revenue generated by each electronic gadget product. 
--Include the product name and the total revenue. 
select p.ProductName, sum(od.Quantity * p.Price)
from Products p
join OrderDetails od on p.ProductID=od.ProductId
group by p.ProductName

--list all customers who have made at least one purchase.
--Include their names and contact information. 
select c.FirstName,c.LastName,c.Email
from Customers c 
join Orders o on c.CustomerID=o.CustomerId

--find the most popular electronic gadget, which is the one with the highest 
--total quantity ordered. Include the product name and the total quantity ordered. 
select top 1 p.ProductName,od.Quantity
from Products p
join OrderDetails od on p.ProductID=od.ProductId

--retrieve a list of electronic gadgets along with their corresponding categories. 
alter table Products add Category varchar(20);
update Products set Category = 'Electronics Gadgets'
where ProductName in ('Laptop', 'Smartphone', 'Tablet', 'Smartwatch', 'Headphones');
update Products set Category = 'Computer Peripherals'
where ProductName in ('Mouse', 'Keyboard', 'Monitor','Printer','Smart Speaker');
update Products set Category = 'Others'
where ProductName in ('Gaming Console', 'Camera');
select ProductName, Category from Products;

--calculate the average order value for each customer. 
--Include the customer's name and their average order value.
select c.FirstName,c.LastName,avg(o.TotalAmount)
from Customers c
join Orders o on c.CustomerID=o.CustomerId
group by c.FirstName,c.LastName

--find the order with the highest total revenue. 
--Include the order ID, customer information, and the total revenue. 
select o.OrderID,c.FirstName,c.LastName,c.Phone,
sum(od.Quantity*p.Price) as TotalRevenue
from Orders o 
join Customers c on o.CustomerId=c.CustomerID
join OrderDetails od on o.OrderID=od.OrderId
join Products p on p.ProductID=od.ProductId
group by o.OrderID,c.CustomerID,c.FirstName,c.LastName,c.Phone

--list electronic gadgets and the number of times each product has been ordered. 
select p.ProductName,count(od.OrderId) as TimesOrdered
from Products p
join OrderDetails od on p.ProductID=od.ProductId
group by p.ProductName

--find customers who have purchased a specific electronic gadget product. 
--Allow users to input the product name as a parameter. 
select p.ProductName,c.FirstName,c.LastName
from Products p
join OrderDetails od on p.ProductID=od.ProductId
join Orders o on o.OrderID=od.OrderId
join Customers c on o.CustomerId=c.CustomerID
where p.ProductName='Laptop'

--calculate the total revenue generated by all orders placed within a specific time period.
--Allow users to input the start and end dates as parameters. 
select sum(TotalAmount) as TotalRevenue
from Orders where OrderDate between '2025-03-01' and '2025-03-30'