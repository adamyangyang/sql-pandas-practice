# Import your libraries
import pandas as pd

# Put table into dataframe
df = yelp_business

# Create separate state column
df["state_backup"] = df["state"]

# Show only 5 stars & group by state. Then count total states & reset index.
df5stars = df[df["stars"]==5].groupby(by="state").agg({"state_backup":"count"}).reset_index()

# Rename column, sort state by highes 5 star business count & show only top 5 states.
df5stars.rename(columns={"state_backup":"tot_count"}).sort_values(by="tot_count",ascending=False).head(6)