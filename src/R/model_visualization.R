# An R script for generating visualisations to compare models, and then to visualise individual models.

# Requirements
library(stm)
library(yaml)
library(ggplot2)
library(igraph)

working_directory <- Sys.getenv("working_path")

# make sure we are in the right directory
setwd(working_directory)

# Load the .yml files
configs <- read_yaml('configuration/corpus_config.yml')
training_plan <- read_yaml('configuration/training_config.yml')

project_path <- paste('projects', configs$project_details$name, sep="/")
visualizations_path <- paste(project_path, 'outputs/visualizations/', sep="/")

# Load the compbined RDS file of the trained models
models <- readRDS(paste(project_path, "outputs/models/combined_models.RDS", sep="/"))

# for each value of K, we need mean values of exclusivity and semantic coherence
K <- list()
for (i in seq_along(models$runout)){
  K <- append(K, models$runout[[i]][['settings']][['dim']][['K']])
}

exc_means <- list()
for (i in seq_along(models$exclusivity)){
  values  <- models$exclusivity[[i]]
  exc_means <- append(exc_means, mean(values))
}

semcoh_means <- list()
for (i in seq_along(models$semcoh)){
  values  <- models$semcoh[[i]]
  semcoh_means <- append(semcoh_means, mean(values))
}

out <- do.call(rbind.data.frame, Map('c', K, exc_means, semcoh_means))
colnames(out) <- c("K","exclus","semcoh")
out <- out[order(out$K),]

exc_v_semcoh <- ggplot(out, aes(x=semcoh, y=exclus))+
  geom_point() +
  geom_text(
    label = out$K,
    nudge_x = 0.5,
    check_overlap = TRUE) +
  labs(x = "Semantic coherence", y = "Exclusivity", title = "Mean exclusivity vs. semantic coherence for trained models")

pdf(file = paste0(visualizations_path, "exc_v_semcoh.pdf"), width = 12, height = 8)
exc_v_semcoh  
dev.off()

# to keepfile size down, remove the models file
rm(models)

#save an R image
save.image(paste(project_path, "outputs/visualizations.RData", sep="/"))

#clean up
rm(list = ls())


