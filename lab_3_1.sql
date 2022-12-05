USE sakila;

-- 1) drop picture of staff
ALTER TABLE staff
DROP COLUMN picture;

SELECT * FROM staff;

-- 2) TAMMY SANDERS to Jon (store 2) (is customer)
INSERT INTO staff(first_name, last_name, address_id, email, store_id, active, username, last_update)
SELECT first_name, last_name, address_id, email, store_id, active, first_name, last_update
FROM customer
WHERE first_name = 'TAMMY' AND last_name = 'SANDERS';

-- 3) Add rental for "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1
SELECT * FROM rental
-- not finished