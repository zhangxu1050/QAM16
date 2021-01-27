//这是Gate.v文件的程序清单
module Gate (
	rst,clk,din,
	mean);
	
	input    rst;              //复位信号，高电平有效
	input		clk;   				//FPGA系统时钟:8MHz
	input	 signed [25:0]	din;  //解调后的基带波形输入数据
	output signed [25:0]	mean; //基带信号的均值输出数据


	
    //移位进程(PShift)：将输入数据依次存入长度为1024的移位寄存器中
    //输入信号din与ShiftReg[1023]相差1024个时钟周期
    //定义具有1024个元素，26比特的存移位存储器
	 reg [25:0] ShiftReg [1023:0];
    integer i,j;	 
    always @(posedge clk or posedge rst)
		if (rst)
			//初始化寄存器值为0
			for (i=0; i<=1023; i=i+1)
				ShiftReg[i]=26'd0;
		else begin
			for (j=0; j<=1022; j=j+1)
				ShiftReg[j+1] <= ShiftReg[j];
			ShiftReg[0] <= din;
		end
 
	//均值运算进程(PMean)：运算最近256个输入数据的均值
	reg signed [35:0] sum;
	always @(posedge clk or posedge rst)
		if (rst) 
			sum <= 36'd0;
		else
			//每个时钟周期更新一次最近256个输入数据的累加值
			if (ShiftReg[1023][25] && din[25])
			   sum <= sum+{{10{din[25]}},din}-{{10{ShiftReg[1023][25]}},ShiftReg[1023]};
			else if ((!ShiftReg[1023][25]) && (!din[25]))
			   sum <= sum-{{10{din[25]}},din}+{{10{ShiftReg[1023][25]}},ShiftReg[1023]};
			else if ((!ShiftReg[1023][25]) && (din[25]))
			   sum <= sum+{{10{din[25]}},din}+{{10{ShiftReg[1023][25]}},ShiftReg[1023]};
			else
			   sum <= sum-{{10{din[25]}},din}-{{10{ShiftReg[1023][25]}},ShiftReg[1023]};
			
	//采用右移10位的方法，近似实现除以1024的运算，求取均值
	assign mean = sum[35:10];

	 
endmodule
