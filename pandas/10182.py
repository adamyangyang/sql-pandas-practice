# Import your libraries
import pandas as pd

# Put table into dataframe
df = sf_restaurant_health_violations

# Show only relevant columns
df = df[["business_name", "business_postal_code", "business_address"]]

# Convert business address to lowercase
df["business_address"] = df["business_address"].str.lower()


# Get the 1st set of characters from each street address businesses 
# Use lambda function to check if the first letter in each address is a number.
# If true, then split the address by " " delimiter & get only the 2nd element from the list.
# Else, get only the 1st element in the list (which is a letter).
# After that, convert the element into a string using .str[0]
df["first_name_add"] = df["business_address"].apply(lambda x: x.split(" ")[1:2] if x[0].isnumeric() else x.split(" ")[0:1]).str[0]

# Rename columns
df.rename(columns={"business_postal_code": "postal_code", "first_name_add":"total_count"}, inplace=True)

# Filter out businesses without postal codes
df = df[df["postal_code"]!=df["postal_code"].isnull()]

# Group by postal code, count total unique street name addresses & sort by total count in descending order
df.groupby(by="postal_code").agg({"total_count":"nunique"}).reset_index().sort_values(by="total_count",ascending=False)