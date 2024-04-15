-- Challenge
-- Write SQL queries to perform the following tasks using the Sakila database:

-- Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
USE sakila;

SELECT 
    COUNT(i.inventory_id) AS num_copies
FROM
    sakila.film f
        JOIN
    sakila.inventory i USING (film_id)
WHERE
    f.title = 'Hunchback Impossible';
-- List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT 
    *
FROM
    sakila.film f
WHERE
    f.length > (SELECT 
            AVG(length)
        FROM
            sakila.film);
-- Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT 
    a.first_name, a.last_name
FROM
    sakila.actor a
WHERE
    a.actor_id IN (SELECT 
            actor_id
        FROM
            sakila.film_actor
        WHERE
            film_id = (SELECT 
                    film_id
                FROM
                    sakila.film
                WHERE
                    title = 'Alone Trip'));
-- select a.first_name,a.last_name
-- FROM sakila.actor a
-- JOIN sakila.film_actor fa
-- USING(actor_id) 
-- JOIN sakila.film f
-- USING(film_id)
-- where f.title = "Alone Trip";

-- Bonus:

-- Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
select f.title
from sakila.film f
where film_id IN (
select film_id from sakila.film_category where category_id = (
select category_id from sakila.category  where name = "family"));

-- SELECT f.title
-- FROM sakila.category c
-- JOIN sakila.film_category fc
-- USING(category_id)
-- JOIN sakila.film f
-- USING(film_id)
-- where c.name = "family";


-- Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT c.first_name,c.last_name,c.email
FROM sakila.country co
INNER JOIN sakila.city ci
USING(country_id)
INNER JOIN sakila.address ad
USING(city_id)
INNER JOIN sakila.customer c
USING(address_id)
where co.country = "Canada";

-- Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
select f.title
from sakila.film f
JOIN sakila.film_actor fa
USING(film_id)
INNER JOIN sakila.actor a
USING(actor_id)
where fa.actor_id = (SELECT actor_id FROM (
                        SELECT 
                            a.actor_id,
                            COUNT(f.film_id) AS film_count
                        FROM 
                            actor a
                        JOIN 
                            film_actor fa ON a.actor_id = fa.actor_id
                        GROUP BY 
                            a.actor_id
                        ORDER BY 
                            film_count DESC
                        LIMIT 1
                    ) AS most_prolific_actor)
