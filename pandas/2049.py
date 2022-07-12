# Import your libraries
import pandas as pd

# Start writing code
df = uber_orders

# Show only relevant columns
df = df[["service_name", "status_of_order", "number_of_orders"]]

# Group by service_name & status of order 
df_g = df.groupby(by=["service_name", "status_of_order"])

# Add up number of orders for each service name & status of order
df_g = df_g.agg({"number_of_orders": "sum"})

# Reset index & sort by service name (ascending) and number of orders (descending)
df_g = df_g.reset_index().sort_values(by=["service_name", "number_of_orders"],
                                        ascending=[True, False])
                                        
# Show output
df_g
