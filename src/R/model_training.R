# This script takes the document frequency matrix created in corpus_cleaning.R
# and uses it to estimate an stm model. Visualisations make use of Paul Wong's 
# scripts at: https://github.com/squarcleconsulting/ukrefimpactmined/blob/master/stmManyTop/stmManyTop.R

# Requirements
library(yaml)
library(stm)
library(igraph)

working_directory <- Sys.getenv("working_path")

# make sure we are in the right directory
setwd(working_directory)

if(!exists("manyTopicsIterative")){
  source(paste(working_directory, "src/R/manyTopics_iterative_saving.R",sep="/"))
}

# Load the .yml files
configs <- read_yaml('configuration/corpus_config.yml')
training_plan <- read_yaml('configuration/training_config.yml')

project_path <- paste('projects', configs$project_details$name, sep="/")

# Load the .RDS dfm file
dtm <- readRDS(paste(project_path, 'inputs/processed/dfm.RDS', sep="/"))

# search for the best number of topics
topic_range <- seq(from = training_plan$K_value_range$min_K, to = training_plan$K_value_range$max_K, by = training_plan$K_value_range$K_interval)

# then run manyTopics without any prevalance or content covariates.
ManyTop<- manyTopicsIterative(documents = dtm$documents, 
                              vocab = dtm$vocab, 
                              K = topic_range, 
                              max.em.its = training_plan$stm_settings$max_iterations, 
                              data = dtm$meta, 
                              init.type = "Spectral", 
                              seed= training_plan$stm_settings$seed, 
                              runs= training_plan$stm_settings$runs,
                              verbose= TRUE
                              )

# save the manytop file
saveRDS(ManyTop, paste(project_path, 'outputs/models/manytopics.RDS', sep="/"))

# Plot Topic Summaries
visualizations_path <- paste(project_path, 'outputs/visualizations/', sep="/")
  
for(i in 1:length(topic_range)) {
  pdf(file = paste0(visualizations_path, topic_range[i], ".pdf"), width = 12, height = 8)
  plot(ManyTop$out[[i]],text.cex = 0.5, n = 15, 
       main = paste0(topic_range[i], " ", "Topics"))
  dev.off()
}

# make TC01 TC05, Topic Correlation Networks list
TC01 <- list()
TC05 <- list()

for(i in 1:length(topic_range)) {
  TC01[[i]] <- topicCorr(ManyTop$out[[i]], method = "simple", cutoff = 0.01)		
  TC05[[i]] <- topicCorr(ManyTop$out[[i]], method = "simple", cutoff = 0.05)
}

# make igraph igTCO1 igTC05 list for plotting
igTC01 <-list()
igTC05 <-list()

for(i in 1:length(topic_range)) {
  igTC01[[i]] <- graph_from_adjacency_matrix(TC01[[i]]$poscor, mode = "undirected", 
                                             weighted = TRUE, diag = FALSE)
  
  igTC05[[i]] <- graph_from_adjacency_matrix(TC05[[i]]$poscor, mode = "undirected", 
                                             weighted = TRUE, diag = FALSE)
  
  # set edge width
  E(igTC01[[i]])$width <- E(igTC01[[i]])$weight*50
  E(igTC05[[i]])$width <- E(igTC05[[i]])$weight*50
  
  # side by side plot of networks and export as pdf	
  pdf(file = paste0(visualizations_path, "TC0105", topic_range[i], "fr.pdf"), width = 12, height = 8)
  par(mfrow = c(1,2))	
  plot(igTC01[[i]], layout = layout_with_fr, 
       vertex.size = degree(igTC01[[i]], mode = "all")*0.5, 
       main = paste0(topic_range[i], " ", "Topics Correlation Network (cutoff = 0.01)")
  )
  plot(igTC05[[i]], layout = layout_with_fr, 
       vertex.size = degree(igTC05[[i]], mode = "all")*1.5, 
       main = paste0(topic_range[i], " ", "Topics Correlation Network (cutoff = 0.05)")
  )
  dev.off()		
  
  # reset edge width for 4 up plot
  E(igTC01[[i]])$width <- E(igTC01[[i]])$weight*10
  E(igTC05[[i]])$width <- E(igTC05[[i]])$weight*10
  
  # 4 up community detection (using NG and GO) plot and export as pdf	
  pdf(file = paste0(visualizations_path, "TCCD0105", topic_range[i], "fr.pdf"), width = 12, height = 8)
  par(mfrow = c(2,2))	
  # plot community detection using NG cutoff = 0.01
  plot(cluster_edge_betweenness(igTC01[[i]]), igTC01[[i]], 
       vertex.size = degree(igTC01[[i]], mode = "all")*0.5, 
       main = paste0(topic_range[i], " ", "Topics Community Detection (Newman-Girvan, cutoff = 0.01)"))
  
  # plot community detection using NG cutoff = 0.05
  plot(cluster_edge_betweenness(igTC05[[i]]), igTC05[[i]], 
       vertex.size = degree(igTC05[[i]], mode = "all")*1.5, 
       main = paste0(topic_range[i], " ", "Topics Community Detection (Newman-Girvan, cutoff = 0.05)"))
  
  # plot community detection using GO cutoff = 0.01
  plot(cluster_fast_greedy(as.undirected(igTC01[[i]])), as.undirected(igTC01[[i]]), 
       vertex.size = degree(igTC01[[i]], mode = "all")*0.5, 
       main = paste0(topic_range[i], " ", "Topics Community Detection (Greedy-Optimisation, cutoff = 0.01)"))
  
  # plot community detection using GO cutoff = 0.05
  plot(cluster_fast_greedy(as.undirected(igTC05[[i]])), as.undirected(igTC05[[i]]), 
       vertex.size = degree(igTC05[[i]], mode = "all")*1.5, 
       main = paste0(topic_range[i], " ", "Topics Community Detection (Greedy-Optimisation, cutoff = 0.05)"))
  dev.off()
}

#save an R image
save.image(paste(project_path, "outputs/manytopics.RData", sep="/"))

#clean up
rm(list = ls())

