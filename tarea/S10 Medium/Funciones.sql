create or replace function sayHello(username varchar)
    returns varchar
as
$$
declare
    result json;
begin
    return 'Hello! ' || username;
end;
$$
    language plpgsql;

select sayhello(users.username)
from users;

create or replace function comment_replies(id integer)
    returns varchar
as
$$
declare
    result json;
begin
    select json_agg(jsonb_build_object(
            'user', user_id, 'comment', content
                    ))
    into result
    from comments b
    where b.comment_parent_id = id;

    return result;
end;
$$
language plpgsql;
select comment_replies(1);