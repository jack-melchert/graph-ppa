# graph-ppa
Pre-synthesis graph based power, performance, and area estimation tool.

### Usage:
```
# This will read in the .sv or .v file, load it into yosys, and generate a .dot representation in outputs/graphs/
bash design_to_pdf.sh <verilog file> <top level module> 
# This will run the graph based area prediction model on a .dot file
python graph_analysis/graph_ppa.py -d outputs/graphs/<top level module>.dot 
```

### Example:
```
bash design_to_pdf.sh examples/GcdUnit-demo.v GcdUnit
python graph_analysis/graph_ppa.py -d outputs/graphs/GcdUnit.dot 
```
