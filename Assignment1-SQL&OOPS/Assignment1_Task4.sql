--find out which customers have not placed any orders. 
select FirstName,LastName,Email from Customers
where CustomerID not in(select distinct CustomerID from Orders)

--find the total number of products available for sale.  
select sum(QuantityInStock) as 'ToatlProductsAvailable'from Inventory

--calculate the total revenue generated by TechShop.  
select sum(TotalAmount) as 'TotalRevenue' from Orders

--calculate the average quantity ordered for products in a specific category. 
--Allow users to input the category name as a parameter. 
select ProductName,(select avg(od.Quantity) from OrderDetails od 
where ProductID=p.ProductID) as AvgQuantityOrdered
from Products p where p.Category='Others'

--calculate the total revenue generated by a specific customer. 
--Allow users to input the customer ID as a parameter. 
select c.CustomerID, c.FirstName, c.LastName, 
(select sum(o.TotalAmount) from Orders o 
where o.CustomerID = c.CustomerID) as TotalRevenue 
from Customers c where c.CustomerID = 5;

--find the customers who have placed the most orders. 
--List their names and the number of orders they've placed. 
select top 1 c.CustomerID, c.FirstName, c.LastName, count(o.OrderID) as OrderCount 
from Customers c join Orders o on c.CustomerID = o.CustomerID 
group by c.CustomerID, c.FirstName, c.LastName 
order by OrderCount desc;

--find the most popular product category, which is the one with the highest 
--total quantity ordered across all orders. 
select top 1 Category, TotalQuantityOrdered 
from (select Products.Category, sum(OrderDetails.Quantity) as TotalQuantityOrdered 
from Products join OrderDetails on Products.ProductID = OrderDetails.ProductID 
group by Products.Category) as CategoryOrderCounts 
order by TotalQuantityOrdered desc;

--find the customer who has spent the most money (highest total revenue) 
--on electronic gadgets. List their name and total spending. 
select top 1 c.CustomerID,c.FirstName,c.LastName,
sum(o.TotalAmount) as TotalSpent
from Customers c
join Orders o on c.CustomerID=o.CustomerId
group by c.CustomerID,c.FirstName,c.LastName
order by TotalSpent desc

--calculate the average order value (total revenue divided by the number of 
--orders) for all customers. 
select avg(TotalAmount) as AverageOrder
from Orders where TotalAmount is not null

--find the total number of orders placed by each customer and list their 
--names along with the order count. 
select FirstName,LastName,(select count(*) from Orders o
where o.CustomerId=c.CustomerID) as OrderCount
from Customers c