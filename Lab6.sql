-- Michael Guarino
-- Alan Labouseur
-- CMPT 308 Database Systems
-- February, 24 2016
-- Lab6: Interesting and Painful Queries


--1) Display the name and city of customers who live in any city that makes the most different kinds of products.
SELECT customers.name, products.city, count(products.city) AS Num_of_Products 
FROM products INNER JOIN customers ON products.city=customers.city 
GROUP BY products.city, customers.name
ORDER BY products.city ASC LIMIT 1;


--2) Display the names of products whose priceUSD is strictly above the average priceUSD, in reverse-alphabetical order.
select products.name, products.priceUSD
from products
group by products.name, products.priceUSD
having products.priceUSD > (select avg(products.priceUSD)
							from products)
order by products.name DESC;

--3) Display the customer name, pid ordered, and the total for all orders, sorted by total from high to low.
select customers.name, orders.pid, orders.totalUSD
from customers inner join orders on customers.cid=orders.cid
group by customers.name,orders.pid,orders.totalUSD
order by orders.totalUSD DESC;

--4) Display all customer names (in alphabetical order) and their total ordered, and nothing more. Use coalesce to avoid showing NULLs. 
select customers.name,coalesce(sum(orders.totalUSD)) 
from customers full join orders on customers.cid=orders.cid
group by customers.cid,customers.name
order by customers.name ASC;

--5) Display the names of all customers who bought products from agents based in Tokyo along with the names of the products they ordered, and the names of the agents who sold it to them.
select customers.name, products.name, agents.name
from customers inner join orders on customers.cid=orders.cid
inner join products on products.pid=orders.pid
inner join agents on agents.aid=orders.aid
group by customers.cid, products.pid, agents.aid
having agents.city='Tokyo'
order by customers.name asc;

-- 6) Write a query to check the accuracy of the dollars column in the Orders table. This mean calculating Orders.totalUSD from data in other tables and comparing those values to the values in Orders.totalUSD. Display all rows in Orders where Orders.totalUSD is incorrect, if any.
(select orders.ordnum,coalesce(((products.priceUSD * orders.qty)-customers.discount)) as CalculatedTotal
from products inner join orders on products.pid=orders.pid 
inner join customers on customers.cid=orders.cid)
ex
(select orders.ordnum, orders.totalUSD
from orders);

--7) What's the difference between LEFT OUTER JOIN and RIGHT OUTER JOIN? Give example queries in SQL to demonstrate.
 --a left outer join mean keep all the records from the first table and insert null values where the 2nd table doesn't match.
select customers.cid, orders.cid
from customers left outer join orders on customers.cid=orders.cid;
 --a right outer join mean keep all records from the second table and insert null values where the 1st table doesn't match.
