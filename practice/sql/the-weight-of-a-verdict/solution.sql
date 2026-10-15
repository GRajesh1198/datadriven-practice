select
  -- total rows against that status
  pipe_id,
  pipe_name,
  status,
  rows_in,
  rows_out,
  start_at,
  dur_secs,
  sum(rows_in) over (partition by status) as status_total_rows_in
from
  data_pipes
