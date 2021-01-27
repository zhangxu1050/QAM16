//这是PolarDetect.v文件的程序清单
module PolarDetect (
	rst,clk,yi,yq,
	pd); 
	
	input		rst;   //复位信号，高电平有效
	input		clk;   //FPGA系统时钟：8MHz
	input	 signed [26:0]	yi;  //输入同相支路数据：8MHz
	input	 signed [26:0]	yq;  //输入正交支路数据：8MHz
	output signed [26:0]	pd;  //鉴相器输出数据
	
	reg signed [26:0] sygnyi,sygnyq;
	reg signed [27:0] pdt;
	always @(*)
		   begin
			   if (!yi[26])
				   sygnyq <= yq;
				else
				   sygnyq <= -yq;
				if (!yq[26])
				   sygnyi <= yi;
				else
					sygnyi <= -yi;
			end
			
	always @(posedge clk)
		pdt <= {sygnyq[26],sygnyq} - {sygnyi[26],sygnyi};	
		
	assign pd = pdt[26:0];

endmodule
