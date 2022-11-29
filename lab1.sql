
SELECT * FROM sakila.film, sakila.actor, sakila.customer;
SELECT title FROM sakila.film;
SELECT DISTINCT name FROM sakila.film JOIN sakila.language ON film.language_id = language.language_id;

SELECT COUNT(*) FROM sakila.store;
SELECT COUNT(*) FROM sakila.staff;
SELECT first_name FROM sakila.staff;