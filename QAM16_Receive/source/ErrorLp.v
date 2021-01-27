//这是ErrorLp.v文件的程序清单
module ErrorLp (
	rst,clk,strobe,yik,yqk,
	yi,yq,sync,er,wk); 
	
	input		rst;    //复位信号，高电平有效
	input		clk;    //时钟信号/数据输入速率/4倍符号速率/4 MHz
	input		strobe; //gnco模块送来的选通信号	
	input  signed [17:0]	yik;   //插值滤波后的I路数据/4 MHz
	input  signed [17:0]	yqk;   //插值滤波后的Q路数据/4 MHz	
	output signed [17:0]	yi;    //最佳采样时刻的插值I路数据/1 MHz位
	output signed [17:0]	yq;    //最佳采样时刻的插值Q路数据/1 MHz位	
	output signed [15:0]	er;    //定时误差信号
	output signed [15:0]	wk;    //环路滤波后信号
	output sync;                //位同步时钟信号，与最佳采样时刻同步/1 MHz	
	
	reg signed [17:0] yik_0,yqk_0,yik_1,yqk_1,yik_2,yqk_2,yit,yqt,err_1;
	wire signed [17:0] err;
 	reg signed [15:0] w;
	reg sk;
   always @(posedge clk or posedge rst)
      if (rst)
		   begin
            yik_0 <= 18'd0;
            yqk_0 <= 18'd0;
            yik_1 <= 18'd0;
            yqk_1 <= 18'd0;
            yik_2 <= 18'd0;
            yqk_2 <= 18'd0;
            yit <= 18'd0;
            yqt <= 18'd0;
            sk  <= 1'b0;
            err_1 <= 18'd0;
            //设置环路滤波器输出的初始值为0.5
            w <= 16'b0100000000000000;
         end
      else
		   begin
         //在检测到gnco模块送来的溢出信号strobe后，取出有效插值数据进行误差检测
         if (strobe)
			   begin
              yik_0 <= yik;
              yqk_0 <= yqk;
              yik_1 <= yik_0;
              yqk_1 <= yqk_0;
              yik_2 <= yik_1;
              yqk_2 <= yqk_1;
              //设置sk信号，其周期为符号周期，作为位定时时钟输出
              sk <= !sk;
              //每个符号进行一次环路滤波处理
				  if(sk) 
				     begin
                    //此时将最佳插值数据输出，获取最佳位定时采样值，用于基带信号的最后判决解码
                    yit <= yik_0;
                    yqt <= yqk_0;
                    //环路滤波器    
                    err_1 <= err;
                    //通过移位运算，近似实现乘以0.0156的小数运算
                    //err还需要乘以2才得到er，因此只需对err左移5位即实现乘以2^(-6)　
						 w <= w+{{3{err[17]}},err[17:5]}-{{3{err_1[17]}},err_1[17:5]};
                 end                    
           end
        end

    assign sync = sk;
	 assign wk = w;
    assign yi = yit;
	 assign yq = yqt;
	 
   /////////////////////////基于Gardner算法的误差检测器//////////////////////////
	wire signed [17:0] Ia2,Qa2,yik1_Ia,yqk1_Qa;
	reg signed [17:0] eri,erq;
	
   //计算式（8-29），这里没有除以2倍
   assign Ia2 = yik_0+yik_2;    
   assign Qa2 = yqk_0+yqk_2;    
   //计算式（8-28）中的乘数，进行减法时通过移位实现除以2的运算
   assign yik1_Ia = yik_1-{Ia2[17],Ia2[17:1]};
   assign yqk1_Qa = yqk_1-{Qa2[17],Qa2[17:1]};
    
   //计算式（8-28），根据yik及yik_2的符号位实现乘法运算
   //两个数的符号位相减只有3种结果：2、0、−2,这里不进行2倍乘法
	always @(*)
	   if ((!yik[17]) && yik_2[17])
		   eri <= yik1_Ia;
		else if ((!yik_2[17]) && yik[17])
		   eri <= -yik1_Ia;
		else
		   eri <= 18'd0;
			
	always @(*)
	   if ((!yqk[17]) && yqk_2[17])
		   erq <= yqk1_Qa;
		else if ((!yqk_2[17]) && yqk[17])
		   erq <= -yqk1_Qa;
		else
		   erq <= 18'd0;			
    
   assign err = eri+erq;
   //通过移位处理，实现2倍乘法运算
   assign er = (sk)? {err[14:0],1'b0} :16'd0;
   /////////////////////////基于Gardner算法的误差检测器//////////////////////////

endmodule
	