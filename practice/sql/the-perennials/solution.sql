event_data = spark.read.table("event_data")

result = (
    event_data
      .groupBy("event_type")
      .agg(countDistinct(
          date_format(col("event_timestamp"),'yyyy/MM')
        ).alias("count"))
      .filter(col("count") >= 12)
      .select("event_type")
      .orderBy("event_type")
  )
