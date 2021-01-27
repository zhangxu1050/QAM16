transcript on
if ![file isdirectory QamCarrier_iputf_libs] {
	file mkdir QamCarrier_iputf_libs
}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

###### Libraries for IPUTF cores 
###### End libraries for IPUTF cores 
###### MIF file copy and HDL compilation commands for IPUTF cores 


vcom "C:/Users/Administrator/Desktop/QamCarrierDD/fir_sim/dspba_library_package.vhd"                      
vcom "C:/Users/Administrator/Desktop/QamCarrierDD/fir_sim/dspba_library.vhd"                              
vcom "C:/Users/Administrator/Desktop/QamCarrierDD/fir_sim/auk_dspip_math_pkg_hpfir.vhd"                   
vcom "C:/Users/Administrator/Desktop/QamCarrierDD/fir_sim/auk_dspip_lib_pkg_hpfir.vhd"                    
vcom "C:/Users/Administrator/Desktop/QamCarrierDD/fir_sim/auk_dspip_avalon_streaming_controller_hpfir.vhd"
vcom "C:/Users/Administrator/Desktop/QamCarrierDD/fir_sim/auk_dspip_avalon_streaming_sink_hpfir.vhd"      
vcom "C:/Users/Administrator/Desktop/QamCarrierDD/fir_sim/auk_dspip_avalon_streaming_source_hpfir.vhd"    
vcom "C:/Users/Administrator/Desktop/QamCarrierDD/fir_sim/auk_dspip_roundsat_hpfir.vhd"                   
vlog "C:/Users/Administrator/Desktop/QamCarrierDD/fir_sim/altera_avalon_sc_fifo.v"                        
vcom "C:/Users/Administrator/Desktop/QamCarrierDD/fir_sim/fir_rtl_core.vhd"                               
vcom "C:/Users/Administrator/Desktop/QamCarrierDD/fir_sim/fir_ast.vhd"                                    
vcom "C:/Users/Administrator/Desktop/QamCarrierDD/fir_sim/fir.vhd"                                        
vcom "C:/Users/Administrator/Desktop/QamCarrierDD/fir_sim/fir_tb.vhd"                                     

vlog -vlog01compat -work work +incdir+C:/Users/Administrator/Desktop/QamCarrierDD {C:/Users/Administrator/Desktop/QamCarrierDD/nco.vo}
vlog -vlog01compat -work work +incdir+C:/Users/Administrator/Desktop/QamCarrierDD {C:/Users/Administrator/Desktop/QamCarrierDD/fir_lpf.vo}
vlog -vlog01compat -work work +incdir+C:/Users/Administrator/Desktop/QamCarrierDD/source {C:/Users/Administrator/Desktop/QamCarrierDD/source/DeCodeMap.v}
vlog -vlog01compat -work work +incdir+C:/Users/Administrator/Desktop/QamCarrierDD/source {C:/Users/Administrator/Desktop/QamCarrierDD/source/Decision.v}
vlog -vlog01compat -work work +incdir+C:/Users/Administrator/Desktop/QamCarrierDD {C:/Users/Administrator/Desktop/QamCarrierDD/mult18_16.v}
vlog -vlog01compat -work work +incdir+C:/Users/Administrator/Desktop/QamCarrierDD/source {C:/Users/Administrator/Desktop/QamCarrierDD/source/gnco.v}
vlog -vlog01compat -work work +incdir+C:/Users/Administrator/Desktop/QamCarrierDD/source {C:/Users/Administrator/Desktop/QamCarrierDD/source/FpgaGardner.v}
vlog -vlog01compat -work work +incdir+C:/Users/Administrator/Desktop/QamCarrierDD/source {C:/Users/Administrator/Desktop/QamCarrierDD/source/ErrorLp.v}
vlog -vlog01compat -work work +incdir+C:/Users/Administrator/Desktop/QamCarrierDD/source {C:/Users/Administrator/Desktop/QamCarrierDD/source/InterpolateFilter.v}
vlog -vlog01compat -work work +incdir+C:/Users/Administrator/Desktop/QamCarrierDD/source {C:/Users/Administrator/Desktop/QamCarrierDD/source/DD.v}
vlog -vlog01compat -work work +incdir+C:/Users/Administrator/Desktop/QamCarrierDD/source {C:/Users/Administrator/Desktop/QamCarrierDD/source/QamCarrier.v}
vlog -vlog01compat -work work +incdir+C:/Users/Administrator/Desktop/QamCarrierDD/source {C:/Users/Administrator/Desktop/QamCarrierDD/source/LoopFilter.v}
vlog -vlog01compat -work work +incdir+C:/Users/Administrator/Desktop/QamCarrierDD {C:/Users/Administrator/Desktop/QamCarrierDD/mult8_8.v}
vlog -vlog01compat -work work +incdir+C:/Users/Administrator/Desktop/QamCarrierDD {C:/Users/Administrator/Desktop/QamCarrierDD/BitSync.v}
vlog -vlog01compat -work work +incdir+C:/Users/Administrator/Desktop/QamCarrierDD {C:/Users/Administrator/Desktop/QamCarrierDD/pll.v}
vlog -vlog01compat -work work +incdir+C:/Users/Administrator/Desktop/QamCarrierDD/source {C:/Users/Administrator/Desktop/QamCarrierDD/source/BoardTst.v}
vlog -vlog01compat -work work +incdir+C:/Users/Administrator/Desktop/QamCarrierDD/db {C:/Users/Administrator/Desktop/QamCarrierDD/db/pll_altpll.v}
vlog -vlog01compat -work work +incdir+C:/Users/Administrator/Desktop/QamCarrierDD/simulation/modelsim {C:/Users/Administrator/Desktop/QamCarrierDD/simulation/modelsim/tb_BoardTst.v}

vlog -vlog01compat -work work +incdir+C:/Users/Administrator/Desktop/QamCarrierDD/simulation/modelsim {C:/Users/Administrator/Desktop/QamCarrierDD/simulation/modelsim/tb_BoardTst.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_BoardTst

add wave *
view structure
view signals
run -all
