# Import your libraries
import pandas as pd

# Start writing code
df = google_gmail_emails

# Group users & get total emails
df = df.groupby(by="from_user").agg({"id":"count"}).reset_index()

# Rename columns
df = df.rename(columns={"id":"total_emails_sent"})

# Order by total emails sent
df = df.sort_values(by=["total_emails_sent", "from_user"], ascending=[False, True])

# Create activity rank column to rank users
df["activity_rank"] = df["total_emails_sent"].rank(method="first", ascending=False)

# Show output
df
