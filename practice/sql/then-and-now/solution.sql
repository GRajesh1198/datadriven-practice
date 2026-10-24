## average_accuray across counted(verions)
## most recent for each model
## latest score and average of its earlier score.
## acuuracy and a trainig time are not blanks
# when tow versions share a trainiing time the higher mode_id hihger is newer one.
m = spark.read.table("ml_models")
w = Window.partitionBy("mdl_name").orderBy(
  F.col("train_at").desc(), 
  F.col("model_id").desc()
)
f = m.filter(expr("accuracy is not null and train_at is not null"))
l_acc = m.withColumn("latest",row_number().over(w)).filter(col("latest") == 1).select("mdl_name","accuracy")
avg_lifetime = (col("total_accuracy") - col("accuracy"))/(col("total_models") - 1)
avg_total = col('total_accuracy')/col("total_models")
difference= col("accuracy") - col("avg_lifetime ")
r = (
    f
    .groupBy("mdl_name")
    .agg(count("model_id").alias("total_models"),sum("accuracy").alias("total_accuracy"))
    .join(l_acc,"mdl_name","inner")
    .withColumn("avg_lifetime_accuracy",avg_total)
    .withColumn("avg_lifetime",avg_lifetime)
    .withColumn("difference",difference)
    .select(col("mdl_name").alias("model_name"),
      round(col("avg_lifetime_accuracy"),2),
      round(col("accuracy"),2).alias("latest_accuracy"),
      round(col("difference"),2)
      )
  )
