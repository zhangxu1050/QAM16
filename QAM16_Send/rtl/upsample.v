module upsample(
	input							clk	,
	input 						rst	,
	input		signed [2:0]	I		,
	input 	signed [2:0]	Q		,
	output	signed [2:0]	UP_I	,
	output	signed [2:0]	UP_Q
			);
			
	reg				 [2:0]	r_cnt	;
	reg		signed [2:0]	r_up_i;
	reg		signed [2:0]	r_up_q;
	
	//8倍上采样
	
	always @( posedge clk or posedge rst)	begin
		if(rst)	begin
			r_cnt	<= 3'd0 ;
			r_up_i<= 3'd0 ;
			r_up_q<= 3'd0 ;
		end else begin
			r_cnt	<=	r_cnt + 1'b1 ;
			if(r_cnt==0)	begin
				r_up_i	<= I ;
				r_up_q	<= Q ;
			end else begin
				r_up_i<= 3'd0 ;
				r_up_q<= 3'd0 ;
			end
		end
	end
	
	assign	UP_I	= r_up_i;
	assign	UP_Q	= r_up_q;
			

endmodule 