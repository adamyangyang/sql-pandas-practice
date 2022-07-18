# Import your libraries
import pandas as pd

# Put table in dataframe
df = airbnb_host_searches

# Sort values by hosts_since
df = df.sort_values(by="host_since",ascending=True)

# Group together hosts based on the conditions & get the number of reviews for each host
df = df.groupby(by=["price","room_type","host_since","zipcode","number_of_reviews"]).agg({"number_of_reviews": "sum"})

# Rename number_of_reviews column to a separate name so we can use .reset_index( ) twice to get a unique host_id column
df = df.rename(columns={"number_of_reviews":"num_of_reviews"}).reset_index().reset_index()

# Rename index column to host_id
df = df.rename(columns={"index":"host_id"})

# Assign popularity rating
df["pop_rating"] = df["number_of_reviews"].apply(lambda x: "Hot" if x > 40 else ("Popular" if x >= 16 else ("Trending Up" if x >= 6 else ("Rising" if x >= 1 else "New"))))

# Create separte price columns
df["min_price"] = df["price"]
df["max_price"] = df["price"]

# Get min, max & avg price of each popularity rating
df = df.groupby(by="pop_rating").agg({"min_price": "min", "max_price": "max", "price": "mean"}).reset_index()

# Rename Columns
df.rename(columns={"price": "avg_price"})