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
WHERE movies.name = 'Braveheart'
  AND movies.year = 1995
ORDER BY actors.last_name;
-- 8. Leap Noir: Listá todos los directores que dirigieron una película de género 'Film-Noir' en un año bisiesto (para reducir la complejidad, asumí que cualquier año divisible por cuatro es bisiesto). Tu consulta debería devolver el nombre del director, el nombre de la peli y el año. Todo ordenado por el nombre de la película.
select d.first_name,
  d.last_name,
  m.name,
  m.year -- lo que necesitamos
from directors as d
  join movies_directors as md on md.director_id = d.id -- director unimos con movie_dir
  join movies as m on m.id = md.movie_id --  movie_director con movie 
  join movies_genres as mg on m.id = mg.movie_id -- movie con generos
where mg.genre = 'Film-Noir'
  and m.year % 4 = 0 -- las condiciones
order by m.name;
-- 9. ° Bacon: Listá todos los actores que hayan trabajado con Kevin Bacon en películas de Drama (incluí el título de la peli). Excluí al señor Bacon de los resultados.
select m.id
from movies as m
  join roles as r on m.id = r.movie_id
  join actors as a on r.actor_id = a.id
where a.first_name = 'Kevin'
  and a.last_name = 'Bacon';
​
select distinct a.first_name,
  a.last_name,
  m.name
from actors as a
  join roles as r on a.id = r.actor_id
  join movies as m on r.movie_id = m.id
  join movies_genres as mg on m.id = mg.movie_id
where mg.genre = 'Drama'
  and m.id in (
    select m.id
    from movies as m
      join roles as r on m.id = r.movie_id
      join actors as a on r.actor_id = a.id
    where a.first_name = 'Kevin'
      and a.last_name = 'Bacon'
  )
  and (
    a.first_name || ' ' || a.last_name != 'Kevin Bacon'
  )
order by a.last_name;
-- 10. Immortal Actors: ¿Qué actores actuaron en una película antes de 1900 y también en una película después del 2000?
select r.actor_id
from roles as r
  join movies as m on r.movie_id = m.id
where m.year < 1900
limit 20;
​
select *
from actors
where id in (
    select r.actor_id
    from roles as r
      join movies as m on r.movie_id = m.id
    where m.year < 1900
  )
  and id in (
    select r.actor_id
    from roles as r
      join movies as m on r.movie_id = m.id
    where m.year > 2000
  )
limit 20;
-- 11. Busy Filming: Buscá actores que actuaron en cinco o más roles en la misma película después del año 1990. Noten que los ROLES pueden tener duplicados ocasionales, sobre los cuales no estamos interesados: queremos actores que hayan tenido cinco o más roles DISTINTOS (DISTINCT cough cough) en la misma película. Escribí un query que retorne los nombres del actor, el título de la película y el número de roles (siempre debería ser > 5).
select a.first_name,
  a.last_name,
  m.name,
  count(distinct (role)) as total_roles
from actors as a
  join roles as r on a.id = r.actor_id
  join movies as m on r.movie_id = m.id
where m.year > 1990
group by a.id,
  m.id
having total_roles > 5;
-- 12. ♀ Para cada año, contá el número de películas en ese año que sólo tuvieron actrices femeninas.
select r.movie_id
from roles as r
  join actors as a on r.actor_id = a.id
where a.gender = 'M' ​
select year,
  count(id) as total
from movies
where id not in (
    select r.movie_id
    from roles as r
      join actors as a on r.actor_id = a.id
    where a.gender = 'M'
  )
group by year;
-- 13. ♂️ Para cada año, contá el número de películas en ese año que sólo tuvieron actores masculinos.
select r.movie_id
from roles as r
  join actors as a on r.actor_id = a.id
where a.gender = 'M' ​
select year,
  count(id) as total
from movies
where id in (
    select r.movie_id
    from roles as r
      join actors as a on r.actor_id = a.id
    where a.gender = 'M'
  )
group by year;