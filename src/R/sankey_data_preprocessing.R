# A quick script to visualize the preprocesssing of Stack exchange posts, using a sankey diagram

# requirements
library(networkD3)
library(circlize)
library(dplyr)

# load the data
source <- c("Stack Overflow",
            "Data Science",
            "Stack Overflow",
            "Data Science",
            "Software Engineering",
            "Computer Science",
            "Cross Validated",
            "ML posts",
            "Literate programming posts",
            "Combined posts"
            )

target <- c("Literate programming posts",
            "Literate programming posts",
            "ML posts",
            "ML posts",
            "ML posts",
            "ML posts",
            "ML posts",
            "Combined posts",
            "Combined posts",
            "Final dataset"
            )

value <- c(75267,
           372,
           387868,
           25322,
           707,
           3786,
           63370,
           36940,
           9634,
           21555
           )

# Create a data frame with the source, target, and value for each flow in the diagram
data <- data.frame(
  source = source,
  target = target,
  value = value
)

nodes <- data.frame(
  name=c(as.character(data$source), 
         as.character(data$target)) %>% unique()
)

data$IDsource <- match(data$source, nodes$name)-1 
data$IDtarget <- match(data$target, nodes$name)-1

# Create the sankey diagram using the sankeyNetwork function
flow <- sankeyNetwork(
  Links = data,
  Nodes = nodes,
  Source = "IDsource",
  Target = "IDtarget",
  Value = "value",
  NodeID = "name",
  fontSize = 12,
  nodeWidth = 30
)

flow

# Try creating a chord diagram instead
values <- c(387868, 25322, 707, 3786, 63370, 75267, 372, 0, 0, 0, 20863, 553, 0, 3, 136)
m <- matrix(values, nrow = 5, byrow = FALSE)
colnames(m) <- c("ML posts", "Literate programming posts", "Final dataset")
rownames(m) <- c("Stack Overflow", "Data Science", "Software Engineering", "Computer Science", "Cross Validated")

chordDiagram(m, transparency = 0.5)
