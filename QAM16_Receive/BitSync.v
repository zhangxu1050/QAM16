//这是BitSync.v文件的程序清单
module BitSync (
	rst,clk,clk_half,yi,yq,
	di,dq,sync); 
	
	input						rst		;   //复位信号，高电平有效
	input						clk		;   
	input						clk_half	;
	input  signed [15:0]	yi			;     //基带I支路数据/8 MHz
	input  signed [15:0]	yq			;     //基带Q支路数据/8 MHz
	output signed [17:0]	di			;     //插值I支路数据/1 MHz
	output signed [17:0]	dq			;     //插值Q支路数据/1 MHz
	output 					sync		;     //位同步脉冲/1MHz
	
   
//	reg clk_half;
	reg signed [15:0] dig,dqg;
	always @(posedge clk or posedge rst)
	   if (rst)
		   begin
//		      clk_half <= 1'b0;
				dig <= 16'd0;
				dqg <= 16'd0;
			end
		else
		   begin
			   //对时钟分频，产生位同步模块时钟信号clk_half
				// clk_half <= !clk_half;
				//对基带解调数据实现2倍抽取，送入位同步模块
				if (!clk_half)
				   begin
					   dig <= yi;
						dqg <= yq;
					end
			end
			
	wire signed [15:0] u,e,w;
   wire bit_sync;	
	//实例化位同步模块	
   FpgaGardner u1(
	   .rst (rst),
		.clk (clk_half),
		.di  (dig),
		.dq  (dqg),
		.yi  (di),
		.yq  (dq),		
		.u(u),
		.e(e),
		.w(w),
		.sync(bit_sync));		
   
	//bitsync周期为clk_half，载波同步环要求位同步时钟周期为clk
	//用clk取bitsync的上升沿作为载波同步环位同步信号
	reg bitsync_d;
	always @(posedge clk or posedge rst)
	   if (rst)
		   bitsync_d <= 1'b0;
		else
		   bitsync_d <= bit_sync;
			
	assign sync = (!rst)?(bit_sync & (!bitsync_d)): 1'b0;
		
endmodule		
	
