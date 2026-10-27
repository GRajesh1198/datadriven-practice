impressions = (
  spark.table("ad_impressions")
  .where(F.col("user_id").isNotNull())
  .alias("ai")
)
purchases = spark.table("transactions").alias("t")

days_after_click = F.datediff(
  F.col("t.transaction_date"), F.to_date(F.col("ai.impression_time"))
)
bought_in_window = (
  (F.col("t.user_id") == F.col("ai.user_id"))
  & (F.col("ai.clicked") == 1)
  & days_after_click.between(0, 7)
)

clicked_impression = F.when(F.col("ai.clicked") == 1, F.col("ai.impression_id"))
clicked_user = F.when(F.col("ai.clicked") == 1, F.col("ai.user_id"))
converted_user = F.when(F.col("t.transaction_id").isNotNull(), F.col("ai.user_id"))

unclicked = F.sum(F.when(F.col("ai.clicked") == 0, 1).otherwise(0))
clicks = F.countDistinct(clicked_impression)
impression_count = unclicked + clicks
conversions = F.countDistinct(converted_user)
clickers = F.countDistinct(clicked_user)

result = (
  impressions.join(purchases, bought_in_window, "left")
  .groupBy(F.col("ai.ad_campaign"))
  .agg(
    impression_count.alias("impressions"),
    clicks.alias("clicks"),
    F.round(clicks.cast("double") / impression_count * 100, 2).alias("ctr_pct"),
    conversions.alias("conversions"),
    F.round(
      F.when(conversions > 0, F.lit(100.0) * conversions / clickers), 2
    ).alias("conversion_rate_pct"),
  )
  .where(F.col("clicks") >= 4)
)
