-- load_testing
-- user_events (topic)
-- stream_msgs

SELECT *
FROM stream_msgs
WHERE topic = 'user-events'

UNION ALL

SELECT *
FROM stream_msgs
WHERE topic = 'user-events'

ORDER BY msg_id;
