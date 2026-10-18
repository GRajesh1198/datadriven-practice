select count(owner_id) as non_read_owner_count from (
select
  owner_id,
  sum(case when scope like 'read%' then 0 else 1 end) as api_stat
  from
    api_tokens
  group by owner_id) as c
  where api_stat > 1
