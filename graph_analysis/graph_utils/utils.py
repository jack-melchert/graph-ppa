import os
import networkx as nx
import matplotlib.pyplot as plt
import pygraphviz


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
