`timescale 1ns/1ns

module fir (
	input 						r_CLK,
	input							r_Rst,
	output	signed [18:0]	di_lpf,
	output	signed [18:0]	dq_lpf,
	output						s_validi,
	output						s_validq,
	output			 [1:0]	s_errori,
	output			 [1:0]	s_errorq
	);
	
	
	
	wire						Bit	;
	wire			 [3:0]	code	;
	wire	signed [2:0]	di		;
	wire	signed [2:0]	dq		;
	//信源模块例化
	source	source(
					.CLK(r_CLK),
					.Rst(r_Rst),
					.Bit(Bit)
					);
	//转换模块例化
	BitTrans 	BitTrans(
						.rst(r_Rst)	,
						.clk(r_CLK)	,
						.din(Bit)	,
						.code(code)
						);
	//映射模块例化
	CodeMap CodeMap(
					.rst(r_Rst),
					.clk(r_CLK),
					.din(code),
					.I(di),
					.Q(dq)
					); 
	//fir模块例化
	fir_lpf fir_lpfi(
		.clk					(r_CLK),             //clk.clk
		.reset_n				(!r_Rst),          	// rst.reset_n
		.ast_sink_data		(di),      				//   avalon_streaming_sink.data
		.ast_sink_valid	(1'b1),    				//                        .valid
		.ast_sink_error	(2'd0),    				//                        .error
		.ast_source_data	(di_lpf),  				// avalon_streaming_source.data
		.ast_source_valid	(s_validi), 			//                        .valid
		.ast_source_error	(s_errori)  			//                        .error
	);
	
	fir_lpf fir_lpfq(
		.clk					(r_CLK),             //clk.clk
		.reset_n				(!r_Rst),          	// rst.reset_n
		.ast_sink_data		(dq),      				//   avalon_streaming_sink.data
		.ast_sink_valid	(1'b1),    				//                        .valid
		.ast_sink_error	(2'd0),    				//                        .error
		.ast_source_data	(dq_lpf),  				// avalon_streaming_source.data
		.ast_source_valid	(s_validq), 			//                        .valid
		.ast_source_error	(s_errorq)  			//                        .error
	);
	

endmodule 