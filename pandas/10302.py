# Import your libraries
import pandas as pd

# Start writing code
df = uber_request_logs

# Get distance-per-dollar for daily rides
df["distance_per_dollar"] = df["distance_to_travel"] / df["monetary_cost"]

# Get year_month column for each date
df["yr_mo"] = df["request_date"].dt.strftime("%Y-%m")

# Get average distance-per-dollar for each month
df_avg = df.groupby(by="yr_mo").agg({"distance_per_dollar":"mean"}).reset_index()

# Rename column
df_avg = df_avg.rename(columns={"distance_per_dollar":"avg_distance_per_dollar"})

# Merge dataset
df_m = df.merge(df_avg, how="inner", on="yr_mo")

# Get absolute average difference
df_m["abs_value_diff"] = df_m["distance_per_dollar"] - df_m["avg_distance_per_dollar"]

# Use ABS( ) to remove negative values & round to 2 decimal points
df_m["abs_value_diff"] = df_m["abs_value_diff"].abs().round(2)

# Sort result by earliest request date
df_m = df_m.sort_values(by="request_date", ascending=True)

# Display output by showing relevant columns & dropping duplicates
df_m[["yr_mo", "abs_value_diff"]].drop_duplicates()
