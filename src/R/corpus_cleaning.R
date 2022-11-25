# This script takes the code_extract.csv file and performs pre-processing.
# The script expects to take as input a .csv file with the following
# columns: Id Title	Body ViewCount Score Tags CreationDate Text 
# CodeSnippets TextNoCode CreationYear

# Requirements
library(yaml)
library(stm)

working_directory <- Sys.getenv("working_path")

# make sure we are in the right directory
setwd(working_directory)

# Load the .yml files
configs <- read_yaml('configuration/corpus_config.yml')

project_path <- paste('projects', configs$project_details$name, sep="/")

# Load the .csv file
df <- read.csv(paste(project_path, 'inputs/intermediate/code_extracted.csv', sep="/"))

# decide whether to do stemming
if (configs$`document-term_matrix_options`$stemming == 1){
  stem = TRUE
} else {stem = FALSE}

# prepare dfm
processed <- textProcessor(df$TextNoCode, 
                           metadata = df,
                           removestopwords = TRUE,
                           removepunctuation = TRUE,
                           removenumbers = FALSE,
                           stem = stem,
                           onlycharacter = TRUE
                           )

# remove infrequent words
out <- prepDocuments(processed$documents, 
                     processed$vocab,
                     processed$meta,
                     lower.thresh = configs$`document-term_matrix_options`$min_term_frequency,
                     upper.thresh = (configs$`document-term_matrix_options`$max_doc_frquency*length(processed$documents))
                     )

# save the prepared corpus
saveRDS(out, paste(project_path, 'inputs/processed/dfm.RDS', sep="/"))

# clean up
rm(configs, df, project_path, out, processed, stem)

