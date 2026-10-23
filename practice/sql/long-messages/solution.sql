r = spark.read.table("repo_commits").filter(col("message").isNotNull()).withColumn("l",length(trim(col("message"))))
avgLength = r.filter(col("l") > 0).agg(avg("l").alias("avg_length"))

results = (
    r
    .select("author","message","l")
    .crossJoin(avgLength)
    .filter(col("l") > col("avg_length"))
    .select(col("author"),trim(col("message")),col("l").alias("message_length"))
    .orderBy(desc("message_length"))
  )
