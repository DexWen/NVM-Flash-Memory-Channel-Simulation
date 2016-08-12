`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 		Singapore University of Technology and Design
// Engineer: 		Jiaying Wen (IDC)
// 
// Create Date:    15:10:00 04/27/2016 
// Design Name: 	 
// Module Name:    RTN_distortion 
// Project Name:   NVMChannelModel
// Target Devices: 
// Tool versions: 
// Description:    Add RTN distortion
//						 1. Generate a random number to access ROM
//                 2. Add/subtract the Vr
//                 3. Output the Distorted voltage and the origin voltage
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module RTN_distortion(
							 input  			clk,
							 input 			reset,
							 input  [31:0] RTNInputData,						// 0 time slot
							 output [31:0] RTNOutputData						//	1 time slot
							 );
	 

	reg 									load_seed = 1'b1;
	reg 				[31:0]			randomSeed=32'h9572AE86;
	reg   signed 	[16:0]			VthTmp; 
	reg   			[16:0]			VthTmp2;
	reg				[15:0]			VthErased;
	reg				[15:0]			VthErasedTmp;
	reg									SetRandomSeed=1'd0;
	

	wire 				[15:0]			inputRTN;
	wire				[15:0]			Vr;
	wire				[31:0]			VrAddr_32;	
	wire				[10:0]			VrAddr_11;
	wire				[9:0]				VrAddr_10;
	wire									rstTmp;
	
	
	parameter  RANDOMSEED=32'hA4612274;  //random number seed
 
	assign VrAddr_11=VrAddr_32[25:15];
	assign rstTmp = ~reset;					//RNG reset
	
	always @ (posedge clk or posedge reset)
	begin
		if (reset )
		begin
				load_seed<=1'b0;
		end
		else 
		begin
			if(SetRandomSeed==0)
			begin
				load_seed<=1'b1;
				randomSeed <= RANDOMSEED;
				SetRandomSeed <= 1'b1;
			end		
			else if(SetRandomSeed==1)
				load_seed<=1'b0;
		end
	
	end
	
	
	//************  random   number between 0~2048 *******************//	
	rng  random_number_generator_uut(
											.clk(clk),
											.reset(rstTmp),
											.loadseed_i(load_seed),
											.seed_i(randomSeed),
											.number_o(VrAddr_32)
											);
	
	
	//************  random address to get a random expomential parameter with lambda=Kr*sqrt(Cycle) **********//
	// 1.  Kr=0.00025, Cycle=10000, for easier caculattion -> lambda* 2^11  **************//
	// 2.  All lambda data was generate by matlab and save in Rom   Vr=exprnd(lambda)  lambda=Kr*sqrt(Cycle); Vth = Vth +/- Vr  ********//
	//                                                       DataInRom=fix(Vr*(2^11))     	

		assign VrAddr_11=VrAddr_32[25:15];	
	 expomential_Rom Vr_uut(
					  .clka(clk),
					  .addra(VrAddr_11),
					  .douta(Vr)
						); 						
						
	//*********** Cycle = 100 **********//					
/*	assign VrAddr_10=VrAddr_32[25:16];	
	
	 expomential_Rom_Cycle100 Vr_uut(
					  .clka(clk),
					  .addra(VrAddr_10),
					  .douta(Vr)
						);			*/		
						
						
						
	//**************** Add TRN  Distortion  ************************//
	//************ Vth= Vth + Vr * sign (rand-0.5) ******************//	
	always @ ( posedge clk or negedge reset)
	begin
		if (!reset)
		begin 
			if(Vr[0]==0)
			begin
				VthTmp <= {{RTNInputData[31]},{RTNInputData[31:16]}} + Vr;		//VthTmp = 16 bits
				VthErased <= RTNInputData[15:0];
			end
			else
			begin
				VthTmp <= {{RTNInputData[31]},{RTNInputData[31:16]}} - Vr;
				VthErased <= RTNInputData[15:0];
			end 
		end
	end 
	
	always @ ( posedge clk or negedge reset)
	begin
		if (!reset)
		begin 
			if (VthTmp <= 0)// In case of negative number
			begin
				VthTmp2 <= 17'b0;
				VthErasedTmp <= VthErased;
			end
			else
			begin
				VthTmp2 <= VthTmp;
				VthErasedTmp <= VthErased;
			end
		end
	end
	
	
	
	assign RTNOutputData= {{VthTmp2[15:0]},{VthErasedTmp}};			// take MSB 16bits, equal to be devided by 2

endmodule
