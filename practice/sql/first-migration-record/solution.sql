-- each databases first_migr
select migr_id,version,status,applied,rollback,dur_ms,author,db_name from (select
  *,
  row_number() over (partition by db_name order by migr_id) as r
from
migrations) as c
where r = 1
order by dur_ms
