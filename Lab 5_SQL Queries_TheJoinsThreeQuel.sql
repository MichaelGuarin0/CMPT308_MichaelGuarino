-- Michael Guarino
-- Alan Labouseur
-- CMPT 308 Database Systems
-- February, 4 2016
-- Lab5: SQL Queries, The Joins Three quel

-- 1) Show the cities of agents booking	an order for a customer whose id is 'c002'.	Use	joins; no subqueries.
SELECT agents.city
FROM orders INNER JOIN agents ON orders.aid=agents.aid
WHERE orders.cid='c002';
-- 2) Show the ids of products ordered through any agent who makes at least one order for a customer in Dallas, sorted by pid from highest to lowest.
SELECT pid, count(orders.pid) 
FROM orders INNER JOIN customers ON customers.cid=orders.cid
WHERE customers.city='Dallas'
GROUP BY pid
HAVING count(orders.aid)>=1
ORDER BY pid; 
-- 3) Show the names of customers who have never placed an order. Use subquery.
SELECT name
FROM customers
WHERE cid=(SELECT cid 
		FROM customers
		EXCEPT
		SELECT cid
		FROM orders);
-- 4) Show the names of customers who have never placed an order. Use an outer join.
SELECT name
FROM customers LEFT OUTER JOIN orders ON customers.cid=orders.cid
WHERE orders.cid is NULL;
-- 5) Show the names of customers who placed at least one order through an agent in their own city, along with those agents names.
SELECT customers.name, agents.name 
FROM customers INNER JOIN agents ON customers.city=agents.city
INNER JOIN orders ON customers.cid=orders.cid AND agents.aid=orders.aid;
-- 6) Show the names of customers and agents living in the same city, along with the name of the shared city, regardless of whether or not the customer has ever placed an order with that agent.
SELECT customers.name AS customers, agents.name AS agents, customers.city AS city 
FROM customers INNER JOIN agents ON customers.city=agents.city;
-- 7) Show the name and city of customers who live in the city that makes the fewest different kinds of products.
SELECT products.city, count(products.city) 
FROM products INNER JOIN customers ON products.city=customers.city 
GROUP BY products.city
ORDER BY products.city DESC LIMIT 1;
