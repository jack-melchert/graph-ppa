usage ()
{
    echo Usage: $0 -flist filelist -design module_name -flatten flatten_level -include include/path [-sv2v] [-graph];
    exit 1;
}

SV2V=false
GRAPH=false

while [ $# -gt 0 ]
do
  case $1 in
      -flist)
          shift
          FLIST="$1" ;;
      -design)
          shift
          DESIGN_TOP="$1" ;;
      -flatten)
          shift
          FLATTEN="$1" ;;
      -include)
          shift
          INCLUDE="$1" ;;
      -sv2v)
          SV2V=true ;;
      -graph)
          GRAPH=true ;;
        *)
          echo Error: unrecognized argument: $1
          usage ;; 
    esac
  shift
done

if [ -z "$FLIST" ] || [ -z "$DESIGN_TOP" ] ; then
    echo "[ERROR]: Please provide a valid flist and design name"
    usage
fi

if [ -z "$FLATTEN" ] ; then
    FLATTEN=0
fi

if [ -z "$INCLUDE" ] ; then
    INCLUDE_I=""
    INCLUDE_i=""
else
    INCLUDE_I="-I "
    INCLUDE_i="-i "
fi

mkdir -p outputs
mkdir -p outputs/pdfs
mkdir -p outputs/graphs
mkdir -p outputs/synth
mkdir -p outputs/verilog

sed "s/hier_top/$DESIGN_TOP/g" rtl_to_graph/to_graph.ys > rtl_to_graph/${DESIGN_TOP}_to_graph.ys

while IFS= read -r line || [[ -n "$line" ]]; do
  if $SV2V; then
    new_file=$(basename -sh $line)
    echo "Running sv2v on $line"
    ./rtl_to_graph/sv2v $line $INCLUDE_I $INCLUDE > outputs/verilog/${new_file}
    sed -i.old "1s;^;read_verilog -sv $INCLUDE_I $INCLUDE outputs/verilog/${new_file} \n;" rtl_to_graph/${DESIGN_TOP}_to_graph.ys
  else
    sed -i.old "1s;^;read_verilog -sv $INCLUDE_I $INCLUDE ${line} \n;" rtl_to_graph/${DESIGN_TOP}_to_graph.ys
  fi
done < $FLIST

echo "Running yosys"
yosys rtl_to_graph/${DESIGN_TOP}_to_graph.ys > outputs/yosys_log.txt
rm rtl_to_graph/${DESIGN_TOP}_to_graph.ys

gvpack -u outputs/graphs/${DESIGN_TOP}.dot -o outputs/graphs/${DESIGN_TOP}_new.dot
sed -i 's/subgraph /subgraph cluster_/g' outputs/graphs/${DESIGN_TOP}_new.dot
sed -i 's/subgraph cluster_"/subgraph "cluster_/g' outputs/graphs/${DESIGN_TOP}_new.dot
mv outputs/graphs/${DESIGN_TOP}_new.dot outputs/graphs/${DESIGN_TOP}.dot

python graph_analysis/graph_ppa.py -g outputs/graphs/${DESIGN_TOP}.dot -l $FLIST $INCLUDE_i $INCLUDE -f $FLATTEN

if $GRAPH; then
  echo "Printing graph to outputs/pdfs/${DESIGN_TOP}_flattened.pdf"
  dot -Tpdf outputs/graphs/${DESIGN_TOP}_flattened.dot > outputs/pdfs/${DESIGN_TOP}_flattened.pdf
fi
