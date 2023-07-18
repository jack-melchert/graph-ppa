# bash analyze_rtl.sh -flist examples/cmac.f -design NV_NVDLA_cmac -include /aha/graph-ppa/examples/nvdla/include/ -libs /aha/graph-ppa/examples/nvdla/libs/ | tee NV_NVDLA_cmac.log
bash analyze_rtl.sh -flist examples/sdp.f -design NV_NVDLA_sdp -include /aha/graph-ppa/examples/nvdla/include/ -libs /aha/graph-ppa/examples/nvdla/libs/ | tee NV_NVDLA_sdp.log
# bash analyze_rtl.sh -flist examples/sdp.f -design NV_NVDLA_SDP_core -include /aha/graph-ppa/examples/nvdla/include/ -libs /aha/graph-ppa/examples/nvdla/libs/ | tee NV_NVDLA_SDP_core.log
# bash analyze_rtl.sh -flist examples/sdp.f -design NV_NVDLA_SDP_wdma -include /aha/graph-ppa/examples/nvdla/include/ -libs /aha/graph-ppa/examples/nvdla/libs/ | tee NV_NVDLA_SDP_wdma.log
bash analyze_rtl.sh -flist examples/pdp.f -design NV_NVDLA_pdp -include /aha/graph-ppa/examples/nvdla/include/ -libs /aha/graph-ppa/examples/nvdla/libs/ | tee NV_NVDLA_pdp.log
bash analyze_rtl.sh -flist examples/pdp.f -design NV_NVDLA_PDP_core -include /aha/graph-ppa/examples/nvdla/include/ -libs /aha/graph-ppa/examples/nvdla/libs/ | tee NV_NVDLA_PDP_core.log
