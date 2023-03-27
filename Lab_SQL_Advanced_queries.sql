# In this lab, you will be using the Sakila database of movie rentals.
USE sakila;

# For each film, list actor that has acted in more films.

WITH actor_film_count AS       -- first CTE to get the number of films each actor has acted in
(SELECT actor_id, COUNT(film_id) AS acted
    FROM film_actor
    GROUP BY actor_id
),
top_actors_per_film AS (      -- second CTE to get film_id, film_title, actor_id, and the number of films each actor has acted in
    SELECT 
        f.film_id,
        f.title AS film_title,
        fa.actor_id,
        af.acted,
        RANK() OVER (PARTITION BY fa.film_id ORDER BY af.acted DESC) AS rank_actors
    FROM 
        film f
    JOIN 
        film_actor fa ON f.film_id = fa.film_id
    JOIN 
        actor_film_count af ON fa.actor_id = af.actor_id
)
SELECT top_actors_per_film.film_title, top_actors_per_film.actor_id
FROM top_actors_per_film
WHERE top_actors_per_film.rank_actors = 1
ORDER BY top_actors_per_film.film_id;