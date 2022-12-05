USE sakila;

-- 1) num of copies of 'Hunchback Impossible'
SELECT COUNT(*)
FROM inventory i
JOIN film f USING (film_id)
WHERE f.title = 'Hunchback Impossible';

-- 2) film longer than avg length
SELECT * 
FROM film
WHERE length > (SELECT AVG(length) 
				FROM film);
                
-- 3) actors of 'Alone Trip'
-- with join
SELECT * 
FROM actor a
JOIN film_actor USING (actor_id)
JOIN film USING (film_id)
WHERE  film.title = 'Alone Trip';
-- with subquery
SELECT * 
FROM actor
WHERE actor_id IN (
	SELECT actor_id 
	FROM film_actor
	WHERE film_id IN (
		SELECT film_id
		FROM film
		WHERE film.title = 'Alone Trip'));
                    
-- 4) movies that are family films
SELECT * 
FROM film f
JOIN film_category fc USING (film_id)
JOIN category c USING (category_id)
WHERE c.name = 'Family';

-- 5) name + email of canadians
SELECT first_name, last_name, email
FROM customer 
WHERE customer_id IN (
	SELECT customer_id
    FROM customer 
    JOIN address USING (address_id)
    JOIN city USING (city_id)
    JOIN country USING (country_id)
    WHERE country.country = 'Canada');
-- subqueries/nesting from IN to OUT
-- joins from OUT to IN
SELECT first_name, last_name, email
FROM customer 
WHERE address_id IN( 
	SELECT address_id 
    FROM address 
    WHERE city_id IN ( 
		SELECT city_id 
        FROM city 
        WHERE country_id IN( 
			SELECT country_id 
            FROM country 
            WHERE country = 'Canada'))); 
    
-- 6) films with most prolific actor
SELECT *
FROM film
WHERE film_id IN (
	SELECT film_id
    FROM film_actor 
    JOIN actor USING (actor_id)
    WHERE actor_id LIKE (
		SELECT actor_id
        FROM film_actor
        GROUP BY actor_id
        ORDER BY COUNT(*) DESC
        LIMIT 1));
		
	###################################################	
        -- either LIKE oneValue or IN listOfValues
    ###################################################
    
-- 7) films rented by most profitable customer
SELECT *
FROM film
WHERE film_id IN (
	SELECT film_id 
    FROM inventory
    JOIN rental USING (inventory_id)
    WHERE customer_id LIKE (
		SELECT customer_id
        FROM payment
        GROUP BY customer_id
        ORDER BY SUM(amount) DESC
        LIMIT 1));
	
-- 8) customers who spent more than avg payment
SELECT * 
FROM customer
WHERE customer_id IN (
		SELECT customer_id
		FROM payment
		GROUP BY customer_id
		HAVING SUM(amount) > (
			SELECT AVG(sum) AS av
            FROM (
				SELECT SUM(amount) AS sum
				FROM payment
				GROUP BY customer_id) AS sub));
    