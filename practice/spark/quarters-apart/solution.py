current_year = 2026
first_year = current_year - 3

# One row per quarter, whether or not the endpoint saw traffic
quarter_spine = spark.range(12).select(
  F.col("id").alias("ord"),
  (F.lit(first_year) + F.floor(F.col("id") / 4)).alias("yr"),
  (F.col("id") % 4 + 1).alias("qnum"),
)

orders_by_quarter = (
  api_calls
  .where(F.col("endpoint") == "/api/v1/orders")
  .withColumn("yr", F.year("call_time"))
  .where((F.col("yr") >= first_year) & (F.col("yr") < current_year))
  .withColumn("qnum", F.floor((F.month("call_time") - 1) / 3) + 1)
  .groupBy("yr", "qnum")
  .agg(F.avg("latency").alias("actual_avg"))
)

quarterly = (
  quarter_spine
  .join(orders_by_quarter, on=["yr", "qnum"], how="left")
  .select(
    "ord",
    F.concat(
      F.col("yr").cast("string"), F.lit("-Q"), F.col("qnum").cast("string")
    ).alias("quarter"),
    F.coalesce(F.col("actual_avg"), F.lit(120.0)).alias("avg_latency"),
  )
)

by_quarter = Window.orderBy("ord")
prev_avg = F.lag("avg_latency").over(by_quarter)

result = (
  quarterly
  .orderBy("ord")
  .select(
    "quarter",
    "avg_latency",
    prev_avg.alias("prev_avg_latency"),
    (F.col("avg_latency") - prev_avg).alias("qoq_change"),
  )
)
