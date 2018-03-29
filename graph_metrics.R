library(igraph)
library(visNetwork)

df = read.csv('network_connections2.csv')
head(df)

# Create edge list ready to use as graph input
edge.list <- c()
for (x in seq(1,nrow(df))){
  edge.list <- c(edge.list, df[x,1], df[x,2])
}

g1 <- graph( edges=edge.list, n=max(df), directed=F)
#plot(g1)

g1_density <- edge_density(g1, loops = F)
print(g1_density)

# Quantify subgroups within the graph
clp <- cluster_label_prop(g1)
print(clp$membership)

# Eigenvector centrality
eigen <- eigen_centrality(g1)

# Create vertex attributes for desired ONA metrics
V(g1)$community <- clp$membership
V(g1)$degree <- degree(g1, v = V(g1))
V(g1)$betweenness <- betweenness(g1, v = V(g1), directed = F)
V(g1)$eigen_centrality <- eigen$vector


# Create data frame for nodes and their associated values (betweenness etc)
# and data frame for edges
data <- toVisNetworkData(g1)
nodes <- data[[1]]
edges <- data[[2]]

head(nodes)

write.csv(nodes, file = 'node_metrics.csv')

