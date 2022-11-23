# A script for cobbling together .csv files of posts 
# extracted from the Stack Exchange Data Dumpy

# requirements
import pandas as pd
import glob 
import os


# load files
colnames = ['Id','Title','Body','ViewCount','Score','Tags','CreationDate']

# make sure we are in the right directory (will need to update for remote use)
os.chdir('//home/gberman/ExtraDrive/Research outputs/Thesis/Chapter on topic modelling and Stack Exchange/Data exported from StackExchange/Literate programming posts')

path = os.getcwd()
# will need to update path for remote use
all_files = glob.glob(os.path.join(path, "*.csv"))

li = []

print("Loading .csv files for literate programming corpus.")

for filename in all_files:
    df = pd.read_csv(filename, index_col=None, header=0)
    df.insert(0, 'Source', filename[155:157])
    # note: the character numbers will need to change when the file path changes
    li.append(df)

frame = pd.concat(li, axis=0, ignore_index=True)

print("Saving combined .csv file.")
frame.to_csv('Literate_programming_posts.csv', index=False)

# make sure we are in the right directory (will need to update for remote use)
os.chdir('//home/gberman/ExtraDrive/Research outputs/Thesis/Chapter on topic modelling and Stack Exchange/Data exported from StackExchange/Machine learning posts')

path = os.getcwd()
# will need to update path for remote use
all_files = glob.glob(os.path.join(path, "*.csv"))

li = []

print("Loading .csv files for machine learning corpus.")

for filename in all_files:
    df = pd.read_csv(filename, index_col=None, header=0)
    df.insert(0, 'Source', filename[151:153])
    # note: the character numbers will need to change when the file path changes
    li.append(df)

frame = pd.concat(li, axis=0, ignore_index=True)

print("Saving combined .csv file.")
frame.to_csv('Machine_learning_posts.csv', index=False)

print("csv_fixing.py finished.")