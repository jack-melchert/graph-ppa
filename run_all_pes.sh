# bash analyze_nvdla.sh examples/nvdla/cmac NV_NVDLA_cmac | tee -a switching_power_flat_2_2.txt
# bash analyze_nvdla.sh examples/nvdla/cmac NV_NVDLA_CMAC_core | tee -a switching_power_flat_2_2.txt
# bash analyze_nvdla.sh examples/nvdla/sdp NV_NVDLA_sdp | tee -a switching_power_flat_2_2.txt
# bash analyze_nvdla.sh examples/nvdla/sdp NV_NVDLA_SDP_core | tee -a debug_sdp_core.txt
# bash analyze_nvdla.sh examples/nvdla/sdp NV_NVDLA_SDP_wdma | tee -a switching_power_flat_2_2.txt
# bash analyze_nvdla.sh examples/nvdla/pdp NV_NVDLA_pdp | tee -a switching_power_flat_2_2.txt
bash analyze_nvdla.sh examples/nvdla/pdp NV_NVDLA_PDP_core 
