-- 1. Cuantos usuarios tenemos con cuentas @google.com
-- Tip: count, like
select count(*),
       substr(email, position('@' in email)) as consulta
from users
where right(email, length('@google.com')) = '@google.com'
group by substr(email, position('@' in email));

select count(*)
from users
where email like '%@google.com';

-- 2. De qué países son los usuarios con cuentas de @google.com
-- Tip: distinct
select distinct country
from users
where right(email, length('@google.com')) = '@google.com';

-- 3. Cuantos usuarios hay por país (country)
-- Tip: Group by
select count(*),
       country
from users
group by country;

-- 4. Listado de direcciones IP de todos los usuarios de Iceland
-- Campos requeridos first_name, last_name, country, last_connection
select first_name, last_name, country, last_connection
from users
where country = 'Iceland';

-- 5. Cuantos de esos usuarios (query anterior) tiene dirección IP
-- que incia en 112.XXX.XXX.XXX
SELECT COUNT(*) AS cantidad
FROM users
WHERE country = 'Iceland'
  AND last_connection like '112.%';


SELECT COUNT(*) AS cantidad
FROM users
WHERE country = 'Iceland'
  AND left(last_connection, 3) = '112';

-- 6. Listado de usuarios de Iceland, tienen dirección IP
-- que inicia en 112 ó 28 ó 188
-- Tip: Agrupar condiciones entre paréntesis
-- SELECT COUNT(*) AS cantidad,

-- SELECT count(*), last_connection
SELECT first_name, last_name, country, last_connection
FROM users
WHERE country = 'Iceland'
  AND (last_connection LIKE '112.%' OR last_connection LIKE '28.%' OR last_connection LIKE '188.%')
--   AND left(last_connection, 3) in ('112', '28', '188')
-- group by last_connection;

-- 7. Ordene el resultado anterior, por apellido (last_name) ascendente
-- y luego el first_name ascendentemente también
SELECT count(*), last_connection
FROM users
WHERE country = 'Iceland'
  AND (last_connection LIKE '112.%' OR last_connection LIKE '28.%' OR last_connection LIKE '188.%')
--   AND left(last_connection, 3) in ('112', '28', '188')
group by last_connection;

SELECT first_name, last_name, country, last_connection
FROM users
WHERE country = 'Iceland'
  AND (last_connection LIKE '112.%' OR last_connection LIKE '28.%' OR last_connection LIKE '188.%')
order by last_name , first_name
;


-- 8. Listado de personas cuyo país está en este listado
-- ('Mexico', 'Honduras', 'Costa Rica')
-- Ordenar los resultados de por País asc, Primer nombre asc, apellido asc
-- Tip: Investigar IN
-- Tip2: Ver Operadores de Comparación en la hoja de atajos (primera página)
select country, first_name, last_name
from users
where country in ('Mexico', 'Honduras', 'Costa Rica')
order by country, first_name, last_name;

-- 9. Del query anterior, cuente cuántas personas hay por país
-- Ordene los resultados por País asc
select count(*) as cantidad,
       country
from users
where country in ('Mexico', 'Honduras', 'Costa Rica')
group by country
order by country;