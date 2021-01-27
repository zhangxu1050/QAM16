//这是LoopFilter.v文件的程序清单
module LoopFilter (
	rst,clk,pd,
	frequency_df); 
	
	input		rst;   //复位信号，高电平有效
	input		clk;   //FPGA系统时钟：8MHz
	input	 signed [33:0]	pd;            //输入数据：8MHz
	output signed [33:0]	frequency_df;  //环路滤波器输出数据
	
	
   reg [2:0] count;
	reg signed [33:0] sum,loopout;
	always @(posedge clk or posedge rst)
		if (rst)
		   begin
				count <= 3'd0;
				sum <= 34'd0;
				loopout <= 34'd0;
			end
		else
			begin
				//频率字更新周期为8个CLK周期
				count <= count + 3'd1;
			   //环路滤波器中的累加器寄存器
				if (count==3'd0)
				   //c2=2^(-14)
			      sum<=sum+{{14{pd[33]}},pd[33:14]};
 			   if (count==3'd1)
				   //c1=2^(-6)
				   loopout<=sum+{{6{pd[33]}},pd[33:6]};
			  end
			  
     assign frequency_df = loopout;

endmodule
