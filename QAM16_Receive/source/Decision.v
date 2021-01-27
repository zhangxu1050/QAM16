`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:11:27 03/15/2020 
// Design Name: 
// Module Name:    Decision 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Decision(
	input					clk			,
	input					rst			,
	input					bitsync		,
	input	signed	[26:0]	di		,
	input	signed	[26:0]	dq		,
	output			[2:0]	i			,
	output			[2:0]	q			
    );
    
    //ͨ�������ó�����������ͼ���о�����
	wire 	signed 	[26:0] 	gateup		;
	wire 	signed 	[26:0] 	gatedown	;
	reg				[2:0]	r_i			;
	reg				[2:0]	r_q			;
	
	assign gateup 	= 27'd3000000		;     
	assign gatedown = -27'd3000000		;
	
	always @( posedge clk or posedge rst)	begin
		if(rst)	begin
			r_i	<= 0;
			r_q	<= 0;
		end else begin
			if( bitsync)	begin
				if (!di[26])	begin
					if(di>gateup)	begin
						r_i <= 3'b011;
					end else begin
						r_i <= 3'b001;
					end
				end else begin
					if(di>gatedown)	begin
						r_i <= 3'b111;
					end else begin
						r_i <= 3'b101;
					end
				end
				if (!dq[26])	begin
					if(dq>gateup)	begin
						r_q <= 3'b011;
					end else begin
						r_q <= 3'b001;
					end
				end else begin
					if(dq>gatedown)	begin
						r_q <= 3'b111;
					end else begin
						r_q <= 3'b101;
					end
				end		
			end
		end
	end		
	
	assign	i = r_i;
	assign	q = r_q;
	
endmodule
