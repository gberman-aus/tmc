# An R script for generating visualisations to compare models, and then to visualise individual models.

# Requirements
library(stm)
library(yaml)
library(ggplot2)
library(igraph)
library(ggrepel)

working_directory <- Sys.getenv("working_path")

# make sure we are in the right directory
#setwd(working_directory)
setwd("~/ExtraDrive/Research outputs/Topic modelling/StackExchangeStem")

# Load the .yml files
#configs <- read_yaml('configuration/corpus_config.yml')
#training_plan <- read_yaml('configuration/training_config.yml')
configs <- read_yaml('corpus_config.yml')
training_plan <- read_yaml('training_config.yml')

#project_path <- paste('projects', configs$project_details$name, sep="/")
project_path <- "~/ExtraDrive/Research outputs/Topic modelling/StackExchangeStem"
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

exc_v_semcoh <- ggplot(out, aes(x=semcoh, y=exclus, label = out$K))+
  geom_point() +
  geom_text_repel(
    box.padding = unit(0.5, "lines"),
    max.overlaps = Inf
  ) +
  #geom_label(
  #  label = out$K,
  #  #nudge_x = 0.5,
  #  position=position_jitter(width=0,height=0.)
  #  ) +
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


# Using the STM manytopics output to verify my work above. No need to re run this -- verified.
K <- seq(5, 100, 5)
exc_means <- list()
for (i in K){
  values  <- manymodels$exclusivity[[i/5]]
  exc_means <- append(exc_means, mean(values))
}

semcoh_means <- list()
for (i in K){
  values  <- manymodels$semcoh[[i/5]]
  semcoh_means <- append(semcoh_means, mean(values))
}

out <- do.call(rbind.data.frame, Map('c', K, exc_means, semcoh_means))
colnames(out) <- c("K","exclus","semcoh")
out <- out[order(out$K),]

exc_v_semcoh <- ggplot(out, aes(x=semcoh, y=exclus, label = out$K))+
  geom_point() +
  geom_text_repel(
    box.padding = unit(0.5, "lines"),
    max.overlaps = Inf
  ) +
  #geom_label(
  #  label = out$K,
  #  #nudge_x = 0.5,
  #  position=position_jitter(width=0,height=0.)
  #  ) +
  labs(x = "Semantic coherence", y = "Exclusivity", title = "Mean exclusivity vs. semantic coherence for trained models")

pdf(file = paste0(visualizations_path, "exc_v_semcoh2.pdf"), width = 12, height = 8)
exc_v_semcoh  
dev.off()
