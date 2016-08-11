`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:58:02 05/06/2016 
// Design Name: 
// Module Name:    ChannelModel_top3 
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
module ChannelModel_top3(
					clk,
					reset,
					VoltageLevel,
					InitialVth
					);
	 input  				clk;
	 input  				reset;
	 input  	[1:0]	VoltageLevel;

	 
	 output 	[15:0]	InitialVth;	



			VoltageProgram programProcess(
													.VoltageLevel(VoltageLevel),
													.clk(clk),
													.reset(reset),
													.InitialVoltage(InitialVth)
													);

endmodule 