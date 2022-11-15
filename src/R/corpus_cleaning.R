# This script takes the code_extract.csv file and performs pre-processing.
# The script expects to take as input a .csv file with the following
# columns: Id Title	Body ViewCount Score Tags CreationDate Text 
# CodeSnippets TextNoCode CreationYear

# Requirements
library(yaml)
library(quanteda)
library(readtext)

# make sure we are in the right directory
setwd('//home/gberman/github/tmc')

# Load the .yml files
configs <- read_yaml('configuration/corpus_config.yml')

project_path <- paste('projects', configs$project_details$name, sep="/")

# Load the .csv file
df <- read.csv(paste(project_path, 'inputs/intermediate/code_extracted.csv', sep="/"))
names(df)

# Convert it to a corpus
corp_df <- corpus(df, text_field = "TextNoCode")
docnames(corp_df) <- df$Id

# Add metadata
meta_data <- configs$corpus_format$data_columns

for (metas in meta_data){
  docvars(corp_df, metas) <- names(df$metas)
}

# save the corpus
saveRDS(corp_df, paste(project_path, 'inputs/intermediate/corpus.RDS', sep="/"))

# create tokens
tokens_df <- tokens(corp_df, 
                    remove_punct = TRUE, 
                    remove_numbers = FALSE, 
                    remove_symbols = TRUE, 
                    remove_url = TRUE, 
                    remove_separators = TRUE)

# remove stopwords
tokens_df <- tokens_select(tokens_df, 
                           pattern = stopwords("en"), 
                           selection = "remove")

# if stemming, do that
if (configs$`document-term_matrix_options`$stemming == 1){
  tokens_df <- tokens_wordstem(tokens_df)
  print("Stemming.")
} else {print("No stemming.")}

# if using n-grams, create the n-grams and update the tokens
if (configs$`document-term_matrix_options`$`n-grams` > 1){
  tokens_df <- tokens_ngrams(tokens_df, n = 1:(configs$`document-term_matrix_options`$`n-grams`+1))
  print("Creating n-grams.")
} else {print("No n-grams created.")}

# save the tokens
saveRDS(tokens_df, paste(project_path, 'inputs/intermediate/tokens.RDS', sep="/"))

# create document frequency matrix
dfm_df <- dfm(tokens_df)
dfm_df <- dfm_trim(dfm_df, 
                         min_termfreq = configs$`document-term_matrix_options`$min_term_frequency)
dfm_df <- dfm_trim(dfm_df, 
                         max_docfreq = configs$`document-term_matrix_options`$max_doc_frquency, docfreq_type = "prop")

if (configs$`document-term_matrix_options`$dtm_method == 2) {
  dfm_df <- dfm_tfidf(dfm_df)
  print("Using term frequency-inverse document frequency.")
} else {
  print("Using term occurence.")
}

# save the document frequency matrix
saveRDS(dfm_df, paste(project_path, 'inputs/processed/dfm.RDS', sep="/"))

# clean up
rm(configs, df, dfm_df, tokens_df , corp_df, meta_data, metas, project_path)

