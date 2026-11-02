## featherweight == using the least memory

w = Window.partitionBy("nspace").orderBy("mem_used","pod_name")

p = spark.read.table("k8s_pods")

r = (
    p
    .filter(col("mem_used").isNotNull())
    .groupBy("nspace","pod_name")
    .agg(min("mem_used").alias("mem_used"))
    .withColumn("rnk",dense_rank().over(w))
    .filter(col("rnk") == 1)
    .drop("rnk")
  )
