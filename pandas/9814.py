# Import your libraries
import pandas as pd

# Put table into dataframe
df = google_file_store

# Count the number of word occurrences for 'bull' & 'bear'
bull_wc = df["contents"].str.count("bull").sum()
bear_wc = df["contents"].str.count("bear").sum()

# Create a dictionary to store the number of word counts for each word
word_dict = {'word':["bull", "bear"], "word_counts":[bull_wc, bear_wc]}

# Show output
output = pd.DataFrame(word_dict, columns=["word", "word_counts"])
