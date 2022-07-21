# Import your libraries
import pandas as pd

# Put table into dataframe
df = amazon_transactions

# Sort data frame by user_id and created_at
df = df.sort_values(by=["user_id", "created_at"])

# Convert datetime into date for created_at column
df["created_at"] = df["created_at"].dt.date

# Get each user's next purchase date
df["next_purchase_date"] = df.groupby(by="user_id")["created_at"].shift(-1)

# Create a 7 day range to refer to 
df["seven_day_threshold"] = df["created_at"] + pd.to_timedelta(7, unit = "d")

# Filter out users who's next purchase is within 7 days of last purchase
df = df[df["next_purchase_date"]<=df["seven_day_threshold"]]

# Display output
df["user_id"].drop_duplicates()