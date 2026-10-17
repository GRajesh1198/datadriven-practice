select user_id,total_amount,transaction_date from (
select
  user_id,
  total_amount,
  transaction_date,
  row_number() over (partition by user_id order by transaction_date) as r 
  from
    transactions) as c
 where r = 2
