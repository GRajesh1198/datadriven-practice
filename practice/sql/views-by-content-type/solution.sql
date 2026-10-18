content_items = spark.read.table("content_items")
content_views = spark.read.table("content_views")

result = (
  content_items
  .join(content_views,"content_id","inner")
  .groupBy("content_type")
  .agg(
    count("view_id").alias("view_count")
    )
  )
