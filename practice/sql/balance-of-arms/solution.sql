e = spark.table("experiments")
w = window.partitionBy("exp_name","user_id").orderBy("created")
c1 = (
    e
    .groupBy("exp_name")
    .agg(
       countDistinct(when(col("variant") == 'control',col("user_id"))).alias("control_users"),
       countDistinct(when(col("variant") == 'holdout',col("user_id"))).alias("holdout_users"),
       countDistinct(when(col("variant") != 'control',col("user_id"))).alias("treatment_users")
      )
  )
ratio = col("treatment_users")/col("control_users")
col = when(col("control_users") != col("holdout_users"),round(ratio,3))
r = (
    c1
    .withColumn("treatment_to_control_ratio",col)
    .select("exp_name","control_users","treatment_users","treatment_to_control_ratio")
  )

## exp_name, user_id , variant
