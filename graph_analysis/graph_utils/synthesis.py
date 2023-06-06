import networkx as nx
from graph_utils.utils import *
import subprocess
import glob
import time
import os
import json

result_dir = os.path.dirname(os.path.realpath(__file__)) + "/../../outputs/synth/"


def write_switching(switching, filename):
    fout = open(filename, "w")

    lines = ""
    if switching is not None:
        for port in switching:
            for bit_port in port:
                lines += f"set_switching_activity {bit_port[0]} -static_probability {bit_port[1]} -toggle_rate {bit_port[2]}\n"

    fout.write(lines)

    fout.close()


def node_synth(node, switching, flist, include, switching_temp):
    print("Running synth for", node)

    top_level_path = os.path.dirname(os.path.realpath(__file__)) + "/../.."

    synth_script_filename = top_level_path + "/synthesis/config.sh"

    flist_in = open(flist, "r")

    rtl_files = ""

    for f in flist_in.readlines():
        rtl_files += f.strip() + " "

    # Writing node we are currently synthing to synth script
    fin = open(synth_script_filename, "r")
    new_synth_script = fin.readlines()
    top_names = f'export TOP_NAMES="{node}"\n'
    rtl_verilog = f'export RTL_VERILOG="{rtl_files}"\n'
    rtl_include_path = f'export RTL_INCLUDE_SEARCH_PATH="{include}"\n'

    for idx, line in enumerate(new_synth_script):
        if "export TOP_NAMES=" in line:
            new_synth_script[idx] = top_names
        elif "export RTL_VERILOG=" in line:
            new_synth_script[idx] = rtl_verilog
        elif "export RTL_INCLUDE_SEARCH_PATH=" in line:
            new_synth_script[idx] = rtl_include_path
    fin.close()

    fout = open(synth_script_filename, "w")
    fout.writelines(new_synth_script)
    fout.close()

    switching_filename = top_level_path + "/synthesis/set_switching.tcl"

    switch_names = []
    if switching is not None:
        for x in switching:
            for y in x:
                switch_names.append(y[0])

    new_switching = []
    for n,v in switching_temp.items():
        new_switching.append(v)

    final_switching = []
    for x in new_switching:
        for y in x:
            if y[0] in switch_names:
                final_switching.append([y])

    # if len(final_switching) > 0:
    #     breakpoint()

    write_switching(final_switching, switching_filename)


    # subprocess.check_call(["cp", "/nobackup/melchert/qualcomm/graph-ppa/switching/"+name+".switching", switching_filename])

    # Run synthesis
    synth_command = ["bash", top_level_path + "/synthesis/launch_synth.sh"]

    start = time.time()
    subprocess.check_call(synth_command, cwd="/nobackup/melchert/qualcomm/hw")
    end = time.time()

    return end - start


