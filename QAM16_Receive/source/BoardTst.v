module	BoardTst(
	input					CLK					,
	input					Rst					,
	input 					ADA_OR				,
	input 					ADA_DCO				,
	input			[1:0]	SW					,
	input			[13:0]	ADA_D				,
	output 					ADA_OE				,
	output					LEDG0				,
	output					LEDG3				,
	output 					ADA_SPI_CS			,
//	output	signed [33:0]	DF					,
	output	signed [13:0]	DA					,
	output	signed [13:0]	DB					,
	inout					FPGA_CLK_A_N		,
	inout					FPGA_CLK_A_P		,
	inout					AD_SCLK				,
	inout					AD_SDIO				
	);
	
	reg			   [13:0]	r_ADA				;
//	reg		signed [7:0]	r_AD				;
	reg		signed [13:0]	r_di				;
	reg		signed [13:0]	r_dq				;
	wire		   [13:0]	s_din				;
	wire					sys_clk				;
	wire					sys_clk_180deg		;
	wire					clk_half			;
	wire					pll_locked			;
	wire	signed [26:0]	s_di				;
	wire 	signed [26:0]	s_dq				;
	wire	signed [33:0]	s_df				;
	
	//解调模块例化
	QamCarrier QamCarrier(
						.rst		( !Rst		)	,
						.clk		( sys_clk	)	,
						.din		( s_din		)	,
						.clk_half	( clk_half	)	,
						.di			( s_di		)	,
						.dq			( s_dq		)	,
						.df			( s_df		)	,
						.dout		( )	
						); 
						
	//FPGA提供时钟驱动
	pll pll_inst(
			.inclk0	( CLK			)	,
			.c0		( sys_clk		)	,
			.c1		( sys_clk_180deg)	,
			.c2		( clk_half		)	,
			.locked	( pll_locked	)
			);
	
	//数据输入缓存
	always @(posedge ADA_DCO or negedge Rst)	begin
		if (!Rst)	begin
			r_ADA	<= 14'd0	;
		end else begin
			r_ADA	<= ADA_D		;
		end
	end
//	
//	//无符号数到有符号数的转化
//	always @(posedge CLK or negedge Rst)	begin
//		if (!Rst)	begin
//			r_AD	<= 8'd0	;
//		end else begin
//			r_AD	<= r_ADA[13:6]	;
//		end
//	end
	
	//存取高十四位I,Q基带数据
	always @(posedge sys_clk or negedge Rst)	begin
		if (!Rst)	begin
			r_di	<= 14'd0	;
			r_dq	<= 14'd0 ;
		end else begin
			r_di	<= s_di[23:10]		;
			r_dq	<= s_dq[23:10]		;
		end
	end
	
	assign	s_din				= 	r_ADA				;
	assign	ADA_OE				= 	1'b0				;				// 使能DA输出
	assign	ADA_SPI_CS			= 	1'b1				;				// 关闭SPI模式
	assign	LEDG3				= 	ADA_OR 			;				// DA输入指示
	assign	FPGA_CLK_A_P		=  sys_clk_180deg	;
	assign	FPGA_CLK_A_N		= ~sys_clk_180deg	;
	assign	LEDG0				= 	pll_locked		;				// pll locked
//	assign	DI					= 	s_di				;
//	assign	DQ					=	s_dq				;
//	assign	DF					=  s_df				;
	assign	DA					= 	r_di				;
	assign	DB 					= 	r_dq				;
	assign	AD_SCLK				= 	SW[0]				;			// (DFS)Data Format Select
	assign	AD_SDIO				= 	SW[1]				;			// (DCS)Duty Cycle Stabilizer Select
		
endmodule	
