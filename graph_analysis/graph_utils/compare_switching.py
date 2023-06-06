import glob
import os



names = ["NV_NVDLA_CMAC_CORE_slcg_19", "NV_NVDLA_CMAC_CORE_slcg_18", "NV_NVDLA_CMAC_CORE_slcg_9", "NV_NVDLA_CMAC_CORE_slcg_17", "NV_NVDLA_CMAC_CORE_slcg_16", "NV_NVDLA_CMAC_CORE_slcg_15", "NV_NVDLA_CMAC_CORE_slcg_14", "NV_NVDLA_CMAC_CORE_slcg_13", "NV_NVDLA_CMAC_CORE_slcg_12", "NV_NVDLA_CMAC_CORE_slcg_11", "NV_NVDLA_CMAC_CORE_slcg_10", "NV_NVDLA_CMAC_CORE_rt_in", "NV_NVDLA_CMAC_CORE_active", "NV_NVDLA_CMAC_CORE_mac_7", "NV_NVDLA_CMAC_CORE_rt_out", "NV_NVDLA_CMAC_CORE_cfg", "NV_NVDLA_CMAC_CORE_slcg_8", "NV_NVDLA_CMAC_CORE_slcg_7", "NV_NVDLA_CMAC_CORE_slcg_6", "NV_NVDLA_CMAC_CORE_slcg_5", "NV_NVDLA_CMAC_CORE_slcg_4", "NV_NVDLA_CMAC_CORE_slcg_3", "NV_NVDLA_CMAC_CORE_slcg_2", "NV_NVDLA_CMAC_CORE_slcg_1", "NV_NVDLA_CMAC_CORE_slcg_0", "NV_NVDLA_CMAC_CORE_mac_6", "NV_NVDLA_CMAC_CORE_mac_5", "NV_NVDLA_CMAC_CORE_mac_4", "NV_NVDLA_CMAC_CORE_mac_3", "NV_NVDLA_CMAC_CORE_mac_2", "NV_NVDLA_CMAC_CORE_mac_1", "NV_NVDLA_CMAC_CORE_mac_0"]

result_dir = os.path.dirname(os.path.realpath(__file__)) + "/../../outputs/synth/"

names.reverse()

dirs = glob.glob(result_dir + "synth_*")
dirs.sort()
dirs.reverse()

names_to_switching = {}

for idx, name in enumerate(names):
    folder = dirs[idx]
    switching_file = glob.glob(folder + "/scripts/set_switching.tcl")[-1]

    names_to_switching[name] = {}

    fin = open(switching_file, "r")

    for line in fin.readlines():
        parsed = line.strip().split(" ")
        names_to_switching[name][parsed[1]] = (float(parsed[3]), float(parsed[5]))


result_dir = os.path.dirname(os.path.realpath(__file__)) + "/../../outputs/synth/"

# names.reverse()

dirs = glob.glob(result_dir + "synth_20230509*")
dirs.sort()
dirs.reverse()

names_to_switching2 = {}

for idx, name in enumerate(names):
    folder = dirs[idx]
    print(folder)
    switching_file = glob.glob(folder + "/scripts/set_switching.tcl")[-1]

    names_to_switching2[name] = {}

    fin = open(switching_file, "r")

    for line in fin.readlines():
        parsed = line.strip().split(" ")
        names_to_switching2[name][parsed[1]] = (float(parsed[3]), float(parsed[5]))

for k,v in names_to_switching.items():
    prob_avg = 0
    tog_avg = 0
    for kk,vv in v.items():
        truth = vv
        pred = names_to_switching2[k][kk]
        prob_avg += (abs(truth[0] - pred[0]))
        tog_avg += (abs(truth[1] - pred[1]))

    if len(v) > 0:
        print(k)
        print(prob_avg/len(v))
        print(tog_avg/len(v), "\n")