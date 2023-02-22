from graph_utils.utils import * 
import argparse
import os
import networkx as nx
import copy

def calculate_area(graph, crit_nodes):
    area_set = set()
    total_area = 0
    for node, data in graph.nodes(data=True):
        if "shape" in data and data["shape"] == "record" and "style" not in data:
            bw = 1
            for pred in graph.predecessors(node):
                edge = graph.get_edge_data(pred, node)

                if 'label' in edge[0]:
                    bw = max(bw, int(edge[0]['label'].split("<")[1].split(">")[0]))

            l = get_module_from_label(data["label"])
            
            if l in op_costs:
                total_area += op_costs[l]["area"]
                area_set.add(l)
                # if op_costs[l]["area"] == 0:
                #     print("\tArea of this component is 0")
                    # else:
                    #     total_area += op_costs[l]["area"]
            # else:
            #     print("Unknown primitive block", l)

    compile_time = 0
    for s in area_set:
        print("Adding area of", s)
        compile_time += op_costs[s]["compile_time"]

    print("Total Predictied Area:", total_area)
    print("Total Predictied Compile Time:", compile_time)

def calculate_power(graph):
    power_set = set()
    total_power = 0
    for node, data in graph.nodes(data=True):
        if "shape" in data and data["shape"] == "record" and "style" not in data:
            bw = 1
            for pred in graph.predecessors(node):
                edge = graph.get_edge_data(pred, node)

                if 'label' in edge[0]:
                    bw = max(bw, int(edge[0]['label'].split("<")[1].split(">")[0]))

            l = get_module_from_label(data["label"])
            
            if l in op_costs:
                total_power += op_costs[l]["power"]
                # print(l, op_costs[l]["power"])
                power_set.add(l)
                # if op_costs[l]["power"] == 0:
                #     print("\tpower of this component is 0")
                    # else:
                    #     total_power += op_costs[l]["power"]
            # else:
            #     print("Unknown primitive block", l)

    compile_time = 0
    for s in power_set:
        print("Adding power of", s)
        compile_time += op_costs[s]["compile_time"]

    print("Total Predictied power:", total_power)
    print("Total Predictied Compile Time:", compile_time)


def flatten(graph, subgraphs, flatten_levels):

    print("Started with", graph.number_of_nodes(), "nodes")
    idx = 0

    for _ in range(flatten_levels):
        labels = {}
        iport_labels = {}
        oport_labels = {}
        for node, data in graph.nodes(data=True):
            if "shape" in data and data["shape"] == "record" and "style" not in data:
                labels[node] = get_module_from_label(data["label"])
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

        for lnode, l  in labels.items():
            if l in subgraphs:
                print("Flattening", l)
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

    print("Ended with", graph.number_of_nodes(), "nodes")

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
                labels[node] = get_module_from_label(data["label"])
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

        for lnode, l  in labels.items():
            if l not in op_costs:
                if l in subgraphs:
                    print("Flattening", l)
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

def find_critical_path(g):

    graph = break_at_regs(g)
    nodes = nx.topological_sort(graph)

    timing_info = {}

    for node in nodes:
        comp = PathComponents()
        components = [comp]

        for parent in graph.predecessors(node):
            comp = PathComponents()

            if parent in timing_info:
                comp = copy.deepcopy(timing_info[parent])
                comp.parent = parent

            hw_info = get_node_info(graph, parent, graph.nodes[parent])

            if hw_info is not None and hw_info["bw"] >= 16:
                comp.block_type.append(hw_info['type'])
                comp.arrival.append(hw_info['delay'])

            components.append(comp)

        maxt = 0
        max_comp = components[0]
        for comp in components:
            if comp.get_total() > maxt:
                maxt = comp.get_total()
                max_comp = comp

        timing_info[node] = max_comp

    node_to_timing = {node: timing_info[node].get_total() for node in graph.nodes}
    node_to_timing = dict(
        sorted(
            reversed(list(node_to_timing.items())),
            key=lambda item: item[1],
            reverse=True,
        )
    )
    max_node = list(node_to_timing.keys())[0]
    max_delay = list(node_to_timing.values())[0]

    clock_speed = int(1.0e12 / max_delay / 1e6)

    print("Maximum clock frequency:", clock_speed, "MHz")
    print("Critical Path:", max_delay, "ns")
    print("Critical Path Info:")
    print("\tNode Name:", max_node)
    timing_info[max_node].print()

    max_node = list(node_to_timing.keys())[0]
    curr_node = max_node
    crit_path = []
    crit_path.append((curr_node, timing_info[curr_node].get_total()))
    crit_nodes = []
    while True:
        crit_nodes.append(curr_node)
        curr_node = timing_info[curr_node].parent
        crit_path.append((curr_node, timing_info[curr_node].get_total()))
        if timing_info[curr_node].parent is None:
            break

    return crit_nodes



def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-d", "--dotfile", help="dot filename", required=True)
    args = parser.parse_args()
    graph, subgraphs = load_dot(args.dotfile)
    graph_name = os.path.splitext(os.path.basename(args.dotfile))[0]

    # construct_primtive_graph(graph, subgraphs)
    flatten(graph, subgraphs, 1)

    graph_to_dot(graph, f"outputs/graphs/{graph_name}_flattened.dot")
    simplify_graph(graph)

    print("Analysis")
    # crit_nodes = find_critical_path(graph)
    crit_nodes = []

    calculate_area(graph, crit_nodes)
    calculate_power(graph)


if __name__ == "__main__":
    main()
