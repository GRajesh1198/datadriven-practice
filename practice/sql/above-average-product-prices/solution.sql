 -- bp = lowest trx amount 
 -- select product_id, min(total_amount) as base_price 
 -- from transactions
 -- group by product_id
 -- having min(total_amount) >
 -- (select avg(min_price) from (select min(total_amount) as min_price from transactions group by product_id))
 
 
-- Derived Threshold Filter -> product_id group should have min(amount)

with product_mins AS (
select product_id,min(total_amount) as min_price
from transactions
group by product_id
)

select * from product_mins
where min_price > (select avg(min_price) from product_mins)
