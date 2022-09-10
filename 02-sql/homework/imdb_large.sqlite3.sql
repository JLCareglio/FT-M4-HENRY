/* comandos recomendados:
 .header on
 .mode column
 .timer on
 */
SELECT *
FROM movies
WHERE year = 1902
  AND rank > 5;
-- 1. Birthyear: Buscá todas las películas filmadas en el año que naciste.
SELECT *
FROM movies
WHERE year = 1995;
-- 2. 1982: Cuantas películas hay en la DB que sean del año 1982?
SELECT COUNT(year) AS "Cantidad del año 1982:"
FROM movies
WHERE year = 1982;
-- 3. Stacktors: Buscá actores que tengan el substring stack en su apellido.
SELECT *
FROM actors
WHERE last_name LIKE "%stack%";
-- 4. Fame Name Game: Buscá los 10 nombres y apellidos más populares entre los actores. Cuantos actores tienen cada uno de esos nombres y apellidos?
SELECT first_name,
  last_name,
  COUNT(*) AS total
FROM actors
GROUP BY LOWER(first_name),
  LOWER(last_name)
ORDER BY total DESC
LIMIT 10;
-- 5. Prolific: Listá el top 100 de actores más activos junto con el número de roles que haya realizado.
SELECT actors.first_name,
  actors.last_name,
  COUNT(*) AS total
FROM actors
  JOIN roles ON actors.id = roles.actor_id
GROUP BY actors.id
ORDER BY total DESC
LIMIT 100;
-- 6. Bottom of the Barrel: Cuantas películas tiene IMDB por género? Ordená la lista por el género menos popular.
SELECT genre,
  COUNT(genre) AS total
FROM movies_genres
GROUP BY genre
ORDER BY total;
-- 7. Braveheart: Listá el nombre y apellido de todos los actores que trabajaron en la película "Braveheart" de 1995, ordená la lista alfabéticamente por apellido.
SELECT actors.first_name,
  actors.last_name
FROM actors
  JOIN roles ON actors.id = roles.actor_id
  JOIN movies ON movies.id = roles.movie_id;
-- 8. Leap Noir: Listá todos los directores que dirigieron una película de género 'Film-Noir' en un año bisiesto (para reducir la complejidad, asumí que cualquier año divisible por cuatro es bisiesto). Tu consulta debería devolver el nombre del director, el nombre de la peli y el año. Todo ordenado por el nombre de la película.
-- 9. ° Bacon: Listá todos los actores que hayan trabajado con Kevin Bacon en películas de Drama (incluí el título de la peli). Excluí al señor Bacon de los resultados.