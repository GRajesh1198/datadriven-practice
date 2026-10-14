with cte as (select 
  category,
  product_name,
  rating,
  row_number() over (partition by category order by rating asc,price desc) as ranking
  from
products
where rating is not null), cte2 as (
  select category,product_name,rating as floor_rating
  from cte 
  -- group by category,product_name
  where ranking = 1 
  order by rating desc
)
select * from cte2 limit 3;
