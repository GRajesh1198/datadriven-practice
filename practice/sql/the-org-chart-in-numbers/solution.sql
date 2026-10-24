## get quarter
## use case tto get new columns

e = spark.read.table("employee_metrics")
c1 = when(col("fiscal_quarter") == "Q1",1).otherwise(0)
c2 = when(col("fiscal_quarter") == "Q2",1).otherwise(0)
c3 = when(col("fiscal_quarter") == "Q3",1).otherwise(0)
c4 = when(col("fiscal_quarter") == "Q4",1).otherwise(0)

r = (
    e
      .groupBy('department')
      .agg(
        sum(c1).alias("q1"),
        sum(c2).alias("q2"),
        sum(c3).alias("q3"),
        sum(c4).alias("q4")
        )
    
  )
