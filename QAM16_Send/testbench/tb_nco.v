`timescale 1ns/1ns

module tb_nco();
	
	reg	r_CLK	;
	reg	r_Rst	;
	wire	out_valid;
	wire	signed [9:0]	sin;
	wire	signed [9:0]	cos;
	
	initial begin
        r_CLK	= 1'b1 ;
        forever begin
            # 20 ;
            r_CLK	<= ~r_CLK ;
        end
    end
	 
	 initial begin
        r_Rst	= 1'b1 	;
        # 37500 			;
		  r_Rst	= 1'b0 	;
    end


	nco_top nco_top(
				.clk(r_CLK)					,
				.rst(!r_Rst)					,
				.out_valid(out_valid)	,
				.sin(sin)					,
				.cos(cos)
			);

endmodule 