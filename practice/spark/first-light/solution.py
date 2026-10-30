## early days == before frist ci build

ci = spark.read.table("ci_builds")
re = spark.read.table("repo_commits")

jc = (
  (col("re.repo_name") == col("ci.repo_name")) & 
  (col("commit_at") < col("first_build"))
)
ci = ci.filter(col("status") == "success").groupBy("repo_name").agg(min("built_at").alias("first_build"))
r = (
      ## join condition : you need all the commits before the built_at column 
      ## you will join on repo_name 
      ## in ci builds you can have multiple builds for each repo, so lets the get the build for each repo
      re.alias("re")
      .join(ci.alias("ci"),jc,"inner")
      .groupBy("author")
      .agg(avg("added").alias("avg_lines_added"),avg("removed").alias("avg_lines_removed"))
      .orderBy(desc("avg_lines_added"))
  )