def parse_node_synth(mod, filename):

    fin = open(filename, "r")
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
            if "m" in line.split()[5]:
                leakage_power = float(line.split()[4]) * 10**-3
            elif "u" in line.split()[5]:
                leakage_power = float(line.split()[4]) * 10**-6
            elif "n" in line.split()[5]:
                leakage_power = float(line.split()[4]) * 10**-9
            elif "p" in line.split()[5]:
                leakage_power = float(line.split()[4]) * 10**-12
            elif "f" in line.split()[5]:
                leakage_power = float(line.split()[4]) * 10**-15
            elif line.split()[5].strip() == "W":
                leakage_power = float(line.split()[4])
            else:
                assert False, f"Did not recognize leakage power result in {line}"

        if "Total Dynamic Power" in line:
            if "m" in line.split()[5]:
                switching_power = float(line.split()[4]) * 10**-3
            elif "u" in line.split()[5]:
                switching_power = float(line.split()[4]) * 10**-6
            elif "n" in line.split()[5]:
                switching_power = float(line.split()[4]) * 10**-9
            elif "p" in line.split()[5]:
                switching_power = float(line.split()[4]) * 10**-12
            elif "f" in line.split()[5]:
                switching_power = float(line.split()[4]) * 10**-15
            elif line.split()[5].strip() == "W":
                switching_power = float(line.split()[4])
            else:
                assert False, f"Did not recognize dynamic power result in {line}"

    if (
        name is None
        or area is None
        or time is None
        or leakage_power is None
        or switching_power is None
    ):
        assert False, f"Synthesis reports are not complete for node {mod}"

    assert name == mod, f"{name} did not match {mod}"

    fin.close()

    return {
        "area": area,
        "compile_time": time,
        "leakage_power": leakage_power,
        "switching_power": switching_power,
    }


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

                if "label" in edge[0]:
                    bw = max(bw, int(edge[0]["label"].split("<")[1].split(">")[0]))

            l = get_module_from_label(data["label"])

            if node in node_info:
                total_area += node_info[node]["area"]
                total_leakage_power += node_info[node]["leakage_power"]
                if node_info[node]["switching_power"] is None:
                    node_info[node]["switching_power"] = 0.0
                total_switching_power += node_info[node]["switching_power"]
                area_set.add(node)

    compile_time = 0
    for s in area_set:
        print("Adding area of", s)
        compile_time += node_info[s]["compile_time"]

    print("Total Predictied Area:", total_area)
    print("Total Predictied leakage_power:", total_leakage_power)
    print("Total Predictied switching power:", total_switching_power)
    print("Total Predictied Compile Time:", compile_time)


def parse_switching(filename):
    switching = {}

    fin = open(filename, "r")

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


def run_synth(graph, flist, include):
    labels, iport_labels, oport_labels = get_port_labels(graph)

    nodes = sort_nodes(graph)

    node_info = {}
    switching_info = {}

    for n in nodes:
        data = graph.nodes(data=True)[n]
        if is_module(data):
            mod = get_module_from_label(data["label"])
            if not is_prim_mod(mod) and n not in node_info:
                switching_temp = parse_switching("/nobackup/melchert/qualcomm/graph-ppa/switching/"+name+".switching")

                synth_time = node_synth(mod, switching_info.get(n), flist, include, switching_temp)

                dirs = glob.glob(result_dir + "synth_*")
                dirs.sort()
                folder = dirs[-1]
                synth_file = glob.glob(folder + "/report/*final.report")[-1]
                switching_file = glob.glob(folder + "/report/*.switching")[-1]

                node_info[n] = parse_node_synth(mod, synth_file)
                node_info[n]["compile_time"] = synth_time
                switching = parse_switching(switching_file)

                for source, sink, data in graph.out_edges(n, data=True):

                    node_sink = sink
                    node_sink_edge = data

                    while node_sink not in iport_labels:
                        if len(list(graph.successors(node_sink))) == 0:
                            node_sink = None
                            break
                        assert len(list(graph.successors(node_sink))) > 0, breakpoint()
                        succ = list(graph.successors(node_sink))[0]
                        node_sink_edge = graph.edges[node_sink, succ, 0]
                        node_sink = succ

                    if node_sink == None:
                        continue

                    if node_sink not in switching_info:
                        switching_info[node_sink] = []

                    out_port_name = data["tailport"].split(":")[0]
                    in_port_name = node_sink_edge["headport"].split(":")[0]
                    oport = oport_labels[source][out_port_name]
                    iport = iport_labels[node_sink][in_port_name]

                    oswitching = switching[oport]

                    iswitching = []
                    for s in oswitching:
                        iswitching.append((s[0].replace(oport, iport), s[1], s[2]))

                    switching_info[node_sink].append(iswitching)

    print(node_info)
    node_info_fout = open("node_info.txt", "w")
    node_info_fout.write(json.dumps(node_info))
    node_info_fout.close()
    calculate_area_power(graph, node_info)
