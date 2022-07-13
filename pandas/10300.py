# Import your libraries
import pandas as pd

# Put each table into its own dataframe
df_users = ms_user_dimension
df_accs = ms_acc_dimension
df_downloads = ms_download_facts

# Join 3 tables together
df_merged = df_downloads.merge(df_users.merge(df_accs, how="inner", on="acc_id"), how ="inner", on="user_id")

# Group by dates & get total paying & non-paying user downlaods
df_merged = df_merged.groupby(by=["date","paying_customer"]).agg({"downloads":"sum"}).reset_index() 

# Turn into pivot table
df_pivot = df_merged.pivot(index="date", columns="paying_customer", values="downloads").reset_index()

# Rename columns
df_pivot = df_pivot.rename(columns={"no": "non_paying_downloads", "yes": "paying_downloads"})

# Show only records where non_paying downloads are more than paying downloads
# Sort by earliest date first & display final output
df_pivot[df_pivot["non_paying_downloads"]>df_pivot["paying_downloads"]].sort_values(by="date")
