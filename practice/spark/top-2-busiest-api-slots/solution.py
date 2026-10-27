api_calls = spark.read.table("api_calls")

result = (
  api_calls
  .filter(col("err_msg").isNotNull())
  .withColumn("hour", hour("call_time"))
  .withColumn("time_segment", # Also fixed typo "segement"
    F.when(col("hour") < 12, lit("Morning"))
     .when((col("hour") >= 12) & (col("hour") <= 15), lit("Early Afternoon"))
     .otherwise(lit("Late Afternoon"))
    )
  .groupBy("status","time_segment")
  .agg(count("call_id").alias("call_count"))
  .withColumn("rank",dense_rank().over(Window.orderBy(col("call_count").desc())))
  .filter(col("rank") <= 3)
  .select("status","time_segment","call_count")
  )
