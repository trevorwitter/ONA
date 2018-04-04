library(igraph)
library(visNetwork)
library(RColorBrewer)


# Create graph from edge list. Nodes implied from edge list
g1 <- graph( edges=c(1,2, 2,3, 4,3, 5,4, 6,3, 6,4, 7,2, 8,5, 7,9), n=9, directed=T)

# Quantify subgroups within the graph
##clp <- cluster_label_prop(g1)
#plot(clp, g1)


#Quantify desired node metrics as assign to graph
V(g1)$community <- cluster_label_prop(g1)$membership #subgroups
V(g1)$betweenness <- betweenness(g1, v = V(g1), directed = F) 
V(g1)$degree <- degree(g1, v = V(g1)) 
V(g1)$eigen <- eigen_centrality(g1)$vector


# Convert to visNetwork data and separate into data.frames for nodes and edges
data <- toVisNetworkData(g1)
nodes <- data[[1]]
edges <- data[[2]]

# nodes variables control visual properties of each node

# nodes$label= adds labels on nodes
# nodes$group= add groups on nodes 
# nodes$value= size adding value
# nodes$shape control shape of nodes
# nodes$title tooltip (html or character)
# nodes$color color
# nodes$shadow shadow

# edges variables control visual properties of each edge

# edges$label add labels on edges
# edges$length length
# edges$arrows arrows
# edges$dashes dashes; boolean
# edges$title tooltip (html or character)
# edges$smooth smooth
# edges$shadow shadow

nodes$color <- brewer.pal(12, "Set3")[as.factor(nodes$community)]
nodes$value <- nodes$eigen #node size 
nodes$title <- paste0( "<p><b>", nodes$id, "</b><br>Eigenvector:", round(nodes$eigen, 2), "</p>")


visNetwork(nodes,edges) %>%
  visOptions( highlightNearest = TRUE, nodesIdSelection = TRUE) %>%
  visInteraction( navigationButtons = TRUE) %>%
  visPhysics( enabled = FALSE) %>%
  visEdges(arrows = "from", width = 0.5, selfReferenceSize = 0, arrowStrikethrough = FALSE) %>% 
  visNodes(scaling = list(min = 5, max = 50)) %>%
  visHierarchicalLayout(enabled = FALSE) %>%
  visLayout(randomSeed = 123)

