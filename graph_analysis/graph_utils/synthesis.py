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

def write_timing(graph, node, iport_labels, oport_labels, filename):

    fout = open(filename, "w")

    lines = ""

    for source, sink, data in graph.in_edges(node, data=True):
        in_port_name = data["headport"].split(":")[0]
        iport = iport_labels[sink][in_port_name]
        lines += f"report_timing -from {iport} -path_type short\n"

    for source, sink, data in graph.out_edges(node, data=True):
        out_port_name = data["tailport"].split(":")[0]
        oport = oport_labels[source][out_port_name]
        lines += f"report_timing -to {oport} -path_type short\n"
        
    fout.write(lines)
    print(lines)
    fout.close()


def node_synth(top_level_path, node, switching, flist, include):
    print("Running synth for", node)

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
    write_switching(switching, switching_filename)

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


def calculate_area_power(graph, node_info, iport_labels, oport_labels):
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

            if l in node_info:
                total_area += node_info[l]["area"]
                total_leakage_power += node_info[l]["leakage_power"]
                if node_info[l]["switching_power"] is None:
                    node_info[l]["switching_power"] = 0.0
                total_switching_power += node_info[l]["switching_power"]
                area_set.add(l)

    compile_time = 0
    for s in area_set:
        print("Adding area of", s)
        compile_time += node_info[s]["compile_time"]

    for n,v in node_info.items():
        print(n, v["timing"])
    

    max_timing = 0
    for n, data in graph.nodes(data=True):
        if is_module(data):
            l = get_module_from_label(data["label"])

            if l not in node_info:
                continue

            print(l)

            for source, sink, data in graph.in_edges(n, data=True):
                in_port_name = data["headport"].split(":")[0]
                iport = iport_labels[sink][in_port_name]

                if iport in node_info[l]['timing']:
                    print(f"\tinput {iport} : {node_info[l]['timing'][iport]}ns")
                    max_timing = max(max_timing, node_info[l]['timing'][iport])
                else:
                    print(f"\tinput {iport} not found")

            for source, sink, data in graph.out_edges(n, data=True):

                node_sink = sink
                node_sink_edge = data

                while node_sink not in iport_labels:
                    if len(list(graph.successors(node_sink))) == 0:
                        node_sink = None    
                        break
                    succ = list(graph.successors(node_sink))[0]
                    node_sink_edge = graph.edges[node_sink, succ, 0]
                    node_sink = succ

                if node_sink == None:
                    continue

                sink_l = get_module_from_label(graph.nodes(data=True)[node_sink]['label'])


                out_port_name = data["tailport"].split(":")[0]
                in_port_name = node_sink_edge["headport"].split(":")[0]
                oport = oport_labels[source][out_port_name]
                iport = iport_labels[node_sink][in_port_name]

                if sink_l not in node_info:
                    print(f"\t{oport} : {node_info[l]['timing'][oport]}ns")
                    max_timing = max(max_timing, node_info[l]['timing'][oport])
                else:
                    if iport in node_info[sink_l]['timing']:
                        print(f"\t{l}:{oport} -> {sink_l}:{iport} : {node_info[l]['timing'][oport]}ns + {node_info[sink_l]['timing'][iport]}ns = {node_info[l]['timing'][oport] + node_info[sink_l]['timing'][iport]}ns")
                        max_timing = max(max_timing, node_info[l]['timing'][oport] + node_info[sink_l]['timing'][iport])
                    else:
                        print(f"\t{iport} not in node_info for {sink_l}")



    total_area = "{:.2f}".format(total_area)
    print("Total Predictied Area:", total_area)

    total_leakage_power = "{:.6f}".format(total_leakage_power)
    print("Total Predictied Leakage Power:", total_leakage_power)

    total_switching_power = "{:.6f}".format(total_switching_power)
    print("Total Predictied Switching Power:", total_switching_power)

    max_timing = "{:.2f}".format(max_timing)
    print("Predictied Clock Period:", max_timing)
    
    compile_time = "{:.2f}".format(compile_time)
    print("Total Predictied Compile Time:", compile_time)


def parse_timing(filename):
    timing = {}

    fin = open(filename, "r")

    for line in fin.readlines():
        if "report_timing" in line:
            split = line.split()
            source = split[2]
            if source not in timing:
                timing[source] = 0.0
        elif "data arrival time" in line:
            split = line.split()
            timing[source] = float(split[3])

    return timing

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
    top_level_path = os.path.dirname(os.path.realpath(__file__)) + "/../.."
    labels, iport_labels, oport_labels = get_port_labels(graph)

    nodes = sort_nodes(graph)

    node_info = {}
    switching_info = {}

    for n in nodes:
        data = graph.nodes(data=True)[n]
        if is_module(data):
            mod = get_module_from_label(data["label"])
            if not is_prim_mod(mod) and mod not in node_info:
                print("Synthesizing", mod)

                write_timing(graph, n, iport_labels, oport_labels, top_level_path + "/synthesis/report_timing.tcl")
                
                synth_time = node_synth(top_level_path, mod, switching_info.get(n), flist, include)

                dirs = glob.glob(result_dir + "synth_*")
                dirs.sort()
                folder = dirs[-1]
                synth_file = glob.glob(folder + "/report/*final.report")[-1]
                switching_file = glob.glob(folder + "/report/*.switching")[-1]
                timing_file = glob.glob(folder + "/report/*.timing")[-1]

                node_info[mod] = parse_node_synth(mod, synth_file)
                node_info[mod]["compile_time"] = synth_time

                node_info[mod]["timing"] = parse_timing(timing_file)

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
    calculate_area_power(graph, node_info, iport_labels, oport_labels)
