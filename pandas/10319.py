# Import your libraries
import pandas as pd

# Put table into dataframe
df = sf_transactions

# Rename revenue column
df = df.rename(columns={"value": "revenue"})

# Create year_mo column 
df["yr_mo"] = df["created_at"].dt.strftime("%Y-%m")

# Get each month's total revenue & 
df = df.groupby(by="yr_mo").agg({"revenue": "sum"})

# Get previous month's revenue
df["prev_mo_rev"] = df["revenue"].shift(1)

# Reset index to show yr_mo column
df = df.reset_index()

# Get revenue percent change for each month
df["pct_change"] = ((df["revenue"] - df["prev_mo_rev"])/df["prev_mo_rev"])*100

# Round percent change to 2 decimal points
df["pct_change"] = df["pct_change"].round(2)

# Show only relevant columns & sort by date
df[["yr_mo", "pct_change"]].sort_values(by="yr_mo", ascending = True)
