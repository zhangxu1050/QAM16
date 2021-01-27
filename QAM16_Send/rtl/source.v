module source(
				input		CLK,
				input 	Rst,
				output 	Bit
				);
					
	reg 	[9:0] r_addr=10'd0	;	//初始化很重要
	wire 	[9:0] s_addr			;
	reg 			clk_half			;
	reg 			clk_half1		;
	wire			half				;
	//地址累加
	always @(posedge CLK or posedge Rst)	begin
		if(Rst)	begin
			r_addr <= 10'd0;	
		end else if((r_addr <= 10'd1023))	begin
			if(half)	begin
			r_addr <= r_addr + 10'd1;
			end
		end else begin
			r_addr <= 10'd0;
		end
	end
	
	assign s_addr = r_addr	;
	
	//每两个时钟地址加一
	always @(posedge CLK or posedge Rst) begin
	   if (Rst) begin
		   clk_half1 <= 1'b0;
		end else begin
		   clk_half1 <= clk_half;
		end
	end
			
	assign half = clk_half & (!clk_half1)	;
	
	//二分频
	always @(posedge CLK or posedge Rst )	begin
		if(Rst)	begin
			clk_half	<=	1'b0		;
		end else begin
			clk_half	<=	!clk_half;
		end
	end
	
		
	
	//Rom实例化		
	bit_source bit_source(
				.address	(s_addr)		,
				.clock	(CLK)	,
				.q			(Bit)
				);
			
endmodule