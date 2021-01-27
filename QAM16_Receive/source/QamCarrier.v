//这是QamCarrier.v文件的程序清单
module QamCarrier (
	rst,clk,din,clk_half,di,dq,
	df,dout); 
	
	input					rst			;   //复位信号，高电平有效
	input					clk			;  	//时钟信号，数据速率/采样速率/FPGA系统时钟/8 MHz
	input					clk_half	;	//pll插值滤波器工作时钟
	input	 	   [13:0]	din			;   //输入的16QAM已调数据
	output	signed [26:0]	di			;   //解调后的基带信号(同相支路)
	output 	signed [26:0]	dq			;   //解调后的基带信号(正交支路)
	output	signed [33:0]	df			;   //环路滤波器输出数据
	output		   [3:0]	dout		;	//码元输出
	
	reg 	signed [7:0] 	dint		;
	
	//NCO核所需的接口信号
	wire 					out_valid	;
	wire					clken		;
	wire 		   [36:0]	carrier		;
	wire	signed [9:0	] 	sin 		;
	wire 	signed [9:0	] 	cos 		;
	wire 	signed [36:0] 	frequency_df;
	wire 	signed [33:0] 	Loopout		;
	
	//乘法器信号
	wire 	signed [15:0] 	zi			;
	wire 	signed [15:0] 	zq			;	
	
	//滤波器信号
	wire	signed [26:0]	yi			;
	wire	signed [26:0]	yq			;
	wire		   [1:0	]	s_errori	;
	wire					s_validi	;
	wire		   [1:0	]	s_errorq	;
	wire					s_validq	;
	
	//鉴相器信号
	wire 	signed [33:0] 	pd			;
	wire 					bitsync		;
	
	//位同步信号
	wire 	signed [17:0] 	dig			;
	wire 	signed [17:0] 	dqg			;
	wire 	signed [26:0] 	s_di		;
	wire 	signed [26:0] 	s_dq		;
	
	//解码信号
	wire		   [2:0]	i			;
	wire		   [2:0]	q			;
	
	
	//数字震荡器参数设计
	assign clken 		= 1'b1							;
	//assign carrier		= 37'd34368328303				;//2.0005MHz  df=500Hz
	assign frequency_df	= {{3{Loopout[33]}},Loopout}	;//根据NCO核接口，扩展为37位
	
	assign carrier=37'd34359738368;//2MHz  df=0Hz
	//assign carrier=37'd34361456355;//2.0001MHz   df=100Hz
	
	//信号输出值
	assign df 	= Loopout		;
	assign s_di = {dig,9'd0}	;
	assign s_dq = {dqg,9'd0}	;
	assign di 	= s_di			;
	assign dq 	= s_dq			;
	
	
	
	//首先对输入数据通过寄存器输入  
	always @(posedge clk) begin
		dint <= din[13:6] - 8'd128  	;
	end
		
	//实例化NCO核
	//Quartus提供的NCO核输出数据最小位宽为10比特，根据环路设计需求，只取高8比特参与后续运算	
	nco	u0 (
		.phi_inc_i 	( carrier		)	,
		.clk 		( clk			)	,
		.reset_n 	( !rst			)	,
		.clken 		( clken			)	,
		.freq_mod_i ( frequency_df	)	,
		.fsin_o 	( sin			)	,
		.fcos_o 	( cos			)	,
		.out_valid 	( out_valid		)
		);
	
   //实例化NCO同相支路乘法运算器核
   mult8_8 u1 (
		.clock ( clk     )	,
		.dataa ( sin[9:2])	,
		.datab ( dint    )	,
		.result( zi      )
		);
		
   //实例化NCO正交支路乘法运算器核		
   mult8_8 u2 (
		.clock ( clk     )	,
		.dataa ( cos[9:2])	,
		.datab ( dint    )	,
		.result( zq      )
		);
		

   //实例化鉴相器同相支路低通滤波器核
    fir fir_i(
			.clk				( clk		)	,          	//clk.clk
			.reset_n			( !rst		)	,          	//rst.reset_n
			.ast_sink_data		( zi[14:0]	)	,   		//avalon_streaming_sink.data
			.ast_sink_valid		( 1'b1		)	,   		//.valid
			.ast_sink_error		( 2'd0		)	,  			//.error
			.ast_source_data	( yi		)	,  			//avalon_streaming_source.data
			.ast_source_valid	( s_validi	)	, 			//.valid
			.ast_source_error 	( s_errori	) 				//.error
			);


   //实例化鉴相器正交支路低通滤波器核
   fir fir_q(
			.clk				( clk		)	,          	//clk.clk
			.reset_n			( !rst		)	,          	//rst.reset_n
			.ast_sink_data		( zq[14:0]	)	,   		//avalon_streaming_sink.data
			.ast_sink_valid		( 1'b1		)	,   		//.valid
			.ast_sink_error		( 2'd0		)	,  			//.error
			.ast_source_data	( yq		)	,  			//avalon_streaming_source.data
			.ast_source_valid	( s_validq	)	, 			//.valid
			.ast_source_error 	( s_errorq	) 				//.error
			);
		
		
	//实例化鉴相器模块
	DD u6 (
		.rst 		( rst		)				,
		.clk 		( clk		)				,
		.bitsync 	( bitsync	)				,
		.yi 		( yi		)				,
		.yq 		( yq		)				,
		.pd 		( pd		)
		);
			
	//实例化环路滤波器模块	
   LoopFilter u5(
		.rst 			( rst		)			,
		.clk 			( clk		)			,
		.pd  			( pd		)			,
		.frequency_df	( Loopout	)
		);
		

	//实例化位同步模块
   
   BitSync u7(
	   .rst 			(	rst			)		,
		.clk 			(	clk			)		,
		.clk_half		(	clk_half	)		,
		.yi  			(	yi[26:11]	)		,
		.yq  			(	yq[26:11]	)		,
		.di  			(	dig			)		,
		.dq  			(	dqg			)		,		
		.sync			(	bitsync		)
		);		
		
	
	//判决电路
	Decision	Decision(
				.clk		( clk		)		,
				.rst		( rst		)		,
				.bitsync	( bitsync	)		,
				.di			( s_di		)		,
				.dq			( s_dq		)		,
				.i			( i			)		,
				.q			( q			)	
				);
		
	//解码模块
	DeCodeMap DeCodeMap(
					.rst		( rst		)	,
					.clk		( clk		)	,
					.bitsync	( bitsync	)	,
					.I			( i			)	,
					.Q			( q			)	,
					.dout		( dout		)
					);

   

	
endmodule
