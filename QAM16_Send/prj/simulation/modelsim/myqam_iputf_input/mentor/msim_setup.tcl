
file copy -force C:/class/class36/prj/ip/nco/simulation/submodules/nco_nco_ii_0_sin.hex ./
file copy -force C:/class/class36/prj/ip/nco/simulation/submodules/nco_nco_ii_0_cos.hex ./

vlog "C:/class/class36/prj/ip/nco/simulation/submodules/mentor/sid_2c_1p.v"                -work nco_ii_0
vlog "C:/class/class36/prj/ip/nco/simulation/submodules/mentor/asj_nco_mob_rw.v"           -work nco_ii_0
vlog "C:/class/class36/prj/ip/nco/simulation/submodules/mentor/asj_gar.v"                  -work nco_ii_0
vlog "C:/class/class36/prj/ip/nco/simulation/submodules/mentor/asj_nco_isdr.v"             -work nco_ii_0
vlog "C:/class/class36/prj/ip/nco/simulation/submodules/mentor/asj_nco_apr_dxx.v"          -work nco_ii_0
vlog "C:/class/class36/prj/ip/nco/simulation/submodules/mentor/segment_arr_tdl.v"          -work nco_ii_0
vlog "C:/class/class36/prj/ip/nco/simulation/submodules/mentor/segment_sel.v"              -work nco_ii_0
vlog "C:/class/class36/prj/ip/nco/simulation/submodules/mentor/asj_dxx_g.v"                -work nco_ii_0
vlog "C:/class/class36/prj/ip/nco/simulation/submodules/mentor/asj_dxx.v"                  -work nco_ii_0
vlog "C:/class/class36/prj/ip/nco/simulation/submodules/mentor/asj_xnqg.v"                 -work nco_ii_0
vlog "C:/class/class36/prj/ip/nco/simulation/submodules/mentor/asj_nco_as_m_cen.v"         -work nco_ii_0
vlog "C:/class/class36/prj/ip/nco/simulation/submodules/mentor/asj_altqmcpipe.v"           -work nco_ii_0
vlog "C:/class/class36/prj/ip/nco/simulation/submodules/nco_nco_ii_0.v"                    -work nco_ii_0
vlog "C:/class/class36/prj/ip/nco/simulation/nco.v"                                                      
vcom "C:/class/class36/prj/ip/fir_lpf_sim/dspba_library_package.vhd"                                     
vcom "C:/class/class36/prj/ip/fir_lpf_sim/dspba_library.vhd"                                             
vcom "C:/class/class36/prj/ip/fir_lpf_sim/auk_dspip_math_pkg_hpfir.vhd"                                  
vcom "C:/class/class36/prj/ip/fir_lpf_sim/auk_dspip_lib_pkg_hpfir.vhd"                                   
vcom "C:/class/class36/prj/ip/fir_lpf_sim/auk_dspip_avalon_streaming_controller_hpfir.vhd"               
vcom "C:/class/class36/prj/ip/fir_lpf_sim/auk_dspip_avalon_streaming_sink_hpfir.vhd"                     
vcom "C:/class/class36/prj/ip/fir_lpf_sim/auk_dspip_avalon_streaming_source_hpfir.vhd"                   
vcom "C:/class/class36/prj/ip/fir_lpf_sim/auk_dspip_roundsat_hpfir.vhd"                                  
vlog "C:/class/class36/prj/ip/fir_lpf_sim/altera_avalon_sc_fifo.v"                                       
vcom "C:/class/class36/prj/ip/fir_lpf_sim/fir_lpf_rtl_core.vhd"                                          
vcom "C:/class/class36/prj/ip/fir_lpf_sim/fir_lpf_ast.vhd"                                               
vcom "C:/class/class36/prj/ip/fir_lpf_sim/fir_lpf.vhd"                                                   
vcom "C:/class/class36/prj/ip/fir_lpf_sim/fir_lpf_tb.vhd"                                                
