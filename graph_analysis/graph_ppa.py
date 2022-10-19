from graph_utils.utils import load_dot, graph_to_dot
import graph_utils.utils
import argparse
import os
import networkx as nx


def get_module_from_label(label):
    return label.split("}|")[1].split("|{")[0].split("\\n")[1]

def calculate_area(graph):
    total_area = 0
    for node, data in graph.nodes(data=True):
        if "shape" in data and data["shape"] == "record" and "style" not in data:
            bw = 1
            for pred in graph.predecessors(node):
                edge = graph.get_edge_data(pred, node)

                if 'label' in edge[0]:
                    bw = max(bw, int(edge[0]['label'].split("<")[1].split(">")[0]))

            l = get_module_from_label(data["label"])
            
            if l in graph_utils.utils.op_costs:
                if bw >= 16:
                    total_area += graph_utils.utils.op_costs[l]["area"]
            else:
                print("Unknown primitive block", l)


    print("Total Predictied Area:", total_area)


def construct_primtive_graph(graph, subgraphs):

    idx = 0
    non_primitive_blocks = True

    while non_primitive_blocks:
        non_primitive_blocks = False
        labels = {}
        iport_labels = {}
        oport_labels = {}
        for node, data in graph.nodes(data=True):
            if "shape" in data and data["shape"] == "record" and "style" not in data:
                labels[get_module_from_label(data["label"])] = node
                iports = {}
                for p in data["label"].split("}|")[0].split("{")[-1].split("|"):
                    if p != "":
                        iports[p.split(" ")[0].replace("<", "").replace(">", "")] = p.split(" ")[1]
                iport_labels[node] = iports
                oports = {}
                for p in data["label"].split("|{")[-1].split("}")[0].split("|"):
                    if p != "":
                        oports[p.split(" ")[0].replace("<", "").replace(">", "")] = p.split(" ")[1]
                oport_labels[node] = oports

        for l, lnode in labels.items():
            if l not in graph_utils.utils.op_costs:
                if l in subgraphs:
                    non_primitive_blocks = True
                    subgraph = nx.relabel_nodes(subgraphs[l], lambda x: x + f"_{idx}")
                    idx += 1
                    graph.update(subgraph)
                    input_nodes = [u for u, deg in subgraph.in_degree() if not deg]
                    output_nodes = [u for u, deg in subgraph.out_degree() if not deg]

                    for inode in input_nodes:
                        data = subgraph.nodes(data=True)[inode]
                        if "shape" in data and data["shape"] == "octagon":
                            for pred in graph.predecessors(lnode):
                                edge = graph.get_edge_data(pred, lnode)
                                port = edge[0]["headport"].split(":")[0]
                                if iport_labels[lnode][port] == data["label"]:
                                    graph.add_edge(pred, inode)
                                    break

                    for onode in output_nodes:
                        data = subgraph.nodes(data=True)[onode]
                        if "shape" in data and data["shape"] == "octagon":
                            for succ in graph.successors(lnode):
                                edge = graph.get_edge_data(lnode, succ)
                                port = edge[0]["tailport"].split(":")[0]
                                if oport_labels[lnode][port] == data["label"]:
                                    graph.add_edge(onode, succ)
                                    break
                    graph.remove_node(lnode)
                else:
                    print("Found unknown node with no definition", l)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-d", "--dotfile", help="dot filename", required=True)
    args = parser.parse_args()
    graph, subgraphs = load_dot(args.dotfile)
    graph_name = os.path.splitext(os.path.basename(args.dotfile))[0]

    construct_primtive_graph(graph, subgraphs)

    graph_to_dot(graph, f"outputs/graphs/{graph_name}_flattened.dot")

    calculate_area(graph)


if __name__ == "__main__":
    main()
