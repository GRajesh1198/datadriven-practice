##

e = spark.read.table("experiments")
p = when(col("outcome") > 0,lit("1")).otherwise(lit("0"))
n = when(col("outcome") < 0,lit("1")).otherwise(lit("0"))
r = (
    e
    .groupBy("exp_name")
    .agg(
        sum(p).alias("positive_count"),
        sum(n).alias("non_positive_count"),
        avg("outcome").alias("avg_outcome")
      )
  )
