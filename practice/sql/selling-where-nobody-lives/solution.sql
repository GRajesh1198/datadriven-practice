orders = spark.read.table("orders")\
      .withColumn("status",lower("status"))\
      .filter(expr("status in ('shipped','completed') and profit > 1200"))\
      .filter(col("region").isNotNull())\
      .select(col("region"))\
      .distinct()
