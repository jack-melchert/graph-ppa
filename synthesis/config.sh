# ===========================
# DESIGN RELATED VARIABLES
# ===========================


# Where do I find the RTL source verilog/system verilog files?
export RTL_SEARCH_PATH="/nobackup/melchert/qualcomm/hw/vmod/vlibs /nobackup/melchert/qualcomm/hw/vmod/rams/model/ /nobackup/melchert/qualcomm/hw/outdir/nv_full/vmod/rams/synth/"

# File extensions for source files...
export RTL_EXTENSIONS=".v .sv .gv"
export RTL_INCLUDE_EXTENSIONS=".vh .svh"

# Constraints and floorplans
export CONS="config"
export DEF="def"

# ===========================
# TOOL RELATED VARIABLES
# ===========================
# Design Compiler Installation - Where do I find the dc_shell executable
export DC_PATH="/cad/synopsys/syn/T-2022.03-SP4/amd64/syn/bin/"

# ===========================
# LIBRARY RELATED VARIABLES
# ===========================
export TARGET_LIB="/nobackup/melchert/mflowgen/adks/freepdk-45nm/view-tiny/stdcells.db"
export LINK_LIB="${DC_PATH}/../../../libraries/syn/dw_foundation.sldb ${DC_PATH}/../../../libraries/syn/gtech.db ${DC_PATH}/../../../libraries/syn/standard.sldb"
export MW_LIB=""
export TF_FILE=""
export TLUPLUS_FILE=""
export TLUPLUS_MAPPING_FILE=""
export MIN_ROUTING_LAYER=""
export MAX_ROUTING_LAYER=""
export HORIZONTAL_LAYERS=""
export VERTICAL_LAYERS=""
export WIRELOAD_MODEL_NAME=""
export WIRELOAD_MODEL_FILE=""
export DONT_USE_LIST=""

# ==========================
# MISCELLANEOUS VARIABLES 
#===========================
# Set host options in the DC session. 
export DC_NUM_CORES="16"

# Apply constraints to tighten CG enable paths to model post-CTS insertion delays
export TIGHTEN_CGE="0"

# Enable Area recovery (run optimize_netlist -area)
export AREA_RECOVERY="1"

# Number of incremental recompile loops
export INCREMENTAL_RECOMPILE_COUNT="1"

# Some other variables
export CLK_GATING_CELL=""
export DONT_UNGROUP_LIST=""

# For Job management
export COMMAND_PREFIX=""


# ===========================
# DYNAMIC VARIABLES
# ===========================
# These will be set during runtime
export TOP_NAMES="SHR"
export RTL_VERILOG="/nobackup/melchert/qualcomm/graph-ppa/examples/pe_c.v "
export EXTRA_RTL=""
export RTL_INCLUDE_SEARCH_PATH="None"
