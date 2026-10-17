select * from (select
    u.user_id,
    count(distinct category) as category_count
  from transactions t
  join products p on t.product_id = p.product_id
  join users u on t.user_id = u.user_id
  where t.total_amount <= 500
  group by u.user_id) as c
  where category_count > 1
  order by category_count desc,user_id desc
