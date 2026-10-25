# clicks
# converter 
# coverter is a unqiue user who clicked one of the comapign;s adds and transaction date impression date and 7 days after

a = spark.table("ad_impressions")
t = spark.table("transactions")
agg = col("impression_id")
clicks = when(col("clicked") == 1,1).otherwise(0)
unique_clickers = when(col("transaction_id").isNotNull(),col(t["user_id"]))
de = when((a["clicked"] == 1) & (t["transaction_id"].isNotNull()),col(t["user_id"]))
pct = round((col("clicks")/col("impressions")) * 100,2)
pct1 = (col("conversions")/col("total")) * 100
r = (
    a
    .join(t, (a["user_id"] == t["user_id"])
      & (
        to_date(col("transaction_date")).between(to_date(col("impression_time")),date_add(to_date(col("impression_time")),7))
        ) 
      &
      (a["clicked"] == 1)
      ,"left")
     .filter(a["user_id"].isNotNull())
     .groupBy('ad_campaign')
     .agg(
       count(agg).alias("impressions"),sum(clicks).alias("clicks"),
       countDistinct(unique_clickers).alias("conversions"),
       countDistinct(de).alias("total")
       )
     .withColumn("ctr_pct",pct)
     .withColumn("conversion_rate_pct",pct1)
     .filter(col("clicks") >= 4)
     .select("ad_campaign","impressions","clicks","ctr_pct","conversions","conversion_rate_pct")
  )

# .groupBy("ad_campaign")
  # .agg(sum(a1).alias("total_clicks"),count(a2).alias("impressions"))

## this left join wll give me all users,who clicked but did not have a transaction will be null
## 4 clicks per ad_campaign
# Your unique_clickers only captures users who matched a transaction, so you have no denominator for the conversion rate. Add a separate countDistinct wrapped in a when on a["clicked"] == 1 that counts a["user_id"] for the campaign's unique clickers. Keep the converter count in its own countDistinct gated on t["transaction_id"].isNotNull(), and alias each o
