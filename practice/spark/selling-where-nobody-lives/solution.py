orders = spark.read.table("orders")
marquee_orders = (
  orders
  .filter(col("profit") > 1200)
  .select("order_id")
  )

result = (
  orders
  .filter(col("status").isin("Shipped","Completed"))
  .filter(col("region").isNotNull())
  .join(marquee_orders,"order_id","left_semi")
  .select("region")
  .distinct()
  )
