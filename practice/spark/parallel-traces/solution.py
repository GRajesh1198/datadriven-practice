e = spark.read.table("experiments")
r = (
    e.alias("e1")
    .join(e.alias("e2"),
      (col("e1.exp_name") ==  col("e2.exp_name")) &
      (col("e1.platform") == col("e2.platform")) & 
      (col("e1.user_id") < col("e2.user_id")) &
      (col("e1.variant") != col("e2.variant")),
      "inner"
        )
    .select(col("e1.user_id").alias("user_id1"),col("e2.user_id").alias("user_id2"))
    .distinct()
    .orderBy("user_id1","user_id2")
  )
## x1 x2 ==> exp_name & platofrm
# x1 a b 
# x2 a b

#x1 a b x2 a b
#x1 a b x2 a b
# x2  a b x1 a b
# x2 a b x2 a ab
