select 
  count(check_id) as low_severity_count
  from dq_checks where lower(severity) like '%low%' and year(run_at) = '2026'
