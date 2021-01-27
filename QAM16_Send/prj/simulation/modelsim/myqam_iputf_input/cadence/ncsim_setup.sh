
cp -f C:/class/class36/prj/ip/nco/simulation/submodules/nco_nco_ii_0_sin.hex ./
cp -f C:/class/class36/prj/ip/nco/simulation/submodules/nco_nco_ii_0_cos.hex ./

ncvlog      "C:/class/class36/prj/ip/nco/simulation/submodules/nco_nco_ii_0.v"                    -work nco_ii_0 -cdslib <<nco_ii_0>>
ncvlog      "C:/class/class36/prj/ip/nco/simulation/nco.v"                                                                           
ncvhdl -v93 "C:/class/class36/prj/ip/fir_lpf_sim/dspba_library_package.vhd"                                                          
ncvhdl -v93 "C:/class/class36/prj/ip/fir_lpf_sim/dspba_library.vhd"                                                                  
ncvhdl -v93 "C:/class/class36/prj/ip/fir_lpf_sim/auk_dspip_math_pkg_hpfir.vhd"                                                       
ncvhdl -v93 "C:/class/class36/prj/ip/fir_lpf_sim/auk_dspip_lib_pkg_hpfir.vhd"                                                        
ncvhdl -v93 "C:/class/class36/prj/ip/fir_lpf_sim/auk_dspip_avalon_streaming_controller_hpfir.vhd"                                    
ncvhdl -v93 "C:/class/class36/prj/ip/fir_lpf_sim/auk_dspip_avalon_streaming_sink_hpfir.vhd"                                          
ncvhdl -v93 "C:/class/class36/prj/ip/fir_lpf_sim/auk_dspip_avalon_streaming_source_hpfir.vhd"                                        
ncvhdl -v93 "C:/class/class36/prj/ip/fir_lpf_sim/auk_dspip_roundsat_hpfir.vhd"                                                       
ncvlog      "C:/class/class36/prj/ip/fir_lpf_sim/altera_avalon_sc_fifo.v"                                                            
ncvhdl -v93 "C:/class/class36/prj/ip/fir_lpf_sim/fir_lpf_rtl_core.vhd"                                                               
ncvhdl -v93 "C:/class/class36/prj/ip/fir_lpf_sim/fir_lpf_ast.vhd"                                                                    
ncvhdl -v93 "C:/class/class36/prj/ip/fir_lpf_sim/fir_lpf.vhd"                                                                        
ncvhdl -v93 "C:/class/class36/prj/ip/fir_lpf_sim/fir_lpf_tb.vhd"                                                                     
