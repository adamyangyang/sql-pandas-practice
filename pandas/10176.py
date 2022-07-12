# Import your libraries
import pandas as pd

# Start writing code

# Assign df as variable name to table
df = dc_bikeshare_q1_2012

# Get only the required columns
df = df[["bike_number", "end_time"]]

# Use groupby function to group by bike number
df = df.groupby(by=["bike_number"])

# Use agg( ) function to get the latest end_time for each bike
df = df.agg({"end_time": "max"})

# Use sort_values( ) to sort by end_time in descending order with the 'False' keyword in ascending argument
df = df.sort_values(by="end_time", ascending=False)

# Use reset_index( ) to show bike_number
df = df.reset_index()

# Show output
df
