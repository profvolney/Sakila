USE sakila;

-- 1. 
SELECT * 
FROM film;

-- 2.
SELECT * 
FROM film;SELECT * 
FROM film;

-- 3. 
SELECT *
FROM film
WHERE length < 60;

-- 4. 
SELECT *
FROM customer
WHERE active = 0;

-- 5.
SELECT first_name, last_name, address
FROM customer c, address a
WHERE active = 1 AND c.address_id = a.address_id;

-- 6.
SELECT first_name, last_name, a.address, co.country
FROM customer c, address a, city ct, country co
WHERE c.address_id = a.address_id
	AND a.city_id = ct.city_id 
	AND ct.country_id = co.country_id
    AND co.country = "Brazil";
	
-- 7.
SELECT f.title, a.first_name, a.last_name
FROM film f, film_actor fa, actor a
WHERE f.film_id = fa.film_id AND a.actor_id = fa.actor_id

-- 8. 
SELECT f.title, a.first_name, a.last_name
FROM film f, film_actor fa, actor a
WHERE f.film_id = fa.film_id AND a.actor_id = fa.actor_id
ORDER BY f.title

-- 9.
SELECT f.title, a.first_name, a.last_name
FROM film f, film_actor fa, actor a
WHERE f.film_id = fa.film_id AND a.actor_id = fa.actor_id
ORDER BY a.first_name

-- 10. 
SET @ator := "scarlett";

SELECT f.title, a.first_name, a.last_name
FROM film f, film_actor fa, actor a
WHERE f.film_id = fa.film_id AND a.actor_id = fa.actor_id
AND a.first_name = @ator;

-- 11. 
SELECT COUNT(*) qtd_filmes
FROM film;

-- 12. 
SELECT AVG(length)
FROM film;

-- 13.
SELECT f.title, c.name 
FROM film f,category c, film_category fc
WHERE f.film_id = fc.film_id
  AND fc.category_id = c.category_id;
  
-- 14.
SELECT c.name, COUNT(*)
FROM film f,category c, film_category fc
WHERE f.film_id = fc.film_id AND fc.category_id = c.category_id
GROUP BY c.name;  

-- 15.
SELECT c.name, AVG(f.length)
FROM film f,category c, film_category fc
WHERE f.film_id = fc.film_id 
  AND fc.category_id = c.category_id
GROUP BY c.name;

-- 16.
SELECT c.name, COUNT(*) qtd
FROM film f,category c, film_category fc
WHERE f.film_id = fc.film_id AND fc.category_id = c.category_id
GROUP BY c.name
HAVING qtd < 57;

-- 17.
SELECT c.name, COUNT(*) qtd, AVG(f.length)
FROM film f,category c, film_category fc
WHERE f.film_id = fc.film_id AND fc.category_id = c.category_id
GROUP BY c.name
HAVING qtd < 57;

-- 18. 
SELECT c.first_name, c.last_name, COUNT(*)
FROM customer c, rental r
WHERE c.customer_id = r.customer_id
GROUP BY (c.customer_id);

-- 19.
SELECT c.first_name, c.last_name, COUNT(*) qtd
FROM customer c, rental r
WHERE c.customer_id = r.customer_id
GROUP BY (c.customer_id)
ORDER BY qtd desc;

-- 20. 
SELECT c.first_name, c.last_name
FROM customer c
WHERE EXISTS (SELECT 1 
	FROM rental r
    WHERE c.customer_id = r.customer_id AND r.return_date IS NOT NULL);
	
-- 21.
SELECT c.first_name, c.last_name
FROM customer c
WHERE NOT EXISTS (SELECT 1 
	FROM rental r
    WHERE c.customer_id = r.customer_id AND r.return_date IS NOT NULL);

-- 22. 
SELECT first_name, last_name
FROM actor;

-- 23.
SELECT UPPER(CONCAT(first_name," ",last_name)) AS "Actor Name"
FROM actor;

-- 24.
SELECT actor_id, first_name, last_name
FROM actor 
WHERE first_name = "JOE";

-- 25. 
SELECT actor_id, first_name, last_name 
FROM actor
WHERE last_name LIKE "%GEN%"; 

-- 26.
SELECT last_name, first_name, actor_id 
FROM actor
WHERE last_name LIKE "%LI%"
ORDER BY last_name, first_name; 

-- 27.
SELECT country_id, country
FROM country
WHERE country IN ("Afghanistan","Bangladesh","China");

-- 28.
ALTER TABLE actor
ADD COLUMN description BLOB AFTER last_name;

-- 29.
ALTER TABLE actor
DROP COLUMN description;

-- 30.
SELECT last_name, COUNT(last_name) AS "count_last_name"
FROM actor
GROUP BY last_name
HAVING "count_last_name" >= 1;

