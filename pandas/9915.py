# Import your libraries
import pandas as pd

# Put table in dataframe
df = orders
df_c = customers

# Specify date range
df_o = df[df["order_date"].between("2019-02-01", "2019-05-01")]

# Get total order cost from each customer for each day
df_o = df_o.groupby(by=["order_date","cust_id"]).agg({"total_order_cost": "sum"}).reset_index().sort_values(by="total_order_cost", ascending=False)

# Join results back to customers table for first name
df_m = df_o.merge(df_c, how="inner", left_on="cust_id", right_on="id")

# Convert datetime to date
df_m["order_date"] = df_m["order_date"].dt.date

# Show only relevant columns
df_m[["order_date", "first_name", "total_order_cost"]].head(1)