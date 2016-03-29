-- Michael Guarino
-- Alan Labouseur
-- CMPT 308 Database Systems
-- February, 19 2016
-- Lab5: SQL Queries, The Joins Three quel

-- 1) TESTED_WORKS: Show the cities of agents booking an order for a customer whose id is 'c002'. Use joins; no subqueries.
SELECT agents.city
FROM orders INNER JOIN agents ON orders.aid=agents.aid
WHERE orders.cid='c002';

-- 2) TESTED_WORKS: Show the ids of products ordered through any agent who makes at least one order for a customer in Dallas, sorted by pid from highest to lowest.
SELECT pid  
FROM orders INNER JOIN customers ON customers.cid=orders.cid
WHERE customers.city='Dallas'
GROUP BY pid
HAVING count(orders.aid)>=1
ORDER BY pid DESC; 
-- correct answer subquery:
SELECT distinct o.aid
FROM orders o
WHERE aid IN(SELECT distinct o.aid
			from customers c,
			orders o
			WHERE o.cid=c.cid
			and c.city='Dallas')
order by pid DESC;
-- correct answer joins:
select distinct o2.pid 
from customers c, 
	orders o1
	orders o2
where o1.cid=c.cid
	and o1.aid=o2.aid
	and c.city='Dallas'
order by o2.pid desc;
-- correct answer inner join syntax:
select distinct o2.pid
from customers c inner join orders o1 on c.cid=o1.cid
				inner join orders o2 on o1.aid=o2.aid
where c.city='Dallas'
order by o2.pid desc

-- 3) TESTED_WORKS: Show the names of customers who have never placed an order. Use subquery.
SELECT name
FROM customers
WHERE cid=(SELECT cid 
			FROM customers
			EXCEPT
			SELECT cid
			FROM orders);

-- 4) TESTED_WORKS: Show the names of customers who have never placed an order. Use an outer join.
SELECT name
FROM customers LEFT OUTER JOIN orders ON customers.cid=orders.cid
WHERE orders.cid is NULL;
-- using null here rather than not in speeds up query 

-- 5) TESTED_WORKS: Show the names of customers who placed at least one order through an agent in their own city, along with those agents names.
SELECT distinct customers.name, agents.name 
FROM customers INNER JOIN agents ON customers.city=agents.city
INNER JOIN orders ON customers.cid=orders.cid AND agents.aid=orders.aid;

-- 6) TESTED_WORKS: Show the names of customers and agents living in the same city, along with the name of the shared city, regardless of whether or not the customer has ever placed an order with that agent.
SELECT customers.name AS customers, agents.name AS agents, customers.city AS city 
FROM customers INNER JOIN agents ON customers.city=agents.city;

-- 7) TESTED_WORKS; however unable to show more than one customer name. Show the name and city of customers who live in the city that makes the fewest different kinds of products.
SELECT products.city, customers.name, count(products.city) AS Num_of_Products 
FROM products INNER JOIN customers ON products.city=customers.city 
GROUP BY products.city, customers.name
ORDER BY products.city DESC LIMIT 1;

-- alan's better looking solution:
select name, city
from customers
where city in(select city
				from(select p.city, count(*)
					from products p
						group by p.city
						order by count(*) asc 
						limit 1) sub1
				)
