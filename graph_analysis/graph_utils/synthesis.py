import networkx as nx
from graph_utils.utils import * 
import subprocess
import glob
import time

def write_switching(switching, filename):

    fout = open(filename, 'w')

    lines = ""
    if switching is not None:
        for port in switching:
            for bit_port in port:
                lines += f"set_switching_activity {bit_port[0]} -static_probability {bit_port[1]} -toggle_rate {bit_port[2]}\n"

    fout.write(lines)

    fout.close()

def node_synth(node, folder, switching):
    print("Running synth for", node)
    folder = folder.split("/")[-1]

    top_names = f'export TOP_NAMES="{node}"\n'
    # rtl_search_path = f'export RTL_SEARCH_PATH="/nobackup/melchert/qualcomm/hw/vmod/nvdla/{folder} /nobackup/melchert/qualcomm/hw/vmod/vlibs /nobackup/melchert/qualcomm/hw/vmod/rams/model/ /nobackup/melchert/qualcomm/hw/outdir/nv_full/vmod/rams/synth/"\n'
    synth_script_filename = "/nobackup/melchert/qualcomm/hw/syn/scripts/default_config.sh"

    fin = open(synth_script_filename, 'r')
    new_synth_script = fin.readlines()

    for idx, line in enumerate(new_synth_script):
        if "export TOP_NAMES=" in line:
            new_synth_script[idx] = top_names
        # elif "export RTL_SEARCH_PATH=" in line:
        #     new_synth_script[idx] = rtl_search_path

    fin.close()

    fout = open(synth_script_filename, 'w')
    fout.writelines(new_synth_script)
    fout.close()

    switching_filename = "/nobackup/melchert/qualcomm/hw/syn/scripts/set_switching.tcl"

    write_switching(switching, switching_filename)

    synth_command = ["bash", "syn/scripts/syn_launch.sh", "-config", "syn/scripts/default_config.sh"]

    start = time.time()
    subprocess.check_call(
        synth_command,
        cwd="/nobackup/melchert/qualcomm/hw"
    )
    end = time.time()

    return end - start

def parse_node_synth(mod):
    result_dir = "/nobackup/melchert/qualcomm/hw/"
    dirs = glob.glob(result_dir + "nvdla_syn_*")
    dirs.sort()
    folder = dirs[-1]
    
    final_files = glob.glob(folder + "/report/*final.report")

    filename = final_files[-1]
    fin = open(filename, 'r')
    name = None
    area = None
    time = None
    leakage_power = None
    switching_power = None
    for line in fin.readlines():
        if "Design :" in line:
            name = line.strip().split()[-1]
        if "Cell Area:" in line:
            area = float(line.strip().split()[-1])
        if "Overall Compile Time:" in line:
            time = float(line.strip().split()[-1])

        if "Cell Leakage Power" in line:
            if "u" in line.split()[5]:
                leakage_power = float(line.split()[4]) * 10**-6
            elif "m" in line.split()[5]:
                leakage_power = float(line.split()[4]) * 10**-3
            elif "n" in line.split()[5]:
                leakage_power = float(line.split()[4]) * 10**-9

        if "Total Dynamic Power" in line:
            if "u" in line.split()[5]:
                switching_power = float(line.split()[4]) * 10**-6
            elif "m" in line.split()[5]:
                switching_power = float(line.split()[4]) * 10**-3
            elif "n" in line.split()[5]:
                switching_power = float(line.split()[4]) * 10**-9

    if name is None or area is None or time is None or leakage_power is None:
        breakpoint()

    assert name == mod, f"{name} {mod}"

    fin.close()

    return {"area": area, "compile_time": time, "leakage_power": leakage_power, "switching_power": switching_power}

def sort_nodes(graph):
    while not nx.is_directed_acyclic_graph(graph):
        graph = break_cycles(graph)

    return nx.topological_sort(graph)


def calculate_area_power(graph, node_info):
    area_set = set()
    total_area = 0
    total_leakage_power = 0
    total_switching_power = 0
    for node, data in graph.nodes(data=True):
        if is_module(data):
            bw = 1
            for pred in graph.predecessors(node):
                edge = graph.get_edge_data(pred, node)

                if 'label' in edge[0]:
                    bw = max(bw, int(edge[0]['label'].split("<")[1].split(">")[0]))

            l = get_module_from_label(data["label"])
            
            if l in node_info:
                total_area += node_info[l]["area"]
                total_leakage_power += node_info[l]["leakage_power"]
                total_switching_power += node_info[l]["switching_power"]
                area_set.add(l)

    compile_time = 0
    for s in area_set:
        print("Adding area of", s)
        compile_time += node_info[s]["compile_time"]

    print("Total Predictied Area:", total_area)
    print("Total Predictied leakage_power:", total_leakage_power)
    print("Total Predictied switching power:", total_switching_power)
    print("Total Predictied Compile Time:", compile_time)

def parse_switching():
    switching = {}

    result_dir = "/nobackup/melchert/qualcomm/hw/"
    dirs = glob.glob(result_dir + "nvdla_syn_*")
    dirs.sort()

    folder = dirs[-1]
    
    final_files = glob.glob(folder + "/report/*.switching")

    filename = final_files[-1]
    fin = open(filename, 'r')

    for line in fin.readlines():
        if "type = " in line:
            probability = float(line.split()[3][:-1])
            rate = float(line.split()[6][:-1])
            name = line.split()[0][1:-1]
            port_name = name.split("[")[0]
            if port_name not in switching:
                switching[port_name] = []
            switching[port_name].append((name, probability, rate))

    return switching

def run_synth(graph, folder):
    labels, iport_labels, oport_labels = get_port_labels(graph)

    nodes = sort_nodes(graph)

    node_info = {}
    switching_info = {}

    for n in nodes:
        data = graph.nodes(data=True)[n]
        if is_module(data):
            mod = get_module_from_label(data['label'])
            if not is_prim_mod(mod) and mod not in node_info:
                synth_time = node_synth(mod, folder, switching_info.get(n))
                node_info[mod] = parse_node_synth(mod)
                node_info[mod]["compile_time"] = synth_time
                switching = parse_switching()

                for source, sink, data in graph.out_edges(n, data=True):
                    
                    node_sink = sink
                    node_sink_edge = data

                    while node_sink not in iport_labels:
                        if len(list(graph.successors(node_sink))) == 0:
                            node_sink = None
                            break
                        assert len(list(graph.successors(node_sink))) == 1
                        succ = list(graph.successors(node_sink))[0]
                        node_sink_edge = graph.edges[node_sink, succ, 0]
                        node_sink = succ
                    
                    if node_sink == None:
                        continue
                    
                    if node_sink not in switching_info:
                        switching_info[node_sink] = []

                    try:
                        out_port_name = data['tailport'].split(":")[0]
                        in_port_name = node_sink_edge['headport'].split(":")[0]
                        oport = oport_labels[source][out_port_name]
                        iport = iport_labels[node_sink][in_port_name]

                        oswitching = switching[oport]
                    except:
                        breakpoint()
                    iswitching = []
                    for s in oswitching:
                        iswitching.append((s[0].replace(oport, iport), s[1], s[2]))

                    switching_info[node_sink].append(iswitching)

    calculate_area_power(graph, node_info)