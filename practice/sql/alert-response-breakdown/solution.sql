-- alert,severity
--total alerts that were ritical
--  high
-- not acked
-- number of alerts service saw to two decmial

select * from (select
  svc_name,
  count(alert_id) as total_alerts,
  sum(
    case when lower(severity) = 'critical' then 1 else 0 end
) as critical_count,
  sum(
    case when lower(severity) = 'high' then 1 else 0 end
) as high_count,
sum(
    case when ack_by is null then 1 else 0 end
) as unacked_count,
  count(alert_id)/count(distinct status) as avg_per_status
  from
    alert_events
    group by svc_name) as c
    order by total_alerts desc,svc_name asc
