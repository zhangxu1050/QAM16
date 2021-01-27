//这是DD.v文件的程序清单
module DD (
	rst,clk,yi,yq,bitsync,
	pd); 
	
	input		rst;   			  //复位信号，高电平有效
	input		clk;   			  //FPGA系统时钟：8MHz
	input    bitsync;         //位同步信号：1MHz
	input	 signed [26:0]	yi;  //输入同相支路数据：8MHz
	input	 signed [26:0]	yq;  //输入正交支路数据：8MHz
	output signed [33:0]	pd;  //鉴相器输出数据   *90倍
   
	
	//通过仿真得出的理想星座图的判决门限
	wire signed [26:0] gateup,gatedown;
	assign gateup = 27'd12000000;     
	assign gatedown = -27'd12000000;
	

	//同时完成门限判决及I/Q支路的判决值与Q/I支路数据的乘法运算
	reg [2:0] i,q;
	reg signed [28:0] i_yq,q_yi;
	always @(posedge clk or posedge rst)
		if (rst)
		   begin
				i <= 3'd0;
				q <= 3'd0;
				i_yq <= 29'd0;
				q_yi <= 29'd0;
			end
		else
			//位同步定时信号，每个符号判决一次
			if (bitsync)	
				begin
			   //同时完成门限判决及I支路的判决值与Q支路数据的乘法运算
				if (!yi[26])
					if (yi > gateup)
						begin
							i <= 3'b011;
							i_yq <= {{2{yq[26]}},yq} +{{1{yq[26]}},yq,1'b0};//*3
						end
					else
						begin
							i <= 3'b001;
							i_yq <= {{2{yq[26]}},yq};//*1
						end				
				else
					if (yi > gatedown)
						begin
							i <= 3'b111;
							i_yq <= -{{2{yq[26]}},yq};//*-1
						end
					else
						begin
							i <= 3'b101;
							i_yq <= -{{2{yq[26]}},yq} - {{1{yq[26]}},yq,1'b0};//*-3
						end
			   //同时完成门限判决及Q支路的判决值与I支路数据的乘法运算
				if(!yq[26])
					if (yq > gateup)
						begin
							q <= 3'b011;
							q_yi <= {{2{yi[26]}},yi} + {{1{yi[26]}},yi,1'b0};//*3
						end
					else
						begin
							q <= 3'b001;
							q_yi <= {{2{yi[26]}},yi};//*1
						end				
				else
					if (yq > gatedown)
						begin
							q <= 3'b111;
							q_yi <= -{{2{yi[26]}},yi};//*-1
						end
					else
						begin
							q <= 3'b101;
							q_yi <= -{{2{yi[26]}},yi} - {{1{yi[26]}},yi,1'b0};//*-3
						end
	         end					
			

   wire signed [28:0] aiq;
	assign aiq = i_yq - q_yi;
	reg signed [35:0] pdout;
	
	//根据式(8-10)、(8-18)，dangle=aiq/(i^2+q^2)
	//为避免除法算，实现全精度运算，将dangle扩大90倍
	always @(posedge clk or posedge rst)
		if (rst)
		   pdout <= 36'd0;
		else
		   if (((i==3'b011)|(i==3'b101)) && ((q==3'b011)|(q==3'b101)))
			   //i*i+q*q=18  90＝18* 5＝4+1
			   pdout <= {{5{aiq[28]}},aiq,2'd0} + {{7{aiq[28]}},aiq};
		   else if (((i==3'b001)|(i==3'b111)) && ((q==3'b001)|(q==3'b111)))
			   //i*i+q*q=2  90＝2* 45＝32+8+4+1
			   pdout <= {{2{aiq[28]}},aiq,5'd0} + {{4{aiq[28]}},aiq,3'd0}+ {{5{aiq[28]}},aiq,2'd0}+ {{7{aiq[28]}},aiq};			
		   else
			   //i*i+q*q=10  90＝10*9 ＝8+1
			   pdout <= {{4{aiq[28]}},aiq,3'd0} + {{7{aiq[28]}},aiq};		

     assign pd = pdout[33:0];	
	
endmodule
