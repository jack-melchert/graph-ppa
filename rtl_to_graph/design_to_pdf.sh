FILENAME=$1
DESIGN_TOP=$2

./rtl_to_graph/sv2v $FILENAME > outputs/sv2v_out.v

sed "s/hier_top/$DESIGN_TOP/g" rtl_to_graph/to_graph.ys > rtl_to_graph/${DESIGN_TOP}_to_graph.ys

yosys rtl_to_graph/${DESIGN_TOP}_to_graph.ys > outputs/yosys_log.txt
rm rtl_to_graph/${DESIGN_TOP}_to_graph.ys

dot -Tpdf outputs/graphs/${DESIGN_TOP}.dot > outputs/pdfs/${DESIGN_TOP}.pdf
