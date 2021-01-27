`timescale 1ns/1ns

module tb_BoardTst();
	
	reg	r_CLK	;
	reg	r_Rst	;
	wire	FPGA_CLK_A_N;
	wire	FPGA_CLK_A_P;
	wire	LEDG0			;
	wire	signed [13:0]	DA;
	wire	signed [13:0]	DB;
	
	initial begin
        r_CLK	= 1'b1 ;
        forever begin
            # 10 ;
            r_CLK	<= ~r_CLK ;
        end
    end
	 
	 initial begin
        r_Rst	= 1'b0 	;
        # 37500 			;
		  r_Rst	= 1'b1 	;
    end
	 
	 //pattern计数
	integer			Pattern					;
	 
	initial begin
        Pattern	= 1'b0 ;
        forever begin
            # 20 ;
            Pattern = Pattern+1;
        end
    end 
	 
	//产生写入时钟信号，初始状态时不写入数据
	wire		rst_write	;
	assign 	rst_write = (Pattern >1950)? r_CLK: 1'b0;    
	
	//将仿真数据di写入外部TXT文件中(di.txt)
	integer file_di;
	initial	begin
		//文件放置在"工程目录\simulation\modelsim"路径下                                                  
		file_di = $fopen("QAM.txt");
	end
	
	//将df转换成有符号数据
	wire	signed [13:0]	s_dout;
	assign	s_dout = DA;
	always @(posedge rst_write)	begin
		$fdisplay(file_di,"%d",s_dout);
	end

	BoardTst BoardTst(
				.CLK				(r_CLK),
				.Rst				(r_Rst),
				.FPGA_CLK_A_N	(FPGA_CLK_A_N),
				.FPGA_CLK_A_P	(FPGA_CLK_A_P),
				.LEDG0			(LEDG0)	,
				.DA				(DA)	,
				.DB				(DB)
	);

endmodule 