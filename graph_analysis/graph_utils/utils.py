import os
import networkx as nx
import matplotlib.pyplot as plt
import pygraphviz
from graphviz import Digraph

op_costs_fast = {
    "$add": {"delay": 0.2, "area": 28.74, "reg": False},
    "$and": {"delay": 0.1, "area": 2.58, "reg": False},
    "$div": {"delay": 1.0, "area": 582.987, "reg": False},
    "$eq": {"delay": 0.2, "area": 5.5, "reg": False},
    "$eqx": {"delay": 0.2, "area": 5.5, "reg": False},
    "$ge": {"delay": 0.2, "area": 9.677, "reg": False},
    "$gt": {"delay": 0.2, "area": 9.677, "reg": False},
    "$le": {"delay": 0.2, "area": 9.677, "reg": False},
    "$logic_and": {"delay": 0.2, "area": 2.177, "reg": False},
    "$logic_or": {"delay": 0.2, "area": 2.17, "reg": False},
    "$lt": {"delay": 0.2, "area": 9.717, "reg": False},
    "$mod": {"delay": 1.0, "area": 706.810, "reg": False},
    "$mul": {"delay": 0.5, "area": 245.7, "reg": False},
    "$ne": {"delay": 0.2, "area": 5.52, "reg": False},
    "$nex": {"delay": 0.2, "area": 5.52, "reg": False},
    "$or": {"delay": 0.1, "area": 3.8, "reg": False},
    "$shl": {"delay": 0.2, "area": 28.788, "reg": False},
    "$shr": {"delay": 0.2, "area": 27.498, "reg": False},
    "$sshl": {"delay": 0.2, "area": 28.788, "reg": False},
    "$sshr": {"delay": 0.2, "area": 27.498, "reg": False},
    "$sub": {"delay": 0.2, "area": 38.14, "reg": False},
    "$xnor": {"delay": 0.2, "area": 4.51, "reg": False},
    "$xor": {"delay": 0.1, "area": 4.51, "reg": False},
    "$mux": {"delay": 0.2, "area": 5.806, "reg": False},
    "$not": {"delay": 0.1, "area": 0, "reg": False},
    "$logic_not": {"delay": 0.1, "area": 0, "reg": False},
    "$neg": {"delay": 0.2, "area": 9.233, "reg": False},
    "$dff": {"delay": 0, "area": 20.9, "reg": True},
    "$dffe": {"delay": 0, "area": 20.9, "reg": True},
    "$sdff": {"delay": 0, "area": 20.9, "reg": True},
}

op_costs = {
    "$add": {"delay": 1.0, "area": 11.854, "reg": False},
    "$and": {"delay": 1.0, "area": 2.580, "reg": False},
    "$div": {"delay": 1.0, "area": 582.987, "reg": False},
    "$eq": {"delay": 1.0, "area": 5.524, "reg": False},
    "$eqx": {"delay": 1.0, "area": 5.524, "reg": False},
    "$ge": {"delay": 1.0, "area": 7.540, "reg": False},
    "$gt": {"delay": 1.0, "area": 7.620, "reg": False},
    "$le": {"delay": 1.0, "area": 7.540, "reg": False},
    "$logic_and": {"delay": 1.0, "area": 2.177, "reg": False},
    "$logic_or": {"delay": 1.0, "area": 2.177, "reg": False},
    "$lt": {"delay": 1.0, "area": 7.620, "reg": False},
    "$mod": {"delay": 1.0, "area": 706.810, "reg": False},
    "$mul": {"delay": 1.0, "area": 212.9, "reg": False},
    "$ne": {"delay": 1.0, "area": 5.524, "reg": False},
    "$nex": {"delay": 1.0, "area": 5.524, "reg": False},
    "$or": {"delay": 1.0, "area": 2.58, "reg": False},
    "$shl": {"delay": 1.0, "area": 16.12, "reg": False},
    "$shr": {"delay": 1.0, "area": 16.128, "reg": False},
    "$sshl": {"delay": 1.0, "area": 16.128, "reg": False},
    "$sshr": {"delay": 1.0, "area": 16.128, "reg": False},
    "$sub": {"delay": 1.0, "area": 12.822, "reg": False},
    "$xnor": {"delay": 1.0, "area": 4.516, "reg": False},
    "$xor": {"delay": 1.0, "area": 4.516, "reg": False},
    "$mux": {"delay": 1.0, "area": 5.806, "reg": False},
    "$not": {"delay": 1.0, "area": 0, "reg": False},
    "$logic_not": {"delay": 1.0, "area": 0, "reg": False},
    "$neg": {"delay": 1.0, "area": 6.532, "reg": False},
    "$dff": {"delay": 0.0, "area": 11.612, "reg": True},
    "$dffe": {"delay": 0.0, "area": 11.612, "reg": True},
    "$sdff": {"delay": 0.0, "area": 11.612, "reg": True},
}


