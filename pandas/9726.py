# Import your libraries
import pandas as pd

# Put tables into dataframe
df = sf_restaurant_health_violations

# Create a list of words for cafe category
cafe_list = ["cafe", "café", "coffee"]

# Start classifying business
df["business_type"] = df["business_name"].str.lower().apply(lambda x: "Cafe" if any(word in x for word in cafe_list) else ("School" if "school" in x else ("Restaurant" if "restaurant" in x else "Other")))

# Drop duplicates & display results 
df[["business_name", "business_type"]].drop_duplicates()