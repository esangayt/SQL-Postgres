select now(),
       current_date,
       current_time
--        date_part('year', now()),
--        date_part('month', now()),
--        date_part('day', now()),
--        date_part('hour', now()),
--        date_part('minute', now()),
--        date_part('second', now())
;

select first_name, hire_date
from employees
;

select max(hire_date),
--        max(hire_date) + interval '1 month',
--        max(hire_date) + interval '10 days',
--        max(hire_date) + interval '1 year',
       max(hire_date) + interval '1.1 year',
       max(hire_date) + make_interval(years := 23)
from employees;

select current_date,
       DATE_PART('years', current_date),
       now() + make_interval(years := 23);


select hire_date,
       MAKE_INTERVAL(years := 2024 - extract(years from hire_date)::integer),
       MAKE_INTERVAL(years := DATE_PART('years', current_date)::integer -
                              extract(years from hire_date)::integer)
from employees;


select date_part('year', '2024-01-01'::date),
       extract(year from '2024-01-01'::date);


update employees
set hire_date = hire_date + MAKE_INTERVAL(years :=
    DATE_PART('years', current_date)::integer -
    extract(years from hire_date)::integer);

