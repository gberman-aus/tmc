# another small python script, this time to cross check the
# machine learning and literate programming datasets of posts
# and find the posts that are about both topics.

# requirements
import pandas as pd
import csv
import os

# make sure we are in the right directory (will need to update for remote use)
os.chdir('//home/gberman/ExtraDrive/Research outputs/Thesis/Chapter on topic modelling and Stack Exchange/Data exported from StackExchange')

path = os.getcwd()
# will need to update path for remote use

# load the first data frame
print("Loading the literate programming dataset.")
df_literate_programming = pd.read_csv('Literate_programming_posts.csv')

# set the relevant terms to search for
literate_programming_terms = "jupyter notebook, jupyter, ipython, google colaboratory, pyspark, ipywidgets, jupyter lab, jupyterhub, ipython notebook, colab".replace(", ", "|")
machine_learning_terms = "artificial intelligence, machine learning, deep learning, neural network, nlp, computer vision, tensorflow, keras, scikit learn, opencv, image processing, pytorch, conv neural network, classification, nltk, svm, spacy, stanford nlp, lstm, caffe, regression, random forest, propagation, neural networks, predictive models, feature selection, optimization, predictive modeling, cnn, machine learning model, convolutional neural network, natural language process, tensorflow2.0".replace(",","|")

# work through the two datasets
df_literate_programming_1 = df_literate_programming[(df_literate_programming[('Title')].str.casefold().str.contains(machine_learning_terms, na=False))]
df_literate_programming_2 = df_literate_programming[(df_literate_programming[('Body')].str.casefold().str.contains(machine_learning_terms, na=False))]
df_literate_programming_subset = pd.concat([df_literate_programming_1, df_literate_programming_2])

print("Literate programming dataset reduced from ", len(df_literate_programming), "to ", len(df_literate_programming_subset))

df_literate_programming_subset.to_csv('Literate_programming_posts_with_machine_learning_terms.csv', index=False)

del df_literate_programming, df_literate_programming_1, df_literate_programming_2

# load the second data frame
print("Loading the machine learning dataset.")
df_machine_learning = pd.read_csv('Machine_learning_posts.csv')

df_machine_learning_1 = df_machine_learning[(df_machine_learning[('Title')].str.casefold().str.contains(literate_programming_terms, na=False))]
df_machine_learning_2 = df_machine_learning[(df_machine_learning[('Body')].str.casefold().str.contains(literate_programming_terms, na=False))]
df_machine_learning_subset = pd.concat([df_machine_learning_1, df_machine_learning_2])

print("Machine learning dataset reduced from ", len(df_machine_learning), "to ", len(df_machine_learning_subset))

df_machine_learning_subset.to_csv('Machine_learning_posts_with_literate_programming_terms.csv', index=False)

del df_machine_learning, df_machine_learning_1, df_machine_learning_2

df = pd.concat([df_literate_programming_subset, df_machine_learning_subset])

print("Saving the final combined dataset. Note: dataset may still contain duplicates.")

df.to_csv('Literate_programming_and_machine_learning_posts.csv', index=False)

print("Final dataset contains ", len(df), " posts, not de-duplicated.")

del df, literate_programming_terms, machine_learning_terms

