//这是Gate.v文件的程序清单
module Gate (
	rst,clk,din,
	mean);
	
	input    rst;              //复位信号，高电平有效
	input		clk;   				//FPGA系统时钟:8MHz
	input	 signed [13:0]	din;  //解调后的基带波形输入数据
	output signed [13:0]	mean; //基带信号的均值输出数据


	
    //移位进程(PShift)：将输入数据依次存入长度为256的移位寄存器中
    //输入信号din与ShiftReg(255)相差256个时钟周期
    //定义具有256个元素，14比特的存移位存储器
	 reg [13:0] ShiftReg [255:0];
    integer i,j;	 
    always @(posedge clk or posedge rst)
		if (rst)
			//初始化寄存器值为0
			for (i=0; i<=255; i=i+1)
				ShiftReg[i]=14'd0;
		else begin
			 //与串行结构不同，此处不需要判断计数器状态
			for (j=0; j<=254; j=j+1)
				ShiftReg[j+1] <= ShiftReg[j];
			ShiftReg[0] <= din;
		end
 
	//均值运算进程(PMean)：运算最近256个输入数据的均值
	reg signed [21:0] sum;
	always @(posedge clk or posedge rst)
		if (rst) 
			sum <= 22'd0;
		else
			//每个时钟周期更新一次最近256个输入数据的累加值
			sum <= sum+{{8{din[13]}},din}-{{8{ShiftReg[255][13]}},ShiftReg[255]};
			
	//采用右移8位的方法，近似实现除以256的运算，求取均值
	assign mean = sum[21:8];

	 
endmodule
