-- ================== BD: MEDIUM -> DJANGO REST

-- 1. Cuantos Post hay - 1050
select count(*)
from posts;


-- 2. Cuantos Post publicados hay - 543
select count(*)
from posts
where published = True;

-- 3. Cual es el Post mas reciente
-- 544 - nisi commodo officia...2024-05-30 00:29:21.277
select post_id, title, body
from posts
order by created_at desc
limit 1;


-- 4. Quiero los 10 usuarios con más post, cantidad de posts, id y nombre
/*
4	1553	Jessie Sexton
3	1400	Prince Fuentes
3	1830	Hull George
3	470	Traci Wood
3	441	Livingston Davis
3	1942	Inez Dennis
3	1665	Maggie Davidson
3	524	Lidia Sparks
3	436	Mccoy Boone
3	2034	Bonita Rowe
*/
select count(*), p.created_by, name
from users u
         join posts p on u.user_id = p.created_by
-- where user_id = 1553
group by p.created_by, name
order by count(*) desc
limit 10;
-- group by p.created_by
-- order by count(*) desc

-- 5. Quiero los 5 post con más "Claps" sumando la columna "counter"
/*
692	sit excepteur ex ipsum magna fugiat laborum exercitation fugiat
646	do deserunt ea
542	do
504	ea est sunt magna consectetur tempor cupidatat
502	amet exercitation tempor laborum fugiat aliquip dolore
*/

select c.counter, p.title, c.post_id, p.post_id
from posts p
         join claps c on p.post_id = c.post_id
where p.title = 'do';
-- group by p.title
-- order by total desc
-- limit 5
-- 6. Top 5 de personas que han dado más claps (voto único no acumulado ) *count
/*
7	Lillian Hodge
6	Dominguez Carson
6	Marva Joyner
6	Lela Cardenas
6	Rose Owen
*/
select count(*), u.name
from users u
         join claps c on u.user_id = c.user_id
group by c.user_id, u.name
order by count(*) desc
limit 5;

select count(*), u.name
from users u
         join claps c on u.user_id = c.user_id
group by u.name
order by count(*) desc
limit 5;



-- 7. Top 5 personas con votos acumulados (sumar counter)
/*
437	Rose Owen
394	Marva Joyner
386	Marquez Kennedy
379	Jenna Roth
364	Lillian Hodge
*/
select sum(c.counter) as sum, u.name
from users u
         join claps c on u.user_id = c.user_id
-- where u.name = 'Larson Bond';
group by u.name
order by sum desc
limit 5;

-- 8. Cuantos usuarios NO tienen listas de favoritos creada
-- 329
select count(*)
from users u
         LEFT JOIN user_lists ul ON
    u.user_id = ul.user_id
WHERE ul.user_id IS NULL;


-- 9. Quiero el comentario con id 1
-- Y en el mismo resultado, quiero sus respuestas (visibles e invisibles)
-- Tip: union
/*
1	    648	1905	elit id...
3058	583	1797	tempor mollit...
4649	51	1842	laborum mollit...
4768	835	1447	nostrud nulla...
*/
select c.comment_id, c.user_id, c.post_id, c.content
from comments c
where comment_id = 1
union
select comment_child.comment_id, comment_child.user_id, comment_child.post_id, comment_child.content
from comments as coment_parent
         join comments as comment_child on coment_parent.comment_id = comment_child.comment_parent_id
where coment_parent.comment_id = 1
order by comment_id;

select c.comment_id, c.user_id, c.post_id, c.content, c.comment_parent_id
from comments c
where comment_id = 1
union
select c.comment_id, c.user_id, c.post_id, c.content, c.comment_parent_id
from comments c
where comment_parent_id = 1

-- ** 10. Avanzado
-- Investigar sobre el json_agg y json_build_object
-- Crear una única linea de respuesta, con las respuestas
-- del comentario con id 1 (comment_parent_id = 1)
-- Mostrar el user_id y el contenido del comentario

-- Salida esperada:
/*
"[{""user"" : 1797, ""comment"" : ""tempor mollit aliqua dolore cupidatat dolor tempor""}, {""user"" : 1842, ""comment"" : ""laborum mollit amet aliqua enim eiusmod ut""}, {""user"" : 1447, ""comment"" : ""nostrud nulla duis enim duis reprehenderit laboris voluptate cupidatat""}]"
*/
select jsonb_build_object('user', comment_child.user_id, 'comment', comment_child.content)
from comments as coment_parent
         join comments as comment_child on coment_parent.comment_id = comment_child.comment_parent_id
where coment_parent.comment_id = 1;

select json_agg(jsonb_build_object('user', user_id, 'comment', content))
from comments
where comment_parent_id = 1;
-- order by comment_id;

-- select json_agg(email) from users;
-- SELECT json_build_object(
--     'id', user_id,
--     'customer_name', name,
--     'username', username
-- ) AS users_json
-- FROM users
-- WHERE user_id = 1;
--
-- select json_agg(json_build_object('id', user_id,
--     'customer_name', name,
--     'username', username)) as users_json
-- from users

-- ** 11. Avanzado
-- Listar todos los comentarios principales (no respuestas) 
-- Y crear una columna adicional "replies" con las respuestas en formato JSON

select coment_parent.comment_id,
       coment_parent.user_id,
       coment_parent.post_id,
       coment_parent.content,
       jsonb_agg(jsonb_build_object('user', comment_child.user_id, 'comment', comment_child.content)) as replies
from comments coment_parent
         join comments as comment_child on coment_parent.comment_id = comment_child.comment_parent_id
where coment_parent.comment_parent_id is null
group by coment_parent.comment_id, coment_parent.user_id, coment_parent.post_id, coment_parent.content

select a.*,
       (select json_agg(jsonb_build_object(
               'user', user_id, 'comment', content
                        ))
        from comments b
        where b.comment_parent_id = a.comment_id)
from comments a
where comment_parent_id is null;

-- 12. Listar los post que tienen más de 10 comentarios
-- Y mostrar los comentarios en formato JSON
select p.post_id, p.title, p.body,
       jsonb_agg(jsonb_build_object('user', c.user_id, 'comment', c.content)) as comments
from posts p
         join comments c on p.post_id = c.post_id
group by p.post_id, p.title, p.body
having count(c.comment_id) > 10;




