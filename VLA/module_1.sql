-- create database
CREATE DATABASE CURSOSQL;

-- Muestra la estructura de la base de datos
sp_helpdb CURSOSQL;

-- Create database with file path
CREATE DATABASE Example01 ON PRIMARY
    (
        NAME = Example1_data,
        FILENAME = '/var/opt/mssql/data/Example1_data.mdf',
        SIZE = 10 MB,
        MAXSIZE = 50 MB,
        FILEGROWTH = 1 MB

);

-- Muestra la estructura de la base de datos
sp_helpdb Example01;

-- List databases in the server
select name
from sys.databases;

select name
from sys.sysdatabases;

-- Rename database Example01 to Example02
sp_renamedb 'Example01', 'COURSE_02';

-- Muestra la estructura de la base de datos
sp_helpdb COURSE_02;

-- Crear un inicio de sesión
CREATE LOGIN servidor WITH PASSWORD = '12345678A.';

--  Crea un usuario en la base de datos
create user servidor for login servidor;

-- select current user
select CURRENT_USER;
select name
from sys.syslogins;


use CURSOSQL

-- estado de inicio de sesión
select *
from sys.server_principals
where name = 'sa';

select *
from sys.database_permissions
where grantee_principal_id = user_id('servidor');

-- Mostrar permisos del usuario
select *
from sys.database_permissions
where grantee_principal_id = (
    select principal_id
    from sys.server_principals
    where name = 'sa'
)

-- Crear permiso para base de datos
GRANT SELECT ON SCHEMA::dbo TO servidor;
    -- Selecciona dentro del esquema de la base de datos a un usuario
    -- Para asigna permisos

GRANT INSERT , UPDATE, DELETE ON SCHEMA::dbo TO servidor;

-- Crear respaldo
BACKUP DATABASE CURSOSQL TO DISK = 'C:\Users\Delta2\Pictures\CURSOSQL.bak';

-- Restaurar respaldo de base de datos
-- Debe hacer el respado usando la bd master
USE master;
RESTORE DATABASE CURSOSQL FROM DISK = 'C:\Users\Delta2\Pictures\CURSOSQL.bak';

-- Desconectar usuarios
ALTER DATABASE CURSOSQL SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
-- Conectar a los usuarios a la bd
ALTER DATABASE CURSOSQL SET MULTI_USER;

