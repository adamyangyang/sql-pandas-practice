# Import your libraries
import pandas as pd

# Start writing code
df = facebook_reactions

# Show only posts with heart reactions
df1 = df[df["reaction"]=="heart"]

# Get only relevant columns
df1 = df1["post_id"]

# Join to facebook_posts table to find which post is that
df_posts = facebook_posts
df_m = df_posts.merge(df1, how="inner", on="post_id")

# Drop duplicates & show output
df_m.drop_duplicates()
