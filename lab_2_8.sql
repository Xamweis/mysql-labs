USE sakila;

-- 1) store ID, city, country
SELECT s.store_id, ci.city, co.country
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id;

-- 2) business in dollars per store
SELECT s.store_id, SUM(p.amount) AS business_in_dollars
FROM store s
JOIN staff sa USING (store_id)
JOIN payment p USING (staff_id)
GROUP BY s.store_id;

-- 3) longest film categories
SELECT c.name, AVG(f.length) AS avg_len
FROM category c
JOIN film_category fa USING (category_id)
JOIN film f USING (film_id)
GROUP BY c.name
ORDER BY avg_len DESC;

-- 4) most frequently rented films
SELECT f.title, COUNT(*) AS frequency
FROM film f
JOIN inventory i USING (film_id)
JOIN rental r USING (inventory_id)
GROUP BY f.title
ORDER BY frequency DESC;

-- 5) top5 genres in revenue
SELECT c.name, SUM(p.amount) AS revenue
FROM category c
JOIN film_category fc USING (category_id)
JOIN film f USING (film_id)
JOIN inventory i USING (film_id)
JOIN rental r USING (inventory_id)
JOIN payment p USING (rental_id)
GROUP BY c.name
ORDER BY revenue DESC;

-- 6) 'Academy Dinosaur' available for rent from store 1?
-- amount in store - amount rented (return_date = NULL) positive?
SELECT instore.title, (instore.available - COALESCE(renting.rented,0)) AS available_dvds
FROM
(SELECT f.title, COUNT(*) AS available
FROM film f
JOIN inventory i USING (film_id)
JOIN store s USING (store_id)
WHERE title LIKE 'ACADEMY DINOSAUR'
AND store_id = 1
GROUP BY title) AS instore
LEFT JOIN
(SELECT f.title, COUNT(*) AS rented
FROM film f
LEFT JOIN inventory i USING (film_id)
JOIN store s USING (store_id)
JOIN rental r USING (inventory_id)
WHERE title LIKE 'ACADEMY DINOSAUR'
AND store_id = 1
AND return_date IS NULL
GROUP BY title) AS renting
ON instore.title = renting.title;
-- much better solution:
SELECT inventory_id, title, (COUNT(rental_date)-COUNT(return_date)) AS rented
FROM film
RIGHT JOIN inventory USING (film_id)
LEFT JOIN store s USING (store_id)
LEFT JOIN rental r USING (inventory_id)
WHERE title LIKE 'ACADEMY DINOSAUR'
AND store_id = 1
GROUP BY inventory_id;

-- 7) pairs of actors that worked together
-- DISTINCT because they can play together in more than one film
-- only actor_ids
SELECT DISTINCT f1.actor_id, f2.actor_id
FROM film_actor f1
JOIN film_actor f2
ON (f1.film_id = f2.film_id) AND (f1.actor_id < f2.actor_id);

-- actor names
SELECT DISTINCT f1.actor_id, f2.actor_id, CONCAT(a1.first_name, ' ', a1.last_name) AS actor1, 
CONCAT(a2.first_name, ' ', a2.last_name) AS actor2
FROM film_actor f1 
JOIN actor a1 
ON f1.actor_id = a1.actor_id
JOIN film_actor f2
ON (f1.film_id = f2.film_id) AND (f1.actor_id < f2.actor_id)
JOIN actor a2
ON f2.actor_id = a2.actor_id;

-- names and how often (group by actor_ids not concats because apparently there are actors with same name)
SELECT CONCAT(a1.first_name, ' ', a1.last_name) AS actor1, 
CONCAT(a2.first_name, ' ', a2.last_name) AS actor2,
COUNT(*) AS how_often
FROM film_actor f1 
JOIN actor a1 
ON f1.actor_id = a1.actor_id
JOIN film_actor f2
ON (f1.film_id = f2.film_id) AND (f1.actor_id < f2.actor_id)
JOIN actor a2
ON f2.actor_id = a2.actor_id
GROUP BY f1.actor_id, f2.actor_id;

-- 8) kind of like 7 but without distinct -> count duplicates