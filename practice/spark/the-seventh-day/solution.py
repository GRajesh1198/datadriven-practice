### each monthly signup
## signup_date & verified
## page_views , viewed_at after a week 

u = spark.read.table("users")
p = spark.read.table("page_views")

veri = u.filter(col("account_status") != "pending_verification")
jc = (p["user_id"] == veri["user_id"])
agg = when(col("viewed_at") >= date_add(col("signup_date"),7),
  col("user_id"))
pct = (col("retained_users")/col("total_signups")) * 100
came_back = (
    veri.alias("v")
    .join(p,"user_id","left")
    .withColumn("cohort_month",date_format(col("signup_date"),"yyyy-MM"))
    .groupBy("cohort_month")
    .agg(countDistinct("v.user_id").alias('total_signups'),countDistinct(agg).alias("retained_users"))
    .withColumn("retention_pct",round(pct,1))
  )
