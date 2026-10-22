## ci_builds
result = (
  ci_builds
    .withColumn("year",F.year("built_at"))
    .filter(expr("year = 2026 and status in ('success','failed','canceled')"))
    .withColumn("dayofweek",dayofweek(col("built_at")))
    .withColumn("day",date_format(col("built_at"),'E'))
    .withColumn("week_start",date_sub(col("built_at"),col('dayofweek') - 1))
    .groupBy('week_start')
    .agg(
      count(when(expr("status = 'success'"),1)).alias("success_count"),
      count(when(expr("status = 'failed'"),1)).alias("failed_count"),
      count(when(expr("status = 'canceled'"),1)).alias("canceled_count")
      )
)
