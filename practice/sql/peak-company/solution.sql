with valid as (
  select token_id,issued,expires
  from api_tokens
  where expires is NULL or expires > issued
), events as (
    select issued as dt, 1 as delta 
    from valid
    union all
    select expires as dt, -1 as delta
    from valid where expires is not null
  ), daily as (
    select dt, sum(delta) as daily_count from events group by dt
    ), live as (
    select dt, sum(daily_count) over 
      (order by dt rows between unbounded preceding and current row) as live_count
    from daily
    ), token_count as (
    select v.token_id, l.live_count, l.dt as peak_date, 
      row_number() over (partition by v.token_id order by l.live_count desc,l.dt) as rn
     from valid v
     join live as l
       on v.issued <= l.dt 
         and (v.expires is null or v.expires > l.dt)
    )
 select token_id, live_count as peak_concurrent,peak_date from token_count
 where rn = 1
