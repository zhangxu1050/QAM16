`timescale 1ns/1ns

module tb_fir();
	
	reg						r_CLK	;
	reg						r_Rst	;
	wire	signed	[18:0]di_lpf;
	wire	signed	[18:0]dq_lpf;
	wire						s_validi;
	wire				[1:0]	s_errori;
	wire						s_validq;
	wire				[1:0]	s_errorq;
	
	
	
	//时钟产生
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
	 
	 //模块例化
	 fir fir(
				.r_CLK	(r_CLK),
				.r_Rst	(r_Rst),
				.di_lpf	(di_lpf),
				.dq_lpf	(dq_lpf),
				.s_validi(s_validi),
				.s_validq(s_validq),
				.s_errori(s_errori),
				.s_errorq(s_errorq)
			);
	

endmodule 