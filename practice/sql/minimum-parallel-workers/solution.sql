j = spark.table("batch_jobs")
c = j.select("job_id","started","ended").dropDuplicates().filter(col("ended").isNotNull())

starts = c.select(
  F.col("started").alias("event_time"),
  F.lit(1).alias("delta"),
  F.lit(0).alias("priority") 
)
ends = c.select(
  F.col("ended").alias("event_time"),
  F.lit(-1).alias("delta"),
  F.lit(1).alias("priority")
)
timeline = starts.union(ends)
w = Window.orderBy(F.col("event_time").asc(), F.col("priority").asc())
running_totals = timeline.withColumn("active_workers", F.sum("delta").over(w))

smallest_pool = running_totals.select(F.max("active_workers").alias("min_workers"))
