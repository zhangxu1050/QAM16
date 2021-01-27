`timescale 1ns/1ns

module tb_BitTrans();
	
	reg			r_CLK	;
	reg			r_Rst	;
	wire			Bit	;
	wire	[3:0]	code	;
	
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

	//信源模块例化
	source	source(
					.CLK(r_CLK),
					.Rst(r_Rst),
					.Bit(Bit)
					);
	//转换模块例化
	BitTrans 	BitTrans(
						.rst(r_Rst)	,
						.clk(r_CLK)	,
						.din(Bit)	,
						.code(code)
						);
	

endmodule 