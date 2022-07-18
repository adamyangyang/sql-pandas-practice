# Import your libraries
import pandas as pd

# Insert table into dataframe
df = facebook_friends

# Get all users in a single column
# Create another dataframe that mirrors the existing one, but switch the column names (user1 -> user2 and user2 -> user1) so we can append them.
df2 = df.rename(columns={"user1":"user2", "user2":"user1"})

# Combine two dataframes into one.
df3 = pd.concat([df,df2])

# Drop duplicates
df3 = df3["user1"].drop_duplicates().sort_values().rename("user_id")

# Merge dataframe back to df & df2
df = df.merge(df3, how="right", left_on="user1", right_on="user_id")
df2 = df2.merge(df3, how="right", left_on="user1", right_on="user_id")

# Get total number of friends for each user
df = df.groupby(by="user_id").agg({"user1":"count"}).reset_index().rename(columns={"user1":"total_friends"})
df2 = df2.groupby(by="user_id").agg({"user1":"count"}).reset_index().rename(columns={"user1":"total_friends"})

# Use pd.concat to merge 2 dataframes back again
df3 = pd.concat([df,df2]).groupby(by="user_id").agg({"total_friends":"sum"}).reset_index()

# Get popularity percentage from each user
df3["pop_pct"] = (df3["total_friends"]/(df["user_id"].count()))*100

# Display output with relevant columns
df3[["user_id","pop_pct"]]