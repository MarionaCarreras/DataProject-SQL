-- 2.  Muestra los nombres de todas las películas con una clasificación por edades de ‘R’

select title, rating  
from film f 
where rating ='R';


--3.  Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.

select concat(first_name,' ',last_name) as nombre_actores
from actor fa
where "actor_id" between 30 and 40;

--4. Obtén las películas cuyo idioma coincide con el idioma original.

select title 
from film
where "language_id"="original_language_id";

--5. Ordena las películas por duración de forma ascendente.

select title, "length" 
from film f 
order by "length" asc;

--6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.

select first_name, last_name 
from actor	
where "last_name" like '%ALLEN%';

--7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento.


select rating, count(title) as total_peliculas  
from film f
group by rating ;

--8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film.

select title, rating, length   
from film f
where "rating"='PG-13' or "length">180;

--9. Encuentra la variabilidad de lo que costaría reemplazar las películas.

select stddev(replacement_cost)
from film f ;

--10. Encuentra la mayor y menor duración de una película de nuestra BBDD.

select max(length), min(length)
from film;

--11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.


select amount, payment_date  
from payment p 
order by payment_date desc
limit 1 offset 2;

--12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC17’ ni ‘G’ en cuanto a su clasificación.


select title, rating 
from film f
where rating <> 'NC-17' and rating <> 'G';

-- 13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

select rating, AVG(length) as promedio_duracion
from film f 
group by rating ;

--14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.

select title, length
from film f 
where length>180;

--15. ¿Cuánto dinero ha generado en total la empresa?

select sum(amount)
from payment;

--16. Muestra los 10 clientes con mayor valor de id.


select customer_id, concat("first_name",' ', "last_name")
from customer c
order by customer_id desc
limit 10;

--17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’



select a."first_name", a."last_name", f.title
from film as f
join "film_actor" as fa
	on f."film_id"=fa."film_id"
join "actor" as a
 	on fa."actor_id"=a."actor_id"
where f.title='EGG IGBY';


--18. Selecciona todos los nombres de las películas únicos.

select title, count(title)
from film f 
group by title
having count(title)>1;

--19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”.

select f.title, c.name
from film f
join film_category fc  
	on f."film_id"=fc."film_id"
join category c 
	on fc."category_id"=c."category_id"
where f.length>180 and c."name"='Comedy';

--20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.

select c.name, avg(f.length)
from film f
join film_category fc  
	on f."film_id"=fc."film_id"
join category c 
	on fc."category_id"=c."category_id"
group by c.name
having avg(f.length)>110;

--21. ¿Cuál es la media de duración del alquiler de las películas?


select AVG(rental_duration)
from film;

--22. Crea una columna con el nombre y apellidos de todos los actores y actrices.

select concat("first_name", ' ', "last_name")
from actor a ;

--23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.


select date(rental_date), count(rental_id)
from rental r  
group by date(rental_date)
order by count(rental_id) DESC;

--24. Encuentra las películas con una duración superior al promedio.

SELECT f.title
FROM film f
WHERE f.length > (SELECT AVG(f2.rental_duration) FROM film f2);

--25. Averigua el número de alquileres registrados por mes.

select EXTRACT(MONTH FROM "rental_date"::DATE) AS mes, count(rental_id) as num_alquileres
from rental
group by mes
order by mes ASC;

--26. Encuentra el promedio, la desviación estándar y varianza del total pagado


select AVG(amount), stddev(amount), variance(amount)
from payment;

--27. ¿Qué películas se alquilan por encima del precio medio?

SELECT 
    f.title, 
    f.rental_rate,
    (SELECT AVG(rental_rate) FROM film) AS avg_rental_rate
FROM film f
WHERE f.rental_rate > (SELECT AVG(rental_rate) FROM film);


-- 28. Muestra el id de los actores que hayan participado en más de 40 películas.

select actor_id, count(actor_id) as participaciones
from film_actor fa
group by actor_id
having count(actor_id)>40;

--29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.

select *
from inventory;


select f.film_id, count(i.inventory_id) as peliculas_disponibles
from film f 
left join inventory i 
	on f.film_id=i.film_id
group by f.film_id;

--30. Obtener los actores y el número de películas en las que ha actuado.

select a.actor_id, concat(a.first_name, ' ', a.last_name), count(a.actor_id) as actuaciones
from actor a 
join film_actor fa 
	on a.actor_id=fa.actor_id
group by a.actor_id;

--31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.

select f.title, a.first_name, a.last_name
from film f 
full join film_actor fa 
	on f.film_id=fa.film_id
LEFT JOIN actor a 
	ON fa.actor_id = a.actor_id;

--32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
	
	select a.first_name, a.last_name, f.title
	from actor a 
	left join film_actor fa 
		on a.actor_id=fa.actor_id
	left JOIN film f  
		ON fa.film_id = f.film_id;
	
--33. Obtener todas las películas que tenemos y todos los registros de alquiler.
	
SELECT f.title, r.rental_id, r.rental_date, r.customer_id
FROM film f
LEFT JOIN inventory i 
	ON f.film_id = i.film_id
LEFT JOIN rental r 
	ON i.inventory_id = r.inventory_id
ORDER BY f.title;

--34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.

select c.first_name, c.last_name, SUM(p.amount) as cantidad_gastada
from payment p 
join customer c 
	on p.customer_id=c.customer_id
group by c.customer_id
order by cantidad_gastada desc
limit 5;

--35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.

