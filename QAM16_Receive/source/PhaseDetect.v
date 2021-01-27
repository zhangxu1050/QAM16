//这是PhaseDetect.v文件的程序清单
module PhaseDetect (
	rst,clk,yi,yq,
	pd); 
	
	input		rst;   //复位信号，高电平有效
	input		clk;   //FPGA系统时钟：8MHz
	input	 signed [25:0]	yi;  //输入同相支路数据：8MHz
	input	 signed [25:0]	yq;  //输入正交支路数据：8MHz
	output signed [25:0]	pd;  //鉴相器输出数据
	
	//实例化极性判决模块
	wire signed [25:0] pd_polar;
	PolarDetect u1 (
	   .rst (rst),
		.clk (clk),
		.yi (yi),
		.yq (yq),
		.pd (pd_polar));
		
	//实例化DD判决模块
	wire signed [25:0] pd_DD;
	DD u2 (
	   .rst (rst),
		.clk (clk),
		.yi (yi),
		.yq (yq),
		.pd (pd_DD));
		
	//时间控制的鉴相算法转换进程
	integer t;
	reg signed [25:0] pdout;
	always @(posedge clk or posedge rst)
	   if (rst)
		   begin
			   t <= 0;
				pdout <= 26'd0;
			end
		else
		   begin
			   if (t<16000)
				   begin
						t <= t+1;
						pdout <= pd_polar;
					end
				else
				   pdout <= pd_DD;
			end
			
	assign pd = pdout;	
	
endmodule

