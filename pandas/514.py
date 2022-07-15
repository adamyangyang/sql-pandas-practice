# Import your libraries
import pandas as pd

# Put table into dataframe
df = marketing_campaign

# Create temporary dataframe to sort records by user_id and date in ascending order
df_date_sorted = df.sort_values(by=["user_id","created_at"], ascending=True) 

#df_twofive = df_date_sorted[df_date_sorted["user_id"]==25]

# Then, feature engineer campaign_date_flag column to indicate whether the date is before (1) or after (2 and above) each user's marketing campaign starts.
# Done through grouping user_id & created_at, and using rank( ) with "dense" kwarg. 
df_date_sorted["campaign_date_flag"] = df_date_sorted.groupby(by=["user_id"])["created_at"].rank(method="dense")

# Create a 2nd column (num_of_times_bought) to flag whether the product bought is a new purchase (1) or old (2 and above).
df_date_sorted["num_of_times_bought"] = df_date_sorted.groupby(by=["user_id", "product_id"])["created_at"].rank(method="dense")

# Show only relevant columns
df_users = df_date_sorted[["user_id", "created_at", "product_id", "campaign_date_flag", "num_of_times_bought"]]

# Filter out users based on requirements
# Requirement 1: Users who continued purchasing 1 day after their initial purchase
# Requirement 2: Users who bought other products besides the one they've initially bought before their marketing campaign started.
df_repeat_users = df_users[(df_users["campaign_date_flag"]>1) & (df_users["num_of_times_bought"]==1)]

# Count total number of users
df_repeat_users["user_id"].nunique()
