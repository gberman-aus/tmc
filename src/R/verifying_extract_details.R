# A quick script to double check the size of corpuses extracted from Stack Exchange.

# requirements
library(dplyr)
library(ggraph)
library(tidyverse)
library(igraph)

# will need to change based on location of raw files
setwd("~/ExtraDrive/Research outputs/Thesis/Chapter on topic modelling and Stack Exchange")


LP_posts <- read.csv("~/ExtraDrive/Research outputs/Thesis/Chapter on topic modelling and Stack Exchange/Data exported from StackExchange/Literate_programming_posts.csv")

dim(LP_posts)

LP_posts_no_duplicates <- LP_posts[!duplicated(LP_posts), ]

dim(LP_posts_no_duplicates)

ML_posts <- read.csv("~/ExtraDrive/Research outputs/Thesis/Chapter on topic modelling and Stack Exchange/Data exported from StackExchange/Machine_learning_posts.csv")

dim(ML_posts)

ML_posts_no_duplicates <- ML_posts[!duplicated(ML_posts), ]

dim(ML_posts_no_duplicates)

ML_sources <- table(ML_posts_no_duplicates$Source)

LP_sources <- table(LP_posts_no_duplicates$Source)

combined_posts <- read.csv("~/ExtraDrive/Research outputs/Thesis/Chapter on topic modelling and Stack Exchange/Data exported from StackExchange/Literate_programming_and_machine_learning_posts.csv")

dim(combined_posts)

combined_posts_no_duplicates <- combined_posts[!duplicated(combined_posts), ]

dim(combined_posts_no_duplicates)

combined_sources <- table(combined_posts_no_duplicates$Source)

ML_with_LP_terms <- read.csv("~/ExtraDrive/Research outputs/Thesis/Chapter on topic modelling and Stack Exchange/Data exported from StackExchange/Machine_learning_posts_with_literate_programming_terms.csv")

ML_with_LP_sources <- table(ML_with_LP_terms$Source)

LP_with_ML_terms <- read.csv("~/ExtraDrive/Research outputs/Thesis/Chapter on topic modelling and Stack Exchange/Data exported from StackExchange/Literate_programming_posts_with_machine_learning_terms.csv")

LP_with_ML_sources <- table(LP_with_ML_terms$Source)

LP_with_ML_terms <- LP_with_ML_terms %>%
  mutate('Origin' = paste('LP', Source, sep="_"))

ML_with_LP_terms <- ML_with_LP_terms %>%
  mutate('Origin' = paste('ML', Source, sep="_"))

combined_with_sources <- rbind(LP_with_ML_terms, ML_with_LP_terms)
dupes <- combined_with_sources[duplicated(combined_with_sources), ]
deduped <- combined_with_sources[!duplicated(combined_with_sources[,1:8]), ]

# We need a data frame giving a hierarchical structure.
edges <- read.csv("~/Desktop/edges.csv", row.names=NULL)
vertices <- read.csv("~/Desktop/vertices.csv", row.names=NULL)
vertices[] <- lapply(vertices, function(x) if(is.integer(x)) as.numeric(x) else x)

edges2 <- flare$edges
vertices2 <- flare$vertices

# Then we have to make a 'graph' object using the igraph library:
mygraph <- graph_from_data_frame( edges, vertices=vertices )

# Make the plot
ggraph(mygraph, layout = 'circlepack') + 
  geom_node_circle() +
  theme_void() +
  geom_node_text(aes(label = shortName), check_overlap = TRUE)

ggraph(mygraph, 'partition', circular = TRUE) + 
  geom_node_arc_bar(aes(fill = depth), size = 0.25) +
  theme_void() +
  theme(legend.position="none")+
  geom_node_text(aes(label = shortName))

ggraph(mygraph, layout='dendrogram', circular=TRUE) + 
  geom_edge_diagonal() +
  theme_void() +
  theme(legend.position="none")+
  geom_node_text(aes(label = shortName))

ggraph(mygraph, 'treemap', weight = size) + 
  geom_node_tile(aes(fill = depth), size = 0.25) +
  theme_void() +
  theme(legend.position="none")+
  geom_node_text(aes(label = shortName))
