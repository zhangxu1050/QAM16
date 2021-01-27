`timescale 1ns/1ns

module tb_myqam();
	
	reg	r_CLK	;
	reg	r_Rst	;
	wire	signed [28:0]	mult_i;
	wire	signed [28:0]	mult_q;
	wire	signed [29:0]	dout	;
	
	initial begin
        r_CLK	= 1'b1 ;
        forever begin
            # 20 ;
            r_CLK	<= ~r_CLK ;
        end
    end
	 
	 initial begin
        r_Rst	= 1'b1 	;
        # 37500 			;
		  r_Rst	= 1'b0 	;
    end


	myqam myqam(
				.CLK		(r_CLK)		,
				.Rst		(r_Rst)		,
				.mult_i	(mult_i)		,
				.mult_q	(mult_q)		,
				.dout		(dout)		
				);
				
	//将输出数据写入文本文件
	   
	
	//将仿真数据di写入外部TXT文件中(dout.txt)
	integer file_dout;
	initial
		begin
	//文件放置在"工程目录\simulation\modelsim"路径下                                                  
			file_dout = $fopen("dout.txt");
		end
	//将df转换成有符号数据
	wire signed [29:0] s_dout;
	assign s_dout = dout;
	always @(posedge r_CLK)	begin
		$fdisplay(file_dout,"%d",s_dout);
	end


endmodule 