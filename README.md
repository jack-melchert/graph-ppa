# graph-ppa
Pre-synthesis graph based power, performance, and area estimation tool.
### Requirements:
yosys: https://github.com/YosysHQ/yosys
sv2v: https://github.com/zachjs/sv2v (I've included a binary in rtl_to_graph/)

Python packages:
networkx
matplotlib
pygraphviz

Synopsys Design Compiler

### Setup:
Before running the tool, please open synthesis/config.sh and modify the following variables:
```
RTL_SEARCH_PATH - projects often have verilog libraries or low level circuits or memories, use this specify as many of these directories as you want. They will be included when running synthesis, so add things here if you get unresolved references.
DC_PATH - Path to design compiler
TARGET_LIB - Path to .db library
LINK_LIB - Verify that the default values here match the folder structure in your DC installation.
```
The rest of the variables in this file have defaults that should work in most cases. 
 
### Usage:
```
bash analyze_rtl.sh -flist path/to/filelist -design module_name [-sv2v] [-graph]
  -sv2v will use the sv2v tool to convert all source files into yosys compatible verilog, use this is yosys gives an error
  -graph will print a pdf of graph used during synthesis prediction, this may take a long time depending on the size of the design
```
The final area will be printed and the .dot file will be placed in ```outputs/graphs/<top level module>_flattened.dot```

### Example:
```
bash analyze_rtl.sh -flist examples/pe_c.flist -design PE_gen -sv2v
```
