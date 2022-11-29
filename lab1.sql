USE sakila;
SELECT * FROM film;
SELECT * FROM actor;
SELECT * FROM customer;
SELECT title FROM film;
SELECT DISTINCT name AS language FROM language 
	JOIN film ON film.language_id = language.language_id;

SELECT COUNT(*) FROM store;
SELECT COUNT(*) FROM staff;
SELECT first_name FROM staff;