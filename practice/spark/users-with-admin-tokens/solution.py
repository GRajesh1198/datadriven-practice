## 
ai = spark.table("api_tokens")
u = spark.table("users")

## 
substr = regexp_extract(col("scope"),'(admin)',1)

r = (
    ai
    .withColumn("scope",substr)
    .filter(col("scope") == "admin")
    .join(u,col("owner_id") == col("user_id"),"inner")
    .orderBy("user_id","issued")
    .select("user_id","username","email",'token_id',"scope")
  )
