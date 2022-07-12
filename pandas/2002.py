# Import your libraries
import pandas as pd

# Start writing code
df = loans

# Show only relevant columns
df = df[["user_id", "type"]]

# Split dataframe into users who applied for "Refinance" & "InSchool" separately
df1 = df[df["type"]=="Refinance"]
df2 = df[df["type"]== "InSchool"]

# Use .merge() to combine two dataframes together & use "inner" keyword to indicate an inner join 
df_m = df1.merge(df2, how="inner", on="user_id")

# Remove duplicate and show output
df_m["user_id"].unique()
