FILENAME=$1
DESIGN_TOP=$2

mkdir -p outputs
mkdir -p outputs/pdfs
mkdir -p outputs/graphs

sed "s/hier_top/$DESIGN_TOP/g" rtl_to_graph/nvdla.ys > rtl_to_graph/${DESIGN_TOP}_to_graph.ys

for i in `ls $FILENAME` ; do sed -i.old "1s;^;read_verilog -sv -I examples/nvdla/include $FILENAME/$i \n;" rtl_to_graph/${DESIGN_TOP}_to_graph.ys ; done

echo "Running yosys"
yosys rtl_to_graph/${DESIGN_TOP}_to_graph.ys > outputs/yosys_log.txt
rm rtl_to_graph/${DESIGN_TOP}_to_graph.ys

echo "Graph printing for hierarchical graph"
gvpack -u outputs/graphs/${DESIGN_TOP}.dot -o outputs/graphs/${DESIGN_TOP}_new.dot
sed -i 's/subgraph /subgraph cluster_/g' outputs/graphs/${DESIGN_TOP}_new.dot
sed -i 's/subgraph cluster_"/subgraph "cluster_/g' outputs/graphs/${DESIGN_TOP}_new.dot
mv outputs/graphs/${DESIGN_TOP}_new.dot outputs/graphs/${DESIGN_TOP}.dot

python graph_analysis/graph_ppa.py -d outputs/graphs/${DESIGN_TOP}.dot

# dot -Tpdf outputs/graphs/${DESIGN_TOP}_flattened.dot > outputs/pdfs/${DESIGN_TOP}_flattened2.pdf



