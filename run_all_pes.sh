
for PE in pe_ml pe_ip2 pe_ip3 pe_c pe_ip pe_h pe_u pe_g 
do
    OUTPUT=$(bash analyze_rtl.sh examples/$PE.v PE_gen 2>&1 |  tail -1)
    echo $OUTPUT
done