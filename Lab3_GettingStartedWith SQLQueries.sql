-- Michael Guarino
-- Alan Labouseur
-- CMPT 308 Database Systems
-- February, 4 2016
-- Lab3: Getting Started with SQL Queries

-- TESTED_1. List the order number and dollars of all orders. 
	SELECT ordnum, totalUSD
	FROM orders;

-- TESTED_2. List the name and city of agents named Smith.
	SELECT name, city
	FROM agents
	WHERE name='Smith';

-- TESTED_3. List the pid, name, and priceUSD of products with quantity more than 208,000.
	SELECT pid, name, priceUSD
	FROM products
	WHERE quantity > 208000;

-- TESTED_4. List the names and cities of customers in Dallas.
	SELECT name, city
	FROM customers
	WHERE city='Dallas';

-- TESTED_5. List the names of agents not in New York and not in Tokyo.
	SELECT name
	FROM agents
	WHERE city !='New York'
		AND city != 'Tokyo';

-- TESTED_6. List all data for products not in Dallas or Duluth that cost US$1 or more.
	SELECT *
	FROM products
	WHERE (city != 'Dallas' OR city != 'Duluth')
		AND (priceUSD >= '1.00'); 

-- TESTED_7. List all data for orders in January or March.
	SELECT *
	FROM orders
	WHERE mon='jan'
		OR mon='mar';

-- TESTED_8. List all data for orders in February less than us$500.
	SELECT *
	FROM orders
	WHERE mon='feb'
		AND totalUSD < 500.00;

-- TESTED_9. List all orders from the customer whose cid is C005.
	SELECT *
	FROM orders
	WHERE cid='C005';
