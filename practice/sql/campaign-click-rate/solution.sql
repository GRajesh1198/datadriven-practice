a = spark.read.table('ad_impressions')
p = spark.read.table("page_views")
c = when(col("clicked") == 1, lit("1")).otherwise(0)
t = col("impression_id")
per = (round(col("total_clicks")/col("total_impressions"),4))*100
r = (
  p
    .join(a,"user_id","inner")
    .groupBy("ad_campaign")
    .agg(
      sum(c).alias("total_clicks"),
      count(t).alias("total_impressions")
      )
    .withColumn("clicked_pct",per)
    .select("ad_campaign","clicked_pct")
    .orderBy(desc("clicked_pct"),"ad_campaign")
  )
