//这是mgate.v文件的程序清单
module mgate (
	rst,clk,din,
	mean);
	
	input    rst;              //复位信号，高电平有效
	input		clk;   				//FPGA系统时钟:8MHz
	input	 signed [25:0]	din;  //解调后的基带波形输入数据
	output signed [25:0]	mean; //基带信号的均值输出数据
	
	
	reg[7:0] count;
	reg signed [25:0] max_up,max_down,gate_up,gate_down;
	always @(posedge clk or posedge rst)
	   if (rst)
		   begin
			   count <= 8'd0;
				max_up <= 26'd0;
				max_down <= 26'd0;
				gate_up <= 26'd0;
				gate_down <= 26'd0;
			end
		else
		   begin
			   count <= count + 8'd1;
				if (count==8'd0)
				   begin
						//2/3=1/2+1/8+1/32
						gate_up <= {{1{max_up[25]}},max_up[25:1]} + {{3{max_up[25]}},max_up[25:3]} + {{5{max_up[25]}},max_up[25:5]} ;
						max_up <= 26'd0;
						gate_down <= {{1{max_down[25]}},max_down[25:1]} + {{3{max_down[25]}},max_down[25:3]} + {{5{max_down[25]}},max_down[25:5]} ;
						max_down <= 26'd0;						
					end
				else
				   begin
				      if (max_up < din)
					      max_up <= din;
						if (max_down > din)
						   max_down <= din;
					end
			end
	wire signed [26:0] gate;
   assign gate = {gate_up[25],gate_up}-{gate_down[25],gate_down};	
	assign mean = gate[26:1];		

endmodule

				