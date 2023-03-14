import os
import networkx as nx
import matplotlib.pyplot as plt
import pygraphviz

op_costs = {
"NV_NVDLA_CMAC_CORE_active": {"area": 228758.3992, "compile_time": 105.5861, "power": 4.3916e+06},
"NV_NVDLA_CMAC_CORE_cfg": {"area": 112.7840, "compile_time": 1.0483, "power": 1.9424e+03},
"NV_NVDLA_CMAC_CORE_MAC_exp": {"area": 6095.9219, "compile_time": 3.6541, "power": 1.2253e+05},
"NV_NVDLA_CMAC_CORE_MAC_mul": {"area": 1516.7320, "compile_time": 3.4669, "power": 3.5404e+04},
"NV_NVDLA_CMAC_CORE_MAC_nan": {"area": 1852.1580, "compile_time": 2.7645, "power": 4.8334e+04},
"NV_NVDLA_CMAC_CORE_mac": {"area": 158990.5944, "compile_time": 240.3557, "power": 3.4290e+06},
"NV_NVDLA_CMAC_CORE_rt_in": {"area": 15062.2497, "compile_time": 2.9143, "power": 2.7164e+05},
"NV_NVDLA_CMAC_CORE_rt_out": {"area": 9170.6158, "compile_time": 3.4415, "power": 1.6337e+05},
"NV_NVDLA_CMAC_CORE_slcg": {"area": 8.7780, "compile_time": 1.0372, "power": 172.6562},
"NV_NVDLA_CMAC_core": {"area": 1510230.1594, "compile_time": 2366.5898, "power": 3.1128e+07},
"NV_NVDLA_CMAC_REG_dual": {"area": 49.7420, "compile_time": 1.0330, "power": 1.1564e+03},
"NV_NVDLA_CMAC_REG_single": {"area": 35.6440, "compile_time": 1.0941, "power": 943.2612},
"NV_NVDLA_CMAC_reg": {"area": 357.7700, "compile_time": 1.1309, "power": 6.3756e+03},
"NV_NVDLA_cmac": {"area": 1510586.5994, "compile_time": 2387.8037, "power": 3.1130e+07},

"NV_NVDLA_PDP_CORE_cal1d": {"area": 229624.5030, "compile_time": 188.8340, "power": 4.3487e+06},
"NV_NVDLA_PDP_CORE_cal2d": {"area": 196277.6791, "compile_time": 162.1550, "power": 3.9935e+06},
"NV_NVDLA_PDP_CORE_preproc": {"area": 14316.3858, "compile_time": 11.0621, "power": 2.9891e+05},
"NV_NVDLA_PDP_CORE_unit1d": {"area": 26121.4663, "compile_time": 18.9597, "power": 4.9905e+05},
"NV_NVDLA_PDP_core": {"area": 440523.6699, "compile_time": 430.0173, "power": 8.6541e+06},
"NV_NVDLA_PDP_nan": {"area": 2632.6021, "compile_time": 2.1548, "power": 5.1030e+04},
"NV_NVDLA_PDP_RDMA_cq": {"area": 2357.5580, "compile_time": 1.9896, "power": 5.1384e+04},
"NV_NVDLA_PDP_RDMA_eg": {"area": 56532.9791, "compile_time": 34.4614, "power": 1.0242e+06},
"NV_NVDLA_PDP_RDMA_ig": {"area": 8041.7120, "compile_time": 5.3095, "power": 1.4568e+05},
"NV_NVDLA_PDP_RDMA_REG_dual": {"area": 2042.6141, "compile_time": 1.8020, "power": 3.2594e+04},
"NV_NVDLA_PDP_RDMA_REG_single": {"area": 35.6440, "compile_time": 1.0742, "power": 943.2612},
"NV_NVDLA_PDP_RDMA_reg": {"area": 5198.4381, "compile_time": 3.7275, "power": 8.3591e+04},
"NV_NVDLA_PDP_rdma": {"area": 71941.2951, "compile_time": 54.3929, "power": 1.2963e+06},
"NV_NVDLA_PDP_REG_dual": {"area": 5092.0381, "compile_time": 3.1583, "power": 8.4469e+04},
"NV_NVDLA_PDP_REG_single": {"area": 35.6440, "compile_time": 1.1127, "power": 943.2612},
"NV_NVDLA_PDP_reg": {"area": 13182.6943, "compile_time": 9.5714, "power": 2.2941e+05},
"NV_NVDLA_PDP_slcg": {"area": 7.7140, "compile_time": 1.0689, "power": 148.9259},
"NV_NVDLA_PDP_WDMA_cmd": {"area": 3409.0560, "compile_time": 2.4775, "power": 6.6242e+04},
"NV_NVDLA_PDP_WDMA_dat": {"area": 16432.4158, "compile_time": 12.6731, "power": 2.7009e+05},
"NV_NVDLA_PDP_wdma": {"area": 51709.3352, "compile_time": 36.6800, "power": 8.4458e+05},
"NV_NVDLA_pdp": {"area": 581312.1486, "compile_time": 649.4170, "power": 1.1102e+07},

"NV_NVDLA_SDP_BRDMA_cq": {"area": 471.8840, "compile_time": 1.1844, "power": 9.0348e+03},
"NV_NVDLA_SDP_BRDMA_EG_ro": {"area": 26181.0495, "compile_time": 19.2224, "power": 4.6421e+05},
"NV_NVDLA_SDP_BRDMA_eg": {"area": 88657.0004, "compile_time": 67.5636, "power": 1.5801e+06},
"NV_NVDLA_SDP_BRDMA_gate": {"area": 14.6300, "compile_time": 1.0181, "power": 271.8886},
"NV_NVDLA_SDP_BRDMA_ig": {"area": 8012.4520, "compile_time": 4.5480, "power": 1.4304e+05},
"NV_NVDLA_SDP_brdma": {"area": 97254.1204, "compile_time": 70.6178, "power": 1.7381e+06},
"NV_NVDLA_SDP_cmux": {"area": 15603.5597, "compile_time": 8.8376, "power": 2.9032e+05},
"NV_NVDLA_SDP_ERDMA_cq": {"area": 429.5900, "compile_time": 1.1441, "power": 8.2045e+03},
"NV_NVDLA_SDP_ERDMA_EG_ro": {"area": 26181.0495, "compile_time": 18.6399, "power": 4.6421e+05},
"NV_NVDLA_SDP_ERDMA_eg": {"area": 88599.0124, "compile_time": 65.5317, "power": 1.5787e+06},
"NV_NVDLA_SDP_ERDMA_gate": {"area": 14.6300, "compile_time": 0.9704, "power": 271.8886},
"NV_NVDLA_SDP_ERDMA_ig": {"area": 8008.4620, "compile_time": 4.5543, "power": 1.4284e+05},
"NV_NVDLA_SDP_erdma": {"area": 97200.1224, "compile_time": 78.3836, "power": 1.7362e+06},
"NV_NVDLA_SDP_MRDMA_cq": {"area": 420.5460, "compile_time": 1.1921, "power": 8.0449e+03},
"NV_NVDLA_SDP_MRDMA_EG_cmd": {"area": 1274.6720, "compile_time": 1.6856, "power": 2.8489e+04},
"NV_NVDLA_SDP_MRDMA_EG_din": {"area": 55131.6910, "compile_time": 30.5505, "power": 9.8773e+05},
"NV_NVDLA_SDP_MRDMA_EG_dout": {"area": 13766.0319, "compile_time": 10.6087, "power": 2.8639e+05},
"NV_NVDLA_SDP_MRDMA_eg": {"area": 70141.0069, "compile_time": 44.5251, "power": 1.2923e+06},
"NV_NVDLA_SDP_MRDMA_gate": {"area": 14.6300, "compile_time": 1.0152, "power": 271.8886},
"NV_NVDLA_SDP_MRDMA_ig": {"area": 7867.2160, "compile_time": 4.2548, "power": 1.4443e+05},
"NV_NVDLA_SDP_mrdma": {"area": 78572.6749, "compile_time": 55.8085, "power": 1.4502e+06},
"NV_NVDLA_SDP_NRDMA_cq": {"area": 471.8840, "compile_time": 1.2911, "power": 9.0348e+03},
"NV_NVDLA_SDP_NRDMA_EG_ro": {"area": 26181.0495, "compile_time": 19.2435, "power": 4.6421e+05},
"NV_NVDLA_SDP_NRDMA_eg": {"area": 88658.5964, "compile_time": 68.5269, "power": 1.5800e+06},
"NV_NVDLA_SDP_NRDMA_gate": {"area": 14.6300, "compile_time": 0.9921, "power": 271.8886},
"NV_NVDLA_SDP_NRDMA_ig": {"area": 8012.4520, "compile_time": 4.5391, "power": 1.4303e+05},
"NV_NVDLA_SDP_nrdma": {"area": 97257.8444, "compile_time": 72.6883, "power": 1.7381e+06},
"NV_NVDLA_SDP_RDMA_REG_dual": {"area": 4957.1761, "compile_time": 2.8905, "power": 9.0119e+04},
"NV_NVDLA_SDP_RDMA_REG_single": {"area": 35.6440, "compile_time": 1.0030, "power": 943.2612},
"NV_NVDLA_SDP_RDMA_reg": {"area": 14939.8904, "compile_time": 8.5117, "power": 2.4506e+05},
# "NV_NVDLA_SDP_rdma": {"area": 385092.4505, "compile_time": 301.4680, "power": 6.8994e+06},
"NV_NVDLA_SDP_REG_dual": {"area": 4932.1721, "compile_time": 3.0033, "power": 8.2039e+04},
"NV_NVDLA_SDP_REG_single": {"area": 2103.5281, "compile_time": 1.8718, "power": 3.3805e+04},
"NV_NVDLA_SDP_reg": {"area": 18474.4985, "compile_time": 9.1372, "power": 3.0465e+05},
"NV_NVDLA_SDP_WDMA_cmd": {"area": 9221.6881, "compile_time": 6.3211, "power": 2.0488e+05},
"NV_NVDLA_SDP_WDMA_DAT_in": {"area": 16710.3858, "compile_time": 10.5910, "power": 2.8111e+05},
"NV_NVDLA_SDP_WDMA_DAT_out": {"area": 1604.7780, "compile_time": 2.8357, "power": 3.0297e+04},
"NV_NVDLA_SDP_WDMA_dat": {"area": 18311.9718, "compile_time": 13.2206, "power": 3.1349e+05},
"NV_NVDLA_SDP_WDMA_dmaif": {"area": 28701.3994, "compile_time": 17.4363, "power": 4.9594e+05},
"NV_NVDLA_SDP_WDMA_gate": {"area": 7.7140, "compile_time": 1.0130, "power": 148.9259},
"NV_NVDLA_SDP_wdma": {"area": 56276.5553, "compile_time": 33.7238, "power": 9.6634e+05},
"NV_NVDLA_SDP_CORE_c": {"area": 113880.4541, "compile_time": 125.5873, "power": 2.3692e+06},
"NV_NVDLA_SDP_CORE_gate": {"area": 22.8760, "compile_time": 1.0550, "power": 456.2249},
"NV_NVDLA_SDP_CORE_x": {"area": 353245.0811, "compile_time": 280.6890, "power": 6.9233e+06},
"NV_NVDLA_SDP_CORE_Y_core": {"area": 93897.2037, "compile_time": 75.3499, "power": 2.0354e+06},
"NV_NVDLA_SDP_CORE_Y_cvt": {"area": 16205.7843, "compile_time": 15.6357, "power": 3.4034e+05},
"NV_NVDLA_SDP_CORE_Y_dmapack": {"area": 1896.3140, "compile_time": 2.2230, "power": 3.5161e+04},
"NV_NVDLA_SDP_CORE_Y_dppack": {"area": 3763.3679, "compile_time": 2.4185, "power": 6.9605e+04},
"NV_NVDLA_SDP_CORE_Y_dpunpack": {"area": 3321.8079, "compile_time": 2.2356, "power": 5.9075e+04},
"NV_NVDLA_SDP_CORE_Y_idx": {"area": 95471.9238, "compile_time": 77.6569, "power": 1.9164e+06},
"NV_NVDLA_SDP_CORE_Y_inp": {"area": 153141.2570, "compile_time": 96.8601, "power": 2.9824e+06},
"NV_NVDLA_SDP_CORE_Y_lut": {"area": 102083.8861, "compile_time": 75.6891, "power": 1.8305e+06},
# "NV_NVDLA_SDP_CORE_y": {"area": 490702.1790, "compile_time": 484.8206, "power": 9.6802e+06},
# "NV_NVDLA_SDP_core": {"area": 1367511.6101, "compile_time": 1576.6387, "power": 2.6882e+07},
# "NV_NVDLA_sdp": {"area": 1826710.3303, "compile_time": 1922.9668, "power": 3.5022e+07},
}

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
    "$sshl": {"delay":  0.2, "area": 28.788, "reg": False},
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

op_costs_slow = {
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

            if 'label' in edge[0]:
                bw = max(bw, int(edge[0]['label'].split("<")[1].split(">")[0]))

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
            edges_to_be_removed.append((node,child))

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
        elif "shape" in data and data["shape"] == "octagon" and (len(list(graph.predecessors(node))) == 0 or len(list(graph.successors(node))) == 0):
            keep = True
        elif (len(list(graph.predecessors(node))) == 0 or len(list(graph.successors(node))) == 0):
            keep = True
        elif len(list(graph.predecessors(node))) > 1 and len(list(graph.successors(node))) > 1:
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

                    if 'headport' in sedge[0]:
                        edge_data['headport'] = sedge[0]['headport']

                    if 'tailport' in pedge[0]:
                        edge_data['tailport'] = pedge[0]['tailport']
                    
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
                    iports[p.split(" ")[0].replace("<", "").replace(">", "")] = p.split(" ")[1]
            iport_labels[node] = iports
            oports = {}
            for p in data["label"].split("|{")[-1].split("}")[0].split("|"):
                if p != "":
                    oports[p.split(" ")[0].replace("<", "").replace(">", "")] = p.split(" ")[1]
            oport_labels[node] = oports
    return labels, iport_labels, oport_labels