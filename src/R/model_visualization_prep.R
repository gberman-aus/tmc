# An R script for stitching the outputs of ManyTopicsIterative together into exclusivity vs semantic coherence charts

# requirements
library(stm)
library(yaml)

working_directory <- Sys.getenv("working_path")

# make sure we are in the right directory
setwd(working_directory)

# Load the .yml files
configs <- read_yaml('configuration/corpus_config.yml')
training_plan <- read_yaml('configuration/training_config.yml')

project_path <- paste('projects', configs$project_details$name, sep="/")

# initiate variables
runout <- list()
semcoh <- list()
exclusivity <- list()
sparsity <- list()

# Load all the .RDS files in /project_name/outputs/models
list_models <- list.files(path = paste(project_path, "outputs/models/", sep="/"), pattern = "*.RDS")
list_exclusivity <- list.files(path = paste(project_path, "outputs/exclusivity/", sep="/"), pattern = "*.RDS")
list_semcoh <- list.files(path = paste(project_path, "outputs/semcoh/", sep="/"), pattern = "*.RDS")
list_sparsity <- list.files(path = paste(project_path, "outputs/sparsity/", sep="/", pattern = "*.RDS"))

for (i in 1:length(list_models)){
  list_models[i] <- paste(project_path, "outputs/models", list_models[i], sep="/")
  runout[[i]] <- readRDS(list_models[i])
}

if (length(list_exclusivity) > 0){
  for (i in 1:length(list_exclusivity)){
    list_exclusivity[i] <- paste(project_path, "outputs/exclusivity", list_exclusivity[i], sep="/")
    exclusivity[[i]] <- readRDS(list_exclusivity[i])
  }
} else {
  for (i in 1:length(list_models)){
    exclusivity[i] <- "Exclusivity not calculated for models with content covariates"
  }
}

for (i in 1:length(list_semcoh)){
  list_semcoh[i] <- paste(project_path, "outputs/semcoh", list_semcoh[i], sep="/")
  semcoh[[i]] <- readRDS(list_semcoh[i])
}
if (length(list_sparsity) > 0){
  for (i in 1:length(list_sparsity)){
    list_sparsity[i] <- paste(project_path, "outputs/sparsity", list_sparsity[i], sep="/")
    sparsity[[i]] <- readRDS(list_sparsity[i])
  }
} else {
  for (i in 1:length(list_models)){
    sparsity[i] <- "Sparsity not calculated for models without content covariates"
  }
}

# We now have an R object that is formatted in the same was an STM selectodel. We can use this with plotModels().
class(out) <- "selectModel"
out <- list(runout=runout, semcoh=semcoh, exclusivity=exclusivity, sparsity=sparsity)
saveRDS(out, paste(project_path, "outputs/models/combined_models.RDS", sep="/"))

# clean up
rm(list = ls())
