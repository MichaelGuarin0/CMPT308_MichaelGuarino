-- Michael Guarino
-- Alan Labouseur
-- CMPT 308 Database Systems
-- February, 4 2016
-- Lab4: SQL Queries-The Subqueries Sequel

-- 1. Get the cities of agents booking an order for a customer whose cid is 'c002'.
SELECT city
FROM agents
WHERE aid in(SELECT aid
			FROM orders
			WHERE cid ='c002'
			);

-- 2. Get the ids of products ordered through any agent who takes at least one order from a customer in Dallas, sorted by pid from highest to lowest. (This is not the same as asking for ids of products ordered by customers in Dallas.)
select pid
from orders
where cid in(select cid 
		from customers
		where city='Dallas'
		)
group by pid
having count(aid)>=1 
order by pid asc;


-- 3. Get the ids and names of cutomers who did not place an order through agent a01.
select  cid, name 
from customers
where cid Not in (select cid
				from orders
				where aid='a01'
				);

-- 4. Get the ids of customers who ordered both product p01 and p07
select cid
from orders
where pid='p01'
union
select cid 
from orders
where pid='p07';

-- 5. Get the ids of products not ordered by any customers who place any order through agent a07 in pid order from highest to lowest.
select pid 
from products
where pid not in(select pid
			from orders
			where cid in(
						select cid
							from orders
							where aid='a07'
							)
							)
group by pid
order by pid desc;

-- 6. Get the name, discounts, and city for all customers who place orders through agents in London or New York.
select name, discount, city
from customers
where cid in (SELECT cid
				FROM orders
				WHERE aid IN (SELECT aid
								FROM agents
								WHERE city IN ('New York', 'London')
								)
				);

-- 7. Get all customers who have the same discount as that of any customers in Dallas or London.
select cid 
from customers
where discount in (select discount
					from customers
					where cid in(select cid
									from customers
									where city='Dallas' or city='London'
									)
					)
EXCEPT
select cid
from customers
where city='Dallas' or city='London';

-- 8. Tell me about constraints: 
-- Q) What are they?
-- A) Constraints are ways to constrain data, restricting the domain for a specified attribute. 
-- Q) What are they good for?
-- A) Constraints are often used to enforce the referential integrity of the data and maintain logically complete data within the database.
-- Q) What's the advantage of putting that sort of thing inside the database?
-- A) Constraints work to ensure that the database maintains logically complete data by enforcing referential integrity. 
-- Q) Make up some examples of good uses of check constraints and some examples of bad uses of check constraints. 
-- A) Example 1. unique constraint violation: This is a good use of check constraints because it makes sure we don't have two entries with the same primary key.
		-- INSERT INTO Products( pid, name, city, quantity, priceUSD )
  			-- VALUES('p08', 'clip', 'Newark', 200600, 1.25 );
  		-- INSERT INTO Products( pid, name, city, quantity, priceUSD )
  			-- VALUES('p08', 'clip', 'Newark', 200600, 1.25 );
  		-- ERROR:  duplicate key value violates unique constraint "products_pkey"
		-- DETAIL:  Key (pid)=(p08) already exists.
	
	-- Example 2. foreign key constraint violation: This is a good use of check constraints because it ensures that we delete the foreign keys before we delete the parent node 'ACME' because if we were to delete 'ACME' first we would have incomplete data where 'ACME's foreign keys were stored.
		-- DELETE
		-- FROM customers
		-- WHERE customer.name='ACME';
		-- ERROR:  missing FROM-clause entry for table "customer"
		-- LINE 167: where customer.name='ACME';

	-- Example 3. not null values overused: This is a bad use of check constraints where not null forces socialSecurityNumber to have a value although not all students have a social security number.
		 -- CREATE TABLE students( 
		 	--id 	integer not null,
		 	--socialSecurityNumber	integer not null,
		 	--...); 

