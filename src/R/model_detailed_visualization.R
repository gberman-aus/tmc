# An R Script for visualising selected topic model

library(stm)
library(yaml)
library(ggplot2)
library(igraph)
library(ggrepel)


working_directory <- Sys.getenv("working_path")

# make sure we are in the right directory
#setwd(working_directory)
setwd("~/ExtraDrive/Research outputs/Topic modelling/StackExchangeNoStem")

# Load the .yml files
#configs <- read_yaml('configuration/corpus_config.yml')
#training_plan <- read_yaml('configuration/training_config.yml')
configs <- read_yaml('corpus_config.yml')
training_plan <- read_yaml('training_config.yml')

#project_path <- paste('projects', configs$project_details$name, sep="/")
project_path <- "~/ExtraDrive/Research outputs/Topic modelling/StackExchangeNoStem"
visualizations_path <- paste(project_path, 'outputs/visualizations/', sep="/")

# Load the compbined RDS file of the trained models
models <- readRDS(paste(project_path, "outputs/models/combined_models.RDS", sep="/"))

out <- readRDS('inputs/processed/dfm.RDS')
models <- readRDS('outputs/manytopics.RDS')

model_25 <- models$out[[5]]
model_35 <- models$out[[7]]

# Does the source or creation date of a question affect model

# First need to simplify the CreationYear meta
out$meta$CreationYearNumeric <- as.numeric(as.Date(out$meta$CreationYear))

prep_25 <- estimateEffect(1:3 ~ Source + CreationYearNumeric, model_25, meta = out$meta)
prep_35 <- estimateEffect(1:35 ~ Source, model_35, meta = out$meta)

plot(prep_25, "CreationYearNumeric", model=model_25, method="continuous")
plot(prep_25, "Source", model=model_25, method="pointestimate")

# Find most representative documents for each topic
thoughts_25 <- findThoughts(model_25, text = out$meta$Title, topics = 1, n = 1, thresh = 0.4)
