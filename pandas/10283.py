# Import your libraries
import pandas as pd

# Start writing code
df = billboard_top_100_year_end

# Filter out songs to only show those that ranked #1
df = df[df["year_rank"]==1]

# Use drop.duplicates( ) to remove duplicates
df = df.drop_duplicates(subset=["year","song_name"], keep="last")

# Display only relevant columns & show output
df[["year", "song_name"]]
