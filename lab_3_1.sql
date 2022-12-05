USE sakila;

-- 1) drop picture of staff
ALTER TABLE staff
DROP COLUMN picture;

SELECT * FROM staff;

-- 2) TAMMY SANDERS to Jon (store 2) (is customer)
INSERT INTO staff(first_name, last_name, address_id, email, store_id, active, username, last_update)
SELECT first_name, last_name, address_id, email, store_id, active, first_name, last_update
FROM customer
WHERE first_name = 'Tammy' AND last_name = 'Sanders';

SELECT * FROM staff;

-- 3) Add rental for "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer (at Store 1)
SELECT * FROM rental;
-- store not in rental
INSERT INTO rental(	inventory_id, 
					customer_id, 
					staff_id)
VALUES (
	(SELECT inventory_id
		FROM film
		RIGHT JOIN inventory USING (film_id)
		LEFT JOIN store s USING (store_id)
		LEFT JOIN rental r USING (inventory_id)
		WHERE title LIKE 'ACADEMY DINOSAUR'
		AND store_id = 2
		GROUP BY inventory_id
		HAVING (COUNT(r.rental_date)-COUNT(r.return_date)) = 0
        LIMIT 1), -- query from lab_2_8_6 checking for availability, error if not available
	(SELECT customer_id 
		FROM customer
		WHERE first_name = 'CHARLOTTE' AND last_name = 'HUNTER'), 
	(SELECT staff_id
		FROM staff 
		WHERE first_name = 'Mike' AND last_name = 'Hillyer'));

-- controlling:
SELECT * FROM rental
WHERE customer_id =
(SELECT customer_id 
		FROM customer
		WHERE first_name = 'CHARLOTTE' AND last_name = 'HUNTER')
ORDER BY rental_date DESC;

-- copy has been returned
DROP TABLE IF EXISTS unreturned_copy;
CREATE TEMPORARY TABLE unreturned_copy AS
(SELECT rental_id 
FROM rental
WHERE return_date IS NULL
AND customer_id = (SELECT customer_id 
					FROM customer
					WHERE first_name = 'CHARLOTTE' AND last_name = 'HUNTER')
ORDER BY rental_date DESC
LIMIT 1);
UPDATE rental
SET return_date = CURRENT_TIMESTAMP()
WHERE rental_id = (SELECT rental_id FROM unreturned_copy);

-- delete rental
DELETE FROM rental
WHERE customer_id = 130
AND inventory_id IN (5,6,7,8);