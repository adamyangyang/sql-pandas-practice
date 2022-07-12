# Import your libraries
import pandas as pd

# Start writing code
df_rev = airbnb_reviews

# Get the highest review score from dataframe
max_score = df_rev["review_score"].max()

## STEP 1: Get the highest review score for each host user from each guest user
# Specify 1st condition of only getting guest user reviews using from_type = "guest"
df_guest_rev = df_rev[df_rev["from_type"]=="guest"]

# Show only relevant columns for df_guest_rev
df_guest_rev = df_guest_rev[["from_user", "to_user", "review_score"]]

# Get the highest review score assigned to each host user from each guest user
df_guest_rev = df_guest_rev[df_guest_rev["review_score"] == max_score]

# Sort from_user by ascending order
df_guest_rev = df_guest_rev.sort_values(by="from_user", ascending=True)

## STEP 2: Get the nationality of each host from STEP 1's result

# Rename to_user as host_id for joining
df_guest_rev = df_guest_rev.rename(columns={"to_user":"host_id"})

# Create dataframe for airbnb_hosts table
df_hosts = airbnb_hosts

# Remove duplicates
df_hosts = df_hosts.drop_duplicates()

# Join STEP 1 table with airbnb_hosts table
df_m = df_hosts.merge(df_guest_rev, how="inner", on="host_id")

# Show only relevant columns & sort by guest user & nationality column
df_m = df_m[["from_user", "host_id", "nationality"]].sort_values(by=["from_user", "nationality"], ascending=True)

# Remove duplicates via .drop_duplicates( ) function
# Also, ignore duplicate values in "from_user" & "nationality" column
# Plus, specify keep = "last" as an argument to keep the last occurrence host_id
df_m = df_m.drop_duplicates(subset=["from_user", "nationality"], keep="last")

# Show output by displaying relevant column
df_m = df_m[["from_user", "nationality"]]
