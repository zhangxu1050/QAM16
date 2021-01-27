//这是gnco.v文件的程序清单
module gnco (
	rst,clk,wk,
	uk,nk,strobe); 
	
	input		rst;   //复位信号，高电平有效
	input		clk;   //时钟信号/数据输入速率/4倍符号速率/4 MHz
	input   signed [15:0] wk;     //环路滤波器输出定时误差信号，15 bit小数位
	output  signed [15:0] uk;     //NCO输出的插值间隔小数，15 bit小数位
	output  signed [15:0] nk;     //NCO寄存器值
	output  strobe;               //NCO输出的插值计算选通信号，高电平有效
	
   reg signed [16:0] nkt;
	reg signed [16:0] ut;
	reg str;
   always @(posedge clk or posedge rst)
      if (rst)
		   begin
				//设置nk、uk的初值
				nkt <= 17'b00110000000000000;	
				str <= 1'b0;
				ut  <= 17'b00100000000000000;	
			end
		else
		   begin
			   if (nkt < {wk[15],wk})
				   begin
						// 负值+1，相当于mod(1);
						nkt <= 17'b01000000000000000+nkt-{wk[15],wk};
						str <= 1'b1;
						//取出nkt减去wk之前的值，后续乘以2作为u值输出
						ut <= nkt;
					end
				else
				   begin
						nkt <= nkt-{wk[15],wk};
						str <= 1'b0;
					end
	        end
			  
		assign nk = nkt[15:0];
	   assign uk = {ut[14:0],1'b0};
	   assign strobe = str;	

endmodule