def print_simplified_graph(graph):
    new_graph = Digraph()

    mod_nodes = []

    name_dict = {}

    for node, data in graph.nodes(data=True):
        if is_module(data):
            label = get_module_from_label(data["label"])
            n = data['label'].split('}|')[1].split('|{')[0].split('\\n')[0]
            new_graph.node(str(node), label=f"{node}\n{label}\n{n}")
            mod_nodes.append(node)
            name_dict[node] = n

    print(name_dict)
    for node1 in mod_nodes:
        for node2 in mod_nodes:
            if node1 != node2:
                if nx.has_path(graph, source=node1, target=node2):
                    new_graph.edge(node1, node2)
    new_graph.render("debug")

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


def is_prim_mod(l):
    prims = {"DW02_tree"}
    return "$" in l or l in prims


def is_module(data):
    return "shape" in data and data["shape"] == "record" and "style" not in data


def get_module_from_label(label):
    return label.split("}|")[1].split("|{")[0].split("\\n")[1]


def get_node_info(graph, node, data):
    if "shape" in data and data["shape"] == "record" and "style" not in data:
        bw = 1
        for pred in graph.predecessors(node):
            edge = graph.get_edge_data(pred, node)

            if "label" in edge[0]:
                bw = max(bw, int(edge[0]["label"].split("<")[1].split(">")[0]))

        l = get_module_from_label(data["label"])

        if l in op_costs:
            ret = op_costs[l]
            ret["type"] = l
            ret["bw"] = bw
            return op_costs[l]


class PathComponents:
    def __init__(
        self,
        arrival=[],
        block_type=[],
        parent=None,
    ):
        self.arrival = arrival
        self.block_type = block_type
        self.parent = parent

    def get_total(self):
        return sum(self.arrival)

    def print(self):
        print("\tCritical Path:")
        for a in zip(self.arrival, self.block_type):
            print("\t\t" + str(a))


def break_at_regs(g):
    graph = g.copy()

    for node, data in graph.nodes(data=True):
        hw_info = get_node_info(graph, node, data)

        if hw_info is not None:
            if hw_info["reg"]:
                for succ in g.successors(node):
                    graph.remove_edge(node, succ)

    return graph


def dfs_visit_recursively(g, node, nodes_color, edges_to_be_removed):

    nodes_color[node] = 1
    succ = list(g.successors(node))

    for child in succ:
        if nodes_color[child] == 0:
            dfs_visit_recursively(g, child, nodes_color, edges_to_be_removed)
        elif nodes_color[child] == 1:
            edges_to_be_removed.append((node, child))

    nodes_color[node] = 2


def break_cycles(g):
    nodes_color = {}
    edges_to_be_removed = []

    for node in g.nodes:
        nodes_color[node] = 0

    for node in g.nodes:
        if nodes_color[node] == 0:
            dfs_visit_recursively(g, node, nodes_color, edges_to_be_removed)

    for edge in edges_to_be_removed:
        g.remove_edge(edge[0], edge[1])

    return g


def simplify_graph(graph):
    for node, data in graph.copy().nodes(data=True):
        keep = False
        if "shape" in data and data["shape"] == "record":
            keep = True
        elif (
            "shape" in data
            and data["shape"] == "octagon"
            and (
                len(list(graph.predecessors(node))) == 0
                or len(list(graph.successors(node))) == 0
            )
        ):
            keep = True
        elif (
            len(list(graph.predecessors(node))) == 0
            or len(list(graph.successors(node))) == 0
        ):
            keep = True
        elif (
            len(list(graph.predecessors(node))) > 1
            and len(list(graph.successors(node))) > 1
        ):
            keep = True

        if not keep:
            for pred in graph.predecessors(node):
                for succ in graph.successors(node):
                    pedge = graph.get_edge_data(pred, node)
                    sedge = graph.get_edge_data(node, succ)

                    if len(pedge[0]) != 0:
                        edge_data = pedge[0]
                    else:
                        edge_data = sedge[0]

                    if "headport" in sedge[0]:
                        edge_data["headport"] = sedge[0]["headport"]

                    if "tailport" in pedge[0]:
                        edge_data["tailport"] = pedge[0]["tailport"]

                    graph.add_edge(pred, succ, **edge_data)

            graph.remove_node(node)


def get_port_labels(graph):
    labels = {}
    iport_labels = {}
    oport_labels = {}
    for node, data in graph.nodes(data=True):
        if is_module(data):
            labels[node] = get_module_from_label(data["label"])
            iports = {}
            for p in data["label"].split("}|")[0].split("{")[-1].split("|"):
                if p != "":
                    iports[p.split(" ")[0].replace("<", "").replace(">", "")] = p.split(
                        " "
                    )[1]
            iport_labels[node] = iports
            oports = {}
            for p in data["label"].split("|{")[-1].split("}")[0].split("|"):
                if p != "":
                    oports[p.split(" ")[0].replace("<", "").replace(">", "")] = p.split(
                        " "
                    )[1]
            oport_labels[node] = oports
    return labels, iport_labels, oport_labels
