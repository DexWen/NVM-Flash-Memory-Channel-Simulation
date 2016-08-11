`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 		Singapore University of Technology and Design
// Engineer: 		Jiaying Wen (IDC)
// 
// Create Date:    16:28:47 06/27/2016 
// Design Name: 	
// Module Name:    Retention_Distortion 
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
module Retention_Distortion(
    input 				clk,
    input 				reset,
    input		 		inputValid,
    input 	[31:0]	inputVoltage,
    output 	[15:0]	outputVoltage,
    output 				outputValid
    );
	 
	 
	reg 									load_seed = 1'b1;
	reg 				[31:0]			randomSeed=32'h97BCAE82;

	reg									SetRandomSeed=1'd0;
	reg				[15:0]			VoltageAfterRetention;			
	reg									outputValidReg;
	
	wire 				[15:0]			inputRTN;

	wire				[31:0]			PtxAddr;
	wire				[12:0]			Pt_Addr1;
	wire				[12:0]			Pt_Addr2;
	wire				[12:0]			Pt_Addr3;
	
	wire				[15:0]			Pt_s1;
	wire				[15:0]			Pt_s2;
	wire				[15:0]			Pt_s3;
	
	wire									rstTmp;
	
	
	parameter  RANDOMSEED=32'h3721AD74;  //random number seed
 
	assign rstTmp = ~reset;					//RNG reset
		
		
	//******** Generate a ramdon number as a ROM address **********//
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
		
	 	rng  RNG_Retention_uut(
											.clk(clk),
											.reset(rstTmp),
											.loadseed_i(load_seed),
											.seed_i(randomSeed),
											.number_o(PtxAddr)
											);
											
		assign Pt_Addr1	= 	PtxAddr[12:0];
		assign Pt_Addr2	=	PtxAddr[22:10];
		assign Pt_Addr3	=	PtxAddr[31:19];
											
	
	//*********************************************************//

	//******** Access to ROM for distortion **********//
		//***** Pt1 ******//
		RetentionNoise_State1_ROM  Retention_rom1(
										  .clka(clk),
										  .addra(Pt_Addr1),
										  .douta(Pt_s1)
										);
		
		//***** Pt2 ******//
			RetentionNoise_State2_ROM Retention_rom2(
										  .clka(clk),
										  .addra(Pt_Addr2),
										  .douta(Pt_s2)
										);
										
		//***** Pt3 ******//
		RetentionNoise_State3_ROM Retention_rom3(
										  .clka(clk),
										  .addra(Pt_Addr3),
										  .douta(Pt_s3)
										);
										
	//*********************************************************//
		
	//************ Add Retention Noise ************************//
	always @( posedge clk )
	begin
		if(!inputValid)
			outputValidReg <= 1'b0;
		else
		begin
			case (inputVoltage[1:0])
			
				2'd0:
						begin
							VoltageAfterRetention <= inputVoltage[31:16] ;
						end
				2'd1:
						begin
							VoltageAfterRetention <= inputVoltage[31:16] - Pt_s1 ;
						end
				2'd2:
						begin
							VoltageAfterRetention <= inputVoltage[31:16] - Pt_s2 ;
						end
				2'd3:
						begin
							VoltageAfterRetention <= inputVoltage[31:16] - Pt_s3;
						end
				default:	
					VoltageAfterRetention <= inputVoltage[31:16];
			endcase 
			outputValidReg <= 1'b1;
		end		// end if(inputValid==1'b1)
	end			// end always
	
	//**********************************************************//
	
	assign outputVoltage = VoltageAfterRetention;
	assign	outputValid = outputValidReg;
endmodule
