# A script for launching a Shiny application to inspect the topic models

# requirements
library(stminsights)

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

out <- readRDS('inputs/processed/dfm.RDS')
models <- readRDS('outputs/manytopics.RDS')

model_25 <- models$out[[4]]
model_35 <- models$out[[6]]

prep_25 <- estimateEffect(1:25 ~ Source, model_25, meta = out$meta)
prep_35 <- estimateEffect(1:35 ~ Source, model_35, meta = out$meta)

rm(models, configs, training_plan)

save.image('outputs/stminsights_prep.RData')
