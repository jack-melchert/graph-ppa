# graph-ppa
Pre-synthesis graph based power, performance, and area estimation tool.
### Requirements:
yosys: https://github.com/YosysHQ/yosys
sv2v: https://github.com/zachjs/sv2v (I've included a binary in rtl_to_graph/)

Python packages:
networkx
matplotlib
pygraphviz

### Usage:
```
# This will read in the .sv or .v file, load it into yosys, and generate a .dot representation in outputs/graphs/
bash design_to_pdf.sh <verilog file> <top level module> 
# This will run the graph based area prediction model on a .dot file
python graph_analysis/graph_ppa.py -d outputs/graphs/<top level module>.dot 
```
The final area will be printed and the .dot file will be placed in ```outputs/graphs/<top level module>_flattened.dot```

### Example:
```
bash design_to_pdf.sh examples/GcdUnit-demo.v GcdUnit
python graph_analysis/graph_ppa.py -d outputs/graphs/GcdUnit.dot 
```
