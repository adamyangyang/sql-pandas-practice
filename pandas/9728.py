# Import your libraries
import pandas as pd

# Put table into dataframe
df = sf_restaurant_health_violations

# Extract year from date column
df["inspection_date"] = df["inspection_date"].dt.year

# Show records for Roxanne Cafe.
# Group by inspection_date & count total violations by year.
# Lastly, order results by year in ascending order.
df[df["business_name"]=="Roxanne Cafe"].groupby(by="inspection_date").agg({"violation_id":"count"}).reset_index().sort_values(by="inspection_date")