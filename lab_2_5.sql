USE sakila;

-- 1) scarletts
SELECT * 
FROM actor
WHERE first_name = 'Scarlett';

-- 2) avail for rent and how much rented
SELECT COUNT(*) 
FROM film;
SELECT COUNT(*) 
FROM rental 
WHERE return_date IS NULL;

-- 3) shortest longest movie durations
SELECT MIN(length) AS min_duration, MAX(length) AS max_duration
FROM film;

-- 4) avg duration in hours,minutes
SELECT CONCAT(FLOOR(AVG(length)/60),'h ',ROUND(MOD(AVG(length),60),0),'m') AS t 
FROM film;

-- 5) count of distinct last names
SELECT COUNT(DISTINCT last_name)
FROM actor;

-- 6) since how long is comp operting
SELECT DATEDIFF(CONVERT(MAX(last_update), DATE), CONVERT(MIN(rental_date), DATE)) AS operation_duration 
FROM rental;

-- 7) additional cols at rental: month weekday
SELECT *, 
DATE_FORMAT(CONVERT(rental_date, DATE), '%b') AS month, 
DATE_FORMAT(CONVERT(rental_date, DATE), '%a') AS weekday 
FROM rental
LIMIT 20;

-- 8) weekend or workday?
SELECT *, 
CASE
	WHEN DATE_FORMAT(CONVERT(rental_date, DATE), '%a') LIKE 'S%' THEN 'weekend'
	ELSE 'workday'
END AS 'day_type'
FROM rental;

-- 9) release yeras
SELECT DISTINCT release_year 
FROM film;

-- 10) all %ARMAGEDDONS%
SELECT * 
FROM film 
WHERE title LIKE '%ARMAGEDDON%';

-- 11) all %APPOLO
SELECT * 
FROM film 
WHERE title LIKE '%APOLLO';

-- 12) 10 longest films
SELECT *
FROM film
ORDER BY length 
DESC LIMIT 10;

-- 13) how many behind the scenes
SELECT COUNT(*)
FROM film
WHERE FIND_IN_SET('Behind the scenes',  special_features);


