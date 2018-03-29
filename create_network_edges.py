import pandas as pd
import random
import itertools


def create_net_edges(start_node, end_node):
    node1 = random.randint(start_node,end_node)
    node2 = random.randint(start_node,end_node)
    return node1, node2

def list_edges(n_edges, start_node, end_node):
    edges = [(create_net_edges(start_node, end_node)) for x in range(n_edges)]
    return edges

def create_sub_group(n_edges, start_node, end_node):
    edge_list = list_edges(n_edges, start_node, end_node)
    df = pd.DataFrame(edge_list)
    return df

def create_network(n_nodes, n_subgroups):
    start = 1
    sub_length = n_nodes/n_subgroups
    end = sub_length
    n_edges = n_subgroups*100
    net_df = pd.DataFrame()
    leaders = []
    for x in range(n_subgroups):
        leaders.append(start)
        sub = create_sub_group(n_edges,start, end)
        net_df = net_df.append(sub, ignore_index=True)
        start = end + 1
        end = end + sub_length
    #Random connections
    inter_group = create_sub_group(12, 1, 600)
    net_df = net_df.append(inter_group, ignore_index=True)
    
    #Single node from each group connected to all other leader nodes
    leader_edges = list(itertools.combinations(leaders, 2))
    net_df = net_df.append(leader_edges, ignore_index=True)

    return net_df     


if __name__ == '__main__':
    net_df = create_network(600, 6)
    net_df.to_csv('network_connections2.csv', index=False, header=False)
    print(net_df.tail())
