USE sakila;

-- 1) nums of films in categories
SELECT category.name AS category, COUNT(*) AS count
FROM category JOIN film_category ON film_category.category_id = category.category_id
JOIN film ON film.film_id = film_category.film_id
GROUP BY category.name;

-- 2) total of each staff in aug 05
SELECT DISTINCT staff.first_name, staff.last_name, COUNT(*) OVER (PARTITION BY staff.staff_id) AS count
FROM staff JOIN rental ON rental.staff_id = staff.staff_id
WHERE CONVERT(rental_date, DATE) > CONVERT('2005-07-31', DATE) AND CONVERT(rental_date, DATE) < CONVERT('2005-09-01', DATE);
-- same as
SELECT DISTINCT staff.first_name, staff.last_name, COUNT(*) OVER (PARTITION BY staff.staff_id) AS count
FROM staff JOIN rental ON rental.staff_id = staff.staff_id
WHERE DATE_FORMAT(CONVERT(rental_date, DATE), '%Y %M') = '2005 August';

-- 3) actor that appered in most films
SELECT actor.first_name, actor.last_name, COUNT(*) AS count
FROM actor JOIN film_actor ON film_actor.actor_id = actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
GROUP BY actor.actor_id
ORDER BY count DESC 
LIMIT 3;

-- 4) most active customer (rented most number of films)
SELECT customer.first_name, customer.last_name, COUNT(*) AS count
FROM customer JOIN rental ON rental.customer_id = customer.customer_id
GROUP BY customer.customer_id
ORDER BY count DESC
LIMIT 3;

-- 5) staff first last and adress
SELECT staff.first_name, staff.last_name, address.address
FROM staff JOIN address ON address.address_id = staff.address_id;

-- 6) each film and number of actors in it
SELECT DISTINCT film.title, COUNT(*) OVER (PARTITION BY film.title) AS count
FROM film JOIN film_actor ON film_actor.film_id = film.film_id;

-- 7) total paid by each customer ordered by last name.
SELECT DISTINCT customer.first_name, customer.last_name, 
SUM(payment.amount) OVER (PARTITION BY customer.first_name) AS sum
FROM customer JOIN payment ON payment.customer_id = customer.customer_id
ORDER BY customer.last_name;

-- 8) number of films per category
-- SEE 1)