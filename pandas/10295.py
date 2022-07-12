# Import your libraries
import pandas as pd

# Start writing code
df = fb_messages

# Get all username from the table by removing duplicates 
df_senders = df[["user1", "msg_count"]]
df_receivers = df[["user2", "msg_count"]]

# Group by users
df_senders = df_senders.groupby(by="user1").agg({"msg_count":"sum"}).reset_index() 
df_receivers = df_receivers.groupby(by="user2").agg({"msg_count":"sum"}).reset_index() 

# Rename user columns & merge
df_senders = df_senders.rename(columns={"user1": "user"})
df_receivers = df_receivers.rename(columns={"user2": "user"})

# Append receiver to sender dataframe & show top 10 most active users using n.largest( ) function
df_senders.append(df_receivers).nlargest(10, "msg_count")