-- 31. 
SELECT last_name, COUNT(last_name) AS "count_last_name"
FROM actor
GROUP BY last_name
HAVING "count_last_name" >= 2;

-- 32. 
UPDATE actor
SET first_name = "HARPO", last_name = "WILLIAMS"
WHERE first_name="GROUCHO" AND last_name = "WILLIAMS";

-- 33. 
UPDATE actor
SET first_name = 
CASE
	WHEN first_name = "HARPO"
		THEN "GROUCHO"
	ELSE "MUCHO GROUCHO"
END
WHERE actor_id = 172;

-- 34.
SHOW CREATE TABLE address;

-- 35.
SELECT s.first_name, s.last_name, a.address
FROM staff AS s
INNER JOIN address AS a
ON (s.address_id = a.address_id);

-- 36.
SELECT s.first_name, s.last_name, SUM(p.amount)
FROM staff AS s
INNER JOIN payment AS p
ON p.staff_id = s.staff_id
WHERE MONTH(p.payment_date) = 08 AND YEAR(p.payment_date) = 2005
GROUP BY s.staff_id;

-- 37.
SELECT f.title, COUNT(fa.actor_id) AS "Actors"
FROM film_actor AS fa
INNER JOIN film AS f
ON f.film_id = fa.film_id
GROUP BY f.title
ORDER BY Actors DESC;

-- 38.
SELECT title,COUNT(inventory_id) AS "Inventory Count"
FROM film
INNER JOIN inventory
USING (film_id)
WHERE title = "HUNCHBACK IMPOSSIBLE"
GROUP BY title;

-- 39. 
SELECT c.first_name, c.last_name, SUM(p.amount) AS "Total Amount"
FROM payment AS p
INNER JOIN customer AS c
ON p.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name;

-- 40.
SELECT title
FROM film
WHERE title LIKE "K%"
OR title LIKE "Q%"
AND language_id IN
	(
    SELECT language_id
    FROM language
    WHERE name = "English"
    );

-- 41. 
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
	(
	SELECT actor_id
    FROM film_actor
    WHERE film_id =
		(
		SELECT film_id
        FROM film
        WHERE title = "Alone Trip"
		)
	);

-- 42.
SELECT first_name, last_name, email, country
FROM customer cus
INNER JOIN address a
ON (cus.address_id = a.address_id)
INNER JOIN city cit
ON (a.city_id = cit.city_id)
INNER JOIN country ctr
ON (cit.country_id = ctr.country_id)
WHERE ctr.country = "canada";

-- 43. 
SELECT title, c.name
FROM film f
INNER JOIN film_category fc
ON (f.film_id = fc.film_id)
INNER JOIN category c
ON (c.category_id = fc.category_id)
WHERE name = "family";

-- 44. 
SELECT title, COUNT(title) AS "Rentals"
FROM film 
INNER JOIN inventory
ON (film.film_id = inventory.film_id)
INNER JOIN rental
ON (inventory.inventory_id = rental.inventory_id)
GROUP BY title
ORDER BY rentals DESC;

-- 45.
SELECT s.store_id, SUM(amount) AS Gross
FROM payment p
INNER JOIN rental r
ON (p.rental_id = r.rental_id)
INNER JOIN inventory i
ON (i.inventory_id = r.inventory_id)
INNER JOIN store s
ON (s.store_id = i.store_id)
GROUP BY s.store_id;

-- 46. 
SELECT store_id, city, country
FROM store s
INNER JOIN address a
ON (s.address_id = a.address_id)
INNER JOIN city cit
ON (cit.city_id = a.city_id)
INNER JOIN country ctr
ON (cit.country_id = ctr.country_id);

-- 47.
SELECT SUM(amount) AS 'Total Sales', c.name AS 'Genre'
FROM payment p
INNER JOIN rental r
ON (p.rental_id = r.rental_id)
INNER JOIN inventory i
ON (r.inventory_id = i.inventory_id)
INNER JOIN film_category fc
ON (i.film_id = fc.film_id)
INNER JOIN category c
ON (fc.category_id = c.category_id)
GROUP BY c.name
ORDER BY SUM(amount) DESC;

-- 48. 
CREATE VIEW top_five_genres AS
SELECT SUM(amount) AS 'Total Sales', c.name AS 'Genre'
FROM payment p
INNER JOIN rental r
ON (p.rental_id = r.rental_id)
INNER JOIN inventory i
ON (r.inventory_id = i.inventory_id)
INNER JOIN film_category fc
ON (i.film_id = fc.film_id)
INNER JOIN category c
ON (fc.category_id = c.category_id)
GROUP BY c.name
ORDER BY SUM(amount) DESC
LIMIT 5;

-- 49. 
SELECT *
FROM top_five_genres;

-- 50.
DROP VIEW top_five_genres;