`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:13:47 07/20/2016
// Design Name:   Box_Muller_RNG
// Module Name:   C:/Users/SUTD/codes/GaussianRandomVariable/GaussianRandomVariable/GaussianRandomVariable_tb.v
// Project Name:  GaussianRandomVariable
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Box_Muller_RNG
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module GaussianRandomVariable_tb;

	// Inputs
	reg clk;
	reg reset;
	reg enable;

	// Outputs
	wire signed [15:0] grv1;
	wire signed [15:0] grv2;
	wire outputvalid;
	
	reg	signed[15:0]	output1;
	reg	signed[15:0]	output2;

	reg	[19:0]		cnt=18'b0;
	integer						dataFile1;
	integer						dataFile2;

	// Instantiate the Unit Under Test (UUT)
	Box_Muller_RNG uut (
		.clk(clk), 
		.reset(reset), 
		.enable(enable), 
		.grv1(grv1), 
		.grv2(grv2), 
		.outputvalid(outputvalid)
	);

		initial 
		begin
			// Initialize Inputs
			clk = 0;
			reset = 1'b1;
			enable = 1'b1;
			cnt = 0;
			dataFile1 = $fopen("Data-g1-cos.txt","w");
			dataFile2 = $fopen("Data-g0-sin.txt","w");
			// Wait 100 ns for global reset to finish
			#100;
			reset=1'b0;
		 end    
			// Add stimulus here
		
		always 
		begin
			#50 clk=~clk;
		end
		
		always @ (negedge clk or posedge reset)
		begin
		if (!reset)
			begin 
				output1 = grv1;
				output2 = grv2;
				$display ("%d, %d \n" ,output1,output2);
				$fwrite(dataFile1,"\n %d",output1);
				$fwrite(dataFile2,"\n %d",output2);	 
				cnt =cnt+ 1;				
			end
 
		if (cnt>=20'd327679)		//  max 1048575
			begin
				$fclose (dataFile1);
				$fclose (dataFile2);
				cnt = 20'd0;
				$display ("Finish! \n");
				$finish;
			end  
	end

endmodule

