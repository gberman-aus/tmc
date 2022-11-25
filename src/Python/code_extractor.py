# This script uses the corpus_config.yml to go through the .csv file
# of Stack Exchange posts and combine the text data into one column, and 
# then isolate code snippets. The script also polishes the CreationDate 
# column.

# Requirements:
import yaml
import os
import sys
import re
import pandas as pd
from bs4 import BeautifulSoup
import numpy as np

working_path = os.getenv("working_path")

# make sure we are in the right directory
os.chdir(working_path)

# load the configuration file
with open("configuration/corpus_config.yml") as config_settings:
    configs = yaml.load(config_settings, Loader=yaml.FullLoader)

print("Configuration file loaded.")

project_dir = configs['project_details']['name']
project_path = os.path.join('projects', project_dir)

# Load the .csv file
file_path = configs['corpus_details']['url']
df = pd.read_csv(file_path, index_col=None)
print("Corpus .csv file loaded.")

if configs['corpus_details']['local_copy'] == 1:
    save_path = os.path.join(project_path, 'inputs/raw/dataset.csv')
    df.to_csv(save_path, index=False)
    print("Local copy of .csv file saved.")

# Check for duplicates in the data frame
init_rows = df.shape[0]
new_df = df.drop_duplicates()
remaining_rows = new_df.shape[0]

print("Initial number of posts in the corpus: ", init_rows)
print("Number of duplicates found: ", (init_rows - remaining_rows))
print("Number of unique posts in the corpus: ", remaining_rows)

# Create new columns
column_labels = configs['corpus_format']['col_names']
new_df = new_df.reindex(columns=column_labels, fill_value='')

save_path = os.path.join(project_path, 'inputs/intermediate/deduplicated.csv')
new_df.to_csv(save_path, index=False)
print("Saved deduplicated corpus.")

# For columns that the config file identifies as containing text, 
# make text lowercase, and remove code snippets.
text_cols = configs['corpus_format']['text_columns']
new_df['Text'] = new_df[text_cols].agg(' '.join, axis=1)
new_df['Text'] = new_df['Text'].str.casefold()

new_df['CodeSnippets'] = ''
new_df['TextNoCode'] = ''

def extract_code(post):
    soup = BeautifulSoup(post, 'html.parser')
    soup.find_all('code')
    if soup.code is not None:
        soup = soup.code.extract()
        return str(soup)
    return ''

def remove_code(post):
    soup = BeautifulSoup(post, 'html.parser')
    soup.find_all('code')
    if soup.code is not None:
        soup.code.decompose()
    return str(soup)

print("Extracting code snippets. This may take some time.")
new_df['CodeSnippets'] =  new_df['Text'].apply(np.vectorize(extract_code))
new_df['TextNoCode'] =  new_df['Text'].apply(np.vectorize(remove_code))
print("Code snippets extracted.")

# Do basic cleaning

print("Fixing ascii characters and removing html tags.")

# In TextNoCode column, remove html tags
new_df['TextNoCode'] = new_df['TextNoCode'].apply(lambda x: re.sub('<[^<]+?>', '', x))

# In TextNoCode and CodeSnippets column, fix ASCII characters
new_df['TextNoCode'] = new_df['TextNoCode'].apply(lambda x: re.sub('&quot;', ' " ', x))
new_df['TextNoCode'] = new_df['TextNoCode'].apply(lambda x: re.sub('&amp;', ' & ', x))
new_df['TextNoCode'] = new_df['TextNoCode'].apply(lambda x: re.sub('&lt;', ' < ', x))
new_df['TextNoCode'] = new_df['TextNoCode'].apply(lambda x: re.sub('&gt;', ' > ', x))
new_df['TextNoCode'] = new_df['TextNoCode'].apply(lambda x: re.sub('&lt;', ' < ', x))

new_df['CodeSnippets'] = new_df['CodeSnippets'].apply(lambda x: re.sub('&quot;', ' " ', x))
new_df['CodeSnippets'] = new_df['CodeSnippets'].apply(lambda x: re.sub('&amp;', ' & ', x))
new_df['CodeSnippets'] = new_df['CodeSnippets'].apply(lambda x: re.sub('&lt;', ' < ', x))
new_df['CodeSnippets'] = new_df['CodeSnippets'].apply(lambda x: re.sub('&gt;', ' > ', x))
new_df['CodeSnippets'] = new_df['CodeSnippets'].apply(lambda x: re.sub('&lt;', ' < ', x))

# In CreationDate column drop time.
print("Fixing CreationDate.")
new_df['CreationYear'] = new_df['CreationDate'].str[:10]

# Save the preprocessed Questions
save_path = os.path.join(project_path, 'inputs/intermediate/code_extracted.csv')
new_df.to_csv(save_path, index=False)
print("Saved deduplicated, code extracted corpus.")
print("code_extractor.py finished run.")

# In R will do the rest of the cleaning and pre-processing.
