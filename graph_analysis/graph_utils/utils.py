import os
import networkx as nx
import matplotlib.pyplot as plt
import pygraphviz

op_costs = {
    "$add": {"crit_path": 0, "area": 11.854, "energy": 0},
    "$and": {"crit_path": 0, "area": 2.580, "energy": 0},
    "$div": {"crit_path": 0, "area": 582.987, "energy": 0},
    "$eq": {"crit_path": 0, "area": 5.524, "energy": 0},
    "$eqx": {"crit_path": 0, "area": 5.524, "energy": 0},
    "$ge": {"crit_path": 0, "area": 7.540, "energy": 0},
    "$gt": {"crit_path": 0, "area": 7.620, "energy": 0},
    "$le": {"crit_path": 0, "area": 7.540, "energy": 0},
    "$logic_and": {"crit_path": 0, "area": 2.177, "energy": 0},
    "$logic_or": {"crit_path": 0, "area": 2.177, "energy": 0},
    "$lt": {"crit_path": 0, "area": 7.620, "energy": 0},
    "$mod": {"crit_path": 0, "area": 706.810 , "energy": 0},
    "$mul": {"crit_path": 0, "area": 212.9, "energy": 0},
    "$ne": {"crit_path": 0, "area": 5.524, "energy": 0},
    "$nex": {"crit_path": 0, "area": 5.524, "energy": 0},
    "$or": {"crit_path": 0, "area": 2.58, "energy": 0},
    "$shl": {"crit_path": 0, "area": 16.12, "energy": 0},
    "$shr": {"crit_path": 0, "area": 16.128, "energy": 0},
    "$sshl": {"crit_path": 0, "area": 16.128, "energy": 0},
    "$sshr": {"crit_path": 0, "area": 16.128, "energy": 0},
    "$sub": {"crit_path": 0, "area": 12.822, "energy": 0},
    "$xnor": {"crit_path": 0, "area": 4.516, "energy": 0},
    "$xor": {"crit_path": 0, "area": 4.516, "energy": 0},
    "$mux": {"crit_path": 0, "area": 5.806, "energy": 0},
    "$dff": {"crit_path": 0, "area": 11.612, "energy": 0},
    "$dffe": {"crit_path": 0, "area": 11.612, "energy": 0},
    "$sdff": {"crit_path": 0, "area": 11.612, "energy": 0},
    "$not": {"crit_path": 0, "area": 0, "energy": 0},
    "$logic_not": {"crit_path": 0, "area": 0, "energy": 0},
    "$neg": {"crit_path": 0, "area": 6.532, "energy": 0},
}


def graph_to_dot(graph, outfilename):
    nx.drawing.nx_agraph.write_dot(graph, outfilename)


def plot_graph(graph):
    pos = nx.nx_agraph.graphviz_layout(graph, prog="dot")
    ec = nx.draw_networkx_edges(graph, pos)
    nc = nx.draw_networkx_nodes(graph, pos)

    plt.savefig("graph.png")


def load_dot(filename):
    assert os.path.exists(filename), f"{filename} does not exist"
    graph_name = os.path.splitext(os.path.basename(filename))[0]
    g = pygraphviz.AGraph(filename)
    graphs = {}
    for s in g.subgraphs():
        graphs[s.name.replace("cluster_", "")] = nx.nx_agraph.from_agraph(s)

    return graphs[graph_name], graphs
