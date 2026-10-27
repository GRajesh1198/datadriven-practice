s = spark.read.table("search_queries")
## 1 - nothing
## 3 - clikced on top 3 results
## 2 -  when clicked after 4
r = when(col("clicked_result") <= 3,lit("3")).when(col("clicked_result") > 3,lit("2")).otherwise(None)

op = (
    s
    .withColumn("rating",r)
    .select("query_id","rating")
  )
