FILENAME=$1
DESIGN_TOP=$2

mkdir -p outputs
mkdir -p outputs/pdfs
mkdir -p outputs/graphs

echo "Running sv2v"
./rtl_to_graph/sv2v $FILENAME > outputs/sv2v_out.v

sed "s/hier_top/$DESIGN_TOP/g" rtl_to_graph/to_graph.ys > rtl_to_graph/${DESIGN_TOP}_to_graph.ys

echo "Running yosys"
yosys rtl_to_graph/${DESIGN_TOP}_to_graph.ys > outputs/yosys_log.txt
rm rtl_to_graph/${DESIGN_TOP}_to_graph.ys

echo "Graph printing for hierarchical graph"
gvpack -u outputs/graphs/${DESIGN_TOP}.dot -o outputs/graphs/${DESIGN_TOP}_new.dot
sed -i 's/subgraph /subgraph cluster_/g' outputs/graphs/${DESIGN_TOP}_new.dot
sed -i 's/subgraph cluster_"/subgraph "cluster_/g' outputs/graphs/${DESIGN_TOP}_new.dot
mv outputs/graphs/${DESIGN_TOP}_new.dot outputs/graphs/${DESIGN_TOP}.dot
dot -Tpdf outputs/graphs/${DESIGN_TOP}.dot  > outputs/pdfs/${DESIGN_TOP}.pdf

echo "Graph printing for aig graph"
gvpack -u outputs/graphs/${DESIGN_TOP}_aig.dot -o outputs/graphs/${DESIGN_TOP}_aig_new.dot
sed -i 's/subgraph /subgraph cluster_/g' outputs/graphs/${DESIGN_TOP}_aig_new.dot
sed -i 's/subgraph cluster_"/subgraph "cluster_/g' outputs/graphs/${DESIGN_TOP}_aig_new.dot
mv outputs/graphs/${DESIGN_TOP}_aig_new.dot outputs/graphs/${DESIGN_TOP}_aig.dot
# dot -Tpdf outputs/graphs/${DESIGN_TOP}_aig.dot > outputs/pdfs/${DESIGN_TOP}_aig.pdf
