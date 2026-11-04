sessions = user_sessions.withColumn("session_date", F.to_date("session_start"))

first_sessions = (
  sessions
  .groupBy("user_id")
  .agg(F.min("session_date").alias("first_date"))
)

return_sessions = sessions.alias("us").join(
  first_sessions.alias("fs"),
  on=[
    F.col("us.user_id") == F.col("fs.user_id"),
    F.col("us.session_date") > F.col("fs.first_date"),
    F.col("us.session_date") <= F.date_add(F.col("fs.first_date"), 90),
  ],
  how="inner",
)

retained_users = (
  return_sessions
  .select(F.col("fs.user_id").alias("retained_id"))
  .distinct()
)

all_users = sessions.select("user_id").distinct()

result = (
  all_users
  .join(retained_users, all_users.user_id == retained_users.retained_id, "left")
  .agg(
    (F.countDistinct("retained_id").cast("double")
     / F.countDistinct("user_id")).alias("retention_rate")
  )
)
