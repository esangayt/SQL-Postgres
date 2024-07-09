

-- 1. Ver todos los registros
select * from users;
-- 2. Ver el registro cuyo id sea igual a 10
select * from users where id = 10;

-- 3. Quiero todos los registros que cuyo primer nombre sea Jim (engañosa)
select * from users where name like 'Jim %';

-- 4. Todos los registros cuyo segundo nombre es Alexander
select * from users where name like '% Alexander';

-- 5. Cambiar el nombre del registro con id = 1, por tu nombre Ej:'Fernando Herrera'
select * from users where id = 1;
update users set name='Erlin Sangay' where id=1;

-- 6. Borrar el último registro de la tabla
select max(id) from users;

delete from users where id = (select max(id) from users);
