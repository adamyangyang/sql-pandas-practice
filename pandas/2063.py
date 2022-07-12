# Import your libraries
import pandas as pd

# Start writing code
df = sf_exchange_rate

# Split dataframes by Jan & Jul
df_jan = df[df["date"]=="2020-01-01"]
df_jul = df[df["date"]=="2020-07-01"]

# Do inner join on both columns
df_m = df_jan.merge(df_jul, how="inner", on=["source_currency", "target_currency"])

# Create new column to show the difference in exchange rate value
df_m["value_diff"] = df_m["exchange_rate_y"] - df_m["exchange_rate_x"]

# Show output by only displaying relevant columns
df_m[["source_currency", "value_diff"]]