select first_name, last_name
from actor a
where first_name like '%JOHNNY%';

--36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido

select first_name as Nombre, last_name as Apellido
from actor a ;

--37. Encuentra el ID del actor más bajo y más alto en la tabla actor.

select min(actor_id), max(actor_id)
from actor;

--38. Cuenta cuántos actores hay en la tabla “actor”

select count(actor_id)
from actor;

--39. Selecciona todos los actores y ordénalos por apellido en orden ascendente

select first_name as Nombre, last_name as Apellido
from actor
order by last_name asc;

--40. Selecciona las primeras 5 películas de la tabla “film”.

select title
from film f 
limit 5;

--41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?

select first_name as Nombre, count(first_name) as mismo_nombre
from actor
group by first_name
order by count(first_name) desc
limit 1;

--42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.

select r.rental_id, c.first_name, c.last_name
from rental r 
left join customer c 
	on r.customer_id=r.customer_id;

--43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.

select c.first_name, c.last_name, r.rental_id
from customer c
left join rental r 
	on c.customer_id=r.customer_id
ORDER BY c.last_name, c.first_name;

--44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.

La consulta CROSS JOIN entre film y category no aporta valor en la mayoría de los casos porque no existe una relación directa entre estas dos tablas.

--45. Encuentra los actores que han participado en películas de la categoría 'Action'.

SELECT DISTINCT a.first_name, a.last_name, c.name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action';

--46. Encuentra todos los actores que no han participado en películas.

select a.first_name, a.last_name
from actor a 
left join film_actor fa 
	on a.actor_id=fa.actor_id
where fa.film_id IS Null;

--47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.


sELECT  a.first_name, a.last_name, count(f.film_id)
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
group by a.first_name, a.last_name;

--48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado

create view actor_num_peliculas as
SELECT  a.first_name, a.last_name, count(f.film_id)
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
group by a.first_name, a.last_name;

--49. Calcula el número total de alquileres realizados por cada cliente.

select customer_id, count(rental_id) as num_alquileres
from rental r 
group by r.customer_id;

--50. Calcula la duración total de las películas en la categoría 'Action'.

select sum(f.length)
from film f
join film_category fc  
	on f."film_id"=fc."film_id"
join category c 
	on fc."category_id"=c."category_id"
where c."name"='Action';

--51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente

WITH cliente_rentas_temporal AS (
    SELECT customer_id, COUNT(rental_id) AS num_alquileres
    FROM rental r
    GROUP BY r.customer_id
)
SELECT * 
FROM cliente_rentas_temporal;

--52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.

WITH peliculas_alquiladas AS (
    SELECT f.film_id, f.title, COUNT(r.rental_id) AS num_alquileres
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    GROUP BY f.film_id, f.title
    HAVING COUNT(r.rental_id) >= 10
)
SELECT * 
FROM peliculas_alquiladas;

--53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.


SELECT f.title
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id
WHERE c.first_name = 'Tammy' AND c.last_name = 'Sanders'
AND r.return_date IS NULL
ORDER BY f.title;

--54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados alfabéticamente por apellido.


SELECT distinct a.first_name, a.last_name, c.name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Sci-Fi'
ORDER BY a.last_name, a.first_name;


--55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaper’ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.

SELECT DISTINCT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_date > (
    SELECT MIN(rental_date)
    FROM rental r2
    JOIN inventory i2 ON r2.inventory_id = i2.inventory_id
    JOIN film f2 ON i2.film_id = f2.film_id
    WHERE f2.title = 'SPARTACUS CHEAPER'
)
ORDER BY a.last_name, a.first_name;

--56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.

SELECT distinct a.first_name, a.last_name, c.name
FROM actor a
left JOIN film_actor fa ON a.actor_id = fa.actor_id
left JOIN film f ON fa.film_id = f.film_id
left JOIN film_category fc ON f.film_id = fc.film_id
left JOIN category c ON fc.category_id = c.category_id
where c.name!='Music' or c.name is Null;

--57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.

SELECT f.title, (DATE(r.return_date) - DATE(r.rental_date)) as dias_alquilados
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE DATE(r.return_date) - DATE(r.rental_date) > 8;

--58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.

select f.title, c.name
from film f
join film_category fc  
	on f."film_id"=fc."film_id"
join category c 
	on fc."category_id"=c."category_id"
where c."name"='Animation';

--59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. Ordena los resultados alfabéticamente por título de película.

SELECT f.title
FROM film f
WHERE f.length = (
    SELECT f2.length
    FROM film f2
    WHERE f2.title = 'DANCING FEVER'
)
ORDER BY f.title;

--60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.

select c.first_name, c.last_name, count(r.rental_id) as peliculas_alquiladas
from customer c 
join rental r 
	on c.customer_id=r.customer_id
group by c.first_name, c.last_name
having count(r.rental_id)>7
order by c.last_name, c.first_name;

--61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT cat.name AS category_name, COUNT(r.rental_id) AS rental_count
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
GROUP BY cat.name
ORDER BY rental_count DESC;

--62. Encuentra el número de películas por categoría estrenadas en 2006.

select cat.name as categoria, count(f.film_id) as num_peliculas
from film f 
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
where f.release_year=2006
group by cat.name;

--63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.

select *
from staff s 
cross join store s2;

--64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas

select c.customer_id, c.first_name, c.last_name, count(r.rental_id) as peliculas_alquiladas
from customer c 
join rental r on c.customer_id=r.customer_id
group by c.customer_id;
