## ONE THAT ENDS 10 10:30 
j = spark.read.table("batch_jobs")
w = Window.orderBy("t","d")
notEnded = when(col("ended").isNotNull(),lit("-1")).otherwise(lit("0"))
s = j.select(col("job_id"),col("started").alias("t"),lit("1").alias("d"))
e = j.select(col("job_id"),col("ended").alias("t"),notEnded.alias("d"))

t = s.union(e)
r = (
    t
    .withColumn("running",sum(col("d")).over(w))
    .agg(max("running").alias("peak"))
  )
