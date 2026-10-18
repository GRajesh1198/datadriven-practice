select
    count(distinct owner_id) as non_read_owner_count
  from
    api_tokens 
    where scope not like 'read%'
