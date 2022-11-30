USE sakila;

-- 1) only non duplicate last names
SELECT *
FROM actor
WHERE last_name IN
(SELECT last_name
FROM actor
GROUP BY last_name
HAVING COUNT(*) = 1);
-- same as
SELECT *
FROM actor
WHERE last_name IN
(SELECT last_name 
FROM 
(SELECT last_name, COUNT(*) OVER (PARTITION BY last_name) AS count
FROM actor) AS counts
WHERE count = 1);

-- 2) last names that occurs multpile times
SELECT last_name 
FROM 
(SELECT last_name, COUNT(*) as count
FROM actor
GROUP BY last_name) as counts
WHERE count > 1;
-- same as
SELECT last_name
FROM actor
GROUP BY last_name
HAVING COUNT(*) > 1;

-- 3) how many rental by each employee
SELECT staff_id, COUNT(*) as count
FROM rental
GROUP BY staff_id;

-- 4) films per year
SELECT release_year, COUNT(*) as count
FROM film
GROUP BY release_year;

-- 5) films per rating
SELECT rating, COUNT(*) as count
FROM film
GROUP BY rating;

-- 6) mean length for each rating
SELECT rating, CONCAT(FLOOR(AVG(length)/60),'h ',ROUND(MOD(AVG(length),60),0),'m') AS avg_len
FROM film
GROUP BY rating;

-- 7) data from 6 with mean > 2h
SELECT rating
FROM film
GROUP BY rating
HAVING AVG(length) > 120;

-- 8) length-rankings
SELECT title, length, 
CASE
	WHEN length BETWEEN 0 AND 59 THEN 'short'
    WHEN length BETWEEN 60 AND 89 THEN 'middle'
    WHEN length BETWEEN 90 AND 120 THEN 'long'
    ELSE 'overlong'
END AS ranking
FROM film
WHERE length IS NOT NULL AND length <> 0;