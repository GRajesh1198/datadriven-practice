-- repo_name (time between longest commit) 
with cte as (
  select *, lag(commit_at) over (partition by repo_name order by commit_at) prev_commit
  from repo_commits
), cte2 as (
    select *, max(round(julianday(commit_at) - julianday(prev_commit),3)) as longest_silence
        from cte
      group by repo_name
      having count(commit_id) >= 33
  ), cte3 as (
        select *,row_number() over (order by longest_silence desc) as silence_rank
        from cte2
        )
select repo_name,longest_silence, silence_rank from cte3
