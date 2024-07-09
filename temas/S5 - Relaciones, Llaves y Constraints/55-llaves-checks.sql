select *
from country;


delete from country
    where code = 'NLD' and code2 = 'NA';

alter table country
    add PRIMARY KEY (code);

select * from country;

alter table country
    add check ( surfacearea >= 0 );

select distinct continent
from country;

alter table country
    add check ( continent in
                ('Asia', 'Europe', 'North America', 'Africa', 'Oceania', 'Antarctica', 'South America', 'America')
        );

select *
from country
where code = 'CRI';

alter table country
    drop constraint "country_continent_check";

select *
from country;

create index "country_continent"
    on country (continent);

select * from country where continent = 'Europe';

select * from city;

alter table city
    add PRIMARY KEY (id);
