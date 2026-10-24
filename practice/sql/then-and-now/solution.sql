latest_first = Window.partitionBy("mdl_name").orderBy(
  F.col("train_at").desc(), F.col("model_id").desc()
)
per_model = Window.partitionBy("mdl_name")

valid = (
  ml_models
  .where(F.col("accuracy").isNotNull() & (F.col("train_at") != ""))
  .withColumn("rn", F.row_number().over(latest_first))
  .withColumn("n_versions", F.count(F.lit(1)).over(per_model))
)

agg = (
  valid
  .groupBy("mdl_name", "n_versions")
  .agg(
    F.max(F.when(F.col("rn") == 1, F.col("accuracy"))).alias("latest_accuracy"),
    F.avg("accuracy").alias("avg_lifetime_accuracy"),
    F.avg(F.when(F.col("rn") > 1, F.col("accuracy"))).alias("avg_previous_accuracy"),
  )
)

result = agg.select(
  F.col("mdl_name").alias("model_name"),
  F.round("avg_lifetime_accuracy", 2).alias("avg_lifetime_accuracy"),
  F.round("latest_accuracy", 2).alias("latest_accuracy"),
  F.when(F.col("n_versions") == 1, F.lit(0))
   .otherwise(F.round(F.col("latest_accuracy") - F.col("avg_previous_accuracy"), 2))
   .alias("difference"),
)
