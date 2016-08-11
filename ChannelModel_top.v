`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:28:47 04/26/2016 
// Design Name: 
// Module Name:    ChannelModel_top 
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
module ChannelModel_top(
					clk,
					reset,
					addr,
					VthAfterRTN
					);
	 input  				clk;
	 input  				reset;
	 input  	[13:0]	addr;
	 output 	[15:0]	VthAfterRTN;
	 
	 wire 	[15:0]	output_Vth;	



					InputData inputRom(
							.clka(clk),
							.addra(addr),
							.douta(output_Vth)
							);
							
					RTN_distortion RTN_uut(
							.clk(clk),
							.rst(reset),
							.input_Vth(output_Vth),
							.output_Vth(VthAfterRTN)
							);


endmodule
