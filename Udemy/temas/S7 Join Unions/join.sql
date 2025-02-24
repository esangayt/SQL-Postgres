-- Claúsula UNION

select code, name
from continent
where name like '%America%'

union

select code, name
from continent
where code in (3, 5)
order by name
;

-- union de tables - where
SELECT a.name, b.name
FROM country AS a
         JOIN continent AS b
              ON a.continent = b.code
ORDER BY a.name;

alter sequence continent_code_seq restart with 8;

delete
from continent
where code = 14;
insert into continent (name)
values ('North Asia');


select a.name, a.continent as code, b.name
from country a
         full outer join continent b
                         on a.continent = b.code
where b.name like '%Asia%';

select a.name, a.continent as code, b.name
from country a
         right join continent b
                    on a.continent = b.code
where a.continent is null;

select count(*) as total, a.continent, b.name
from country a
         join continent b
              on a.continent = b.code
group by a.continent, b.name
union
(select 0 as total, a.continent, b.name
 from country a
          right join continent b
                     on a.continent = b.code
 where a.continent is null
 group by a.continent, b.name)
order by total
;

select distinct a.continent, b.name
from country a
         join continent b
              on a.continent = b.code;

select count(*) as total, b.name
from country a
         join continent b
              on a.continent = b.code
where b.name in ('Asia', 'Europe', 'Africa', 'Antarctica', 'Oceania')
group by b.name

union

(select sum(r.total), 'America' as name
 from (select count(*) total, b.name, a.continent as code
       from country a
                join continent b
                     on a.continent = b.code
       where b.name like '%America%'
       group by a.continent, b.name) r
 group by r.name like '%America%')

order by total
;


-- select  count(*) as total, b.name
select *
from country a
         join continent b
              on a.continent = b.code
where b.name like '%America%';

select max(total), name
from (select count(*) total, countrycode, country.name name
      from city
               inner join country on city.countrycode = country.code
      group by countrycode, country.code) r
;

SELECT MAX(total), name
FROM (
    SELECT COUNT(*) AS total, countrycode, country.name AS name
    FROM city
    INNER JOIN country ON city.countrycode = country.code
    GROUP BY countrycode, country.name
) r;

-- select count(*) total, countrycode, country.name, country.surfacearea
select country.*
      from city
               inner join country on city.countrycode = country.code
      group by countrycode,country.code

