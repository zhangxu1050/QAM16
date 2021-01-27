//这是CodeMap.v文件的程序清单
module CodeMap (
	rst,clk,din,
	I,Q); 
	
	input						rst;       //复位信号，高电平有效
	input						clk;       //FPGA系统时钟
	input	 			[3:0]	din;  //输入的绝对码数据
	output signed	[2:0]	I,Q;  //转换后的相对码数据
	
		reg	[2:0]	r_count	;
	
		//码元时钟
		always @(posedge clk or posedge rst)	begin
			if(rst)	begin
				r_count	<= 3'd0;
			end else if(r_count <=3'd7)	begin
				r_count	<= r_count+1'b1;
			end else begin
				r_count	<= 3'd0;
			end
		end
				
				
		

    //差分编码
	 wire c,d;
	 reg  Dc,Dd;
	 reg [3:0] code;
	 always @(posedge clk or posedge rst)	begin
	    if (rst)	begin
				Dc <= 1'b0;
				Dd <= 1'b0;
				code <= 2'd0;
		 end else begin
			if(r_count==3'd0)	begin
					Dc <= c;
					Dd <= d;
				//完成差分编码后，组成新的4bit数据用于星座映射
				code <= {c,d,din[1:0]};
			end
		  end
	 end
	
	 wire d3xord2,d3xordc,d3xordd;
	 assign d3xord2 = din[3]^din[2];
	 assign d3xordc = din[3]^Dc;
	 assign d3xordd = din[3]^Dd;
	 assign c = ((!d3xord2) & d3xordc) ^(d3xord2 & d3xordd);
	 
	 wire d2xordd,d2xordc;
	 assign d2xordd = din[2]^Dd;
	 assign d2xordc = din[2]^Dc;
	 assign d = ((!d3xord2) & d2xordd) ^(d3xord2 & d2xordc);
	 
				  
	 //星座映射
	 reg signed	[2:0] it,qt;
	 always @(posedge clk or posedge rst)
	    if (rst)
			begin
				it <= 3'd0;
				qt <= 3'd0;
			end
		else
			case(code)
				4'd0:
					begin
						it <= 3'b011;
						qt <= 3'b011;
					end
				4'd1:
					begin
						it <= 3'b001;
						qt <= 3'b011;
					end			   
				4'd2:
					begin
						it <= 3'b011;
						qt <= 3'b001;
					end	
				4'd3:
					begin
						it <= 3'b001;
						qt <= 3'b001;
					end	
				4'd4:
					begin
						it <= 3'b101;
						qt <= 3'b011;
					end	
				4'd5:
					begin
						it <= 3'b101;
						qt <= 3'b001;
					end						
				4'd6:
					begin
						it <= 3'b111;
						qt <= 3'b011;
					end						
				4'd7:
					begin
						it <= 3'b111;
						qt <= 3'b001;
					end
				4'd8:
					begin
						it <= 3'b011;
						qt <= 3'b101;
					end
				4'd9:
					begin
						it <= 3'b011;
						qt <= 3'b111;
					end			   
				4'd10:
					begin
						it <= 3'b001;
						qt <= 3'b101;
					end	
				4'd11:
					begin
						it <= 3'b001;
						qt <= 3'b111;
					end	
				4'd12:
					begin
						it <= 3'b101;
						qt <= 3'b101;
					end	
				4'd13:
					begin
						it <= 3'b111;
						qt <= 3'b101;
					end						
				4'd14:
					begin
						it <= 3'b101;
						qt <= 3'b111;
					end						
				default:
					begin
						it <= 3'b111;
						qt <= 3'b111;
					end				   
			endcase
			
    assign I = it;
	 assign Q = qt;
	 
endmodule
	