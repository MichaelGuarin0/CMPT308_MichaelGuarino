-- Michael Guarino
-- Alan Labouseur
-- CMPT 308 Database Systems
-- February, 4 2016
-- Lab3: Getting Started with SQL Queries

-- TESTED_1. List the order number and dollars of all orders. 
	SELECT ordnum, totalUSD
	FROM orders;

-- 2. List the name and city of agents named Smith.
	SELECT name, city
	FROM agents
	WHERE name='Smith';

-- 3. List the pid, name, and priceUSD of products with quantity more than 208,000.

-- 4. List the names and cities of customers in Dallas.

-- 5. List the names of agents not in New York and not in Tokyo.

-- 6. List all data for products not in Dallas or Duluth that cost US$1 or more.

-- 7. List all data for orders in January or March.
	SELECT *
	FROM orders
	WHERE mon='jan'
		OR mon='mar';

-- 8. List all data for orders in February less than us$500.
-- 9. List all orders from the customer whose cid is C005.



SELECT *
	FROM orders
	WHERE mon IN ('jan', 'mar');

--impose order on the output
SELECT *
FROM orders
WHERE mon IN ('jan', 'mar');
ORDER BY totalUSD DESC

SELECT *
FROM orders
WHERE mon IN ('jan', 'mar');
ORDER BY totalUSD ASC

--can you order on data that is not displayed
SELECT totalUSD, ordnum, mon
FROM orders
WHERE mon IN ('jan', 'mar');
ORDER BY totalUSD ASC, ordnum DESC

--with these two examples there is something special with unions and something else
SELECT ALL totalUSD
FROM orders

SELECT DISTINCT totalUSD
FROM orders