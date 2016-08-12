`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 			Singapore University of Technology and Design
// Engineer: 			Jiaying Wen (IDC)
// 
// Create Date:    	13:43:40 05/03/2016 
// Design Name: 
// Module Name:    	VlotageProgram 
// Project Name: 		NVMChannelModel
// Target Devices: 
// Tool versions: 	V1.0
// Description: 		** input **
//							1. clk and reset signal
//							2.	Voltage level needed to be written 2bits/cell level range from  0-3
//
//							** output **
//							1. 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
	module VoltageProgram(
    input [1:0] VoltageLevel,
    input clk,
    input reset,
    output [31:0] VoltageAfterProgrammed
    );
	 

	 wire							rst_Rng;
	 
	 reg 							load_seed = 1'b1;
	 reg 				[31:0]	randomSeed=32'h20160542;
	 
	 wire				[15:0]	ErasedVth1;						// 0 time slot
	 wire				[15:0]	ErasedVth2;
	 wire 						ErasedVthValid_flag;
	 
	 reg 				[31:0]	StepVthTmp;
	 reg	signed	[15:0]	VthWrite;
	 reg				[15:0]	ErasedVthTmp;
	 reg				[31:0]	ProgrammeAndInitdVoltage;	// 1 time slot
	 reg							SetRandomSeed=1'b0;
	 reg				[1:0]		VoltageLevelTmp;
	 reg	signed	[31:0]	ErasedVth_reg_32bits;
	 reg				[15:0]	ErasedVth_reg_16bits;
	 
	 
	 wire				[15:0]   randStep;
	 wire				[31:0]	ErasedVthAddr_32;	
	 wire				[13:0]	ErasedVthAddr_14;
	 
	 
	//**************** 3bits/cell state voltage x*(2^11)  *************// 
	//parameter state1 = 16'd5529;						// 2.7V
	//parameter state2 = 16'd6963;						// 3.4V
	//parameter state3 = 16'd8396;						// 4.1V
	//parameter state4 = 16'd9830;						// 4.8V
	//parameter state5 = 16'd11264;						//	5.5V
	//parameter state6 = 16'd12697;						// 6.2V
	//parameter state7 = 16'd14131;						// 6.9V

	//**************** 3bits/cell state voltage x*(2^11)  *************// 
	parameter state1 = 16'd5222;						// 2.55V   10
	parameter state2 = 16'd6451;						// 3.15V   11
	parameter state3 = 16'd7680;						// 3.75V   01
	
	
	
	parameter  RANDOMSEED  					= 		32'h482B_B056;	
	parameter  stepVoltage_02V 			= 		16'd410;  				// 0.2V * 2^11 =410
	parameter  stepVoltage_03V 			=	 	16'd614;  				// 0.3V * 2^11 =614
	parameter  ErasedState_mean 			= 		16'd2867;			// 1.1V * 2^11 =2252.8	/ 1.4V * 2^11 = 2867	
 	parameter  ErasedState_standard_deviation 			=	 	16'd717;	         // 0.35 * 2^11 =716.8
	
	
	//***********  set random seed***********************//
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
		
   //************  random   number between 0~65536 *******************//	
	rng  randomAddressOfErasedVth(
											.clk(clk),
											.reset(rst_Rng),
											.loadseed_i(load_seed),
											.seed_i(randomSeed),
											.number_o(ErasedVthAddr_32)
											);
											
	
	assign rst_Rng 			= 	~reset;
	assign randStep			=	{{ErasedVthAddr_32[5:0]},ErasedVthAddr_32[20:16]};				//Random choose 11bits for a random number
	

	
	//************  random address to get a random erased voltage ***********************************//
      //************* Way 1. From ROM  --- 1.Precise 2.Simple 3.Very unflexiable ***************************//
		/* assign ErasedVthAddr_14	=	ErasedVthAddr_32[13:0]; 
		EeasedStatusVthDistribution ErasedVthModule(
						  .clka(clk),
						  .addra(ErasedVthAddr_14),
						  .douta(ErasedVth)
							);  */
		//************* Way 2. Using GaussianVariableGenerator --- 1. Less Precise 2. Using more resouce 3. flexiabel  ***************************//
	 		Box_Muller_RNG GaussianVariablesGenerator_uut(
				.clk(clk),
				.reset(reset),
				.enable(rst_Rng),					// always enable
				.rng_32bits(ErasedVthAddr_32),
				.mean(ErasedState_mean),
				.standard(ErasedState_standard_deviation),

				.grv1(ErasedVth1),								//gaussian random variables   output  signed	[15:0]	
				.grv2(ErasedVth2),								//output  signed	[15:0]	
				.outputvalid(ErasedVthValid_flag)			// out put
				);
				
			always @ (posedge clk or negedge reset)
			begin 
				if (!reset)
				begin
					if (ErasedVthAddr_32[20] == 1'b1) 
					ErasedVth_reg_16bits <= ErasedVth1; 	// sin
					else 
					ErasedVth_reg_16bits <= ErasedVth2;		// cos
				end
			end //end always
	
	
   //************************************************************************************************//
		always @(posedge clk or posedge reset)
		begin
			if(reset)
				VthWrite<=16'd0;
			else if(ErasedVthValid_flag)
			begin 
				StepVthTmp <= stepVoltage_03V * randStep;			//CellVth = StepVth(here = 0.3V)*rand + Vstate
				
	/*			case (VoltageLevel)					// depend on maping rules 3bits/cell [5.5 4.8 6.2 6.9 3.4 4.1 2.7]
					3'd0: Vthoutput <= ErasedVth;
 					3'd1: Vthoutput <= state5 + StepVthTmp[26:11];
 					3'd2: Vthoutput <= state4 + StepVthTmp[26:11];
 					3'd3: Vthoutput <= state6 + StepVthTmp[26:11];
 					3'd4: Vthoutput <= state7 + StepVthTmp[26:11];
 					3'd5: Vthoutput <= state2 + StepVthTmp[26:11];
 					3'd6: Vthoutput <= state3 + StepVthTmp[26:11];
 					3'd7: Vthoutput <= state1 + StepVthTmp[26:11];  
				default:  Vthoutput<= ErasedVth;
				endcase*/
				
				case (VoltageLevel)												// depend on maping rules 2bits/cell [3.75 2.55 3.15]
					2'd0: VthWrite <= ErasedVth_reg_16bits;
 					2'd1: VthWrite <= state3 + StepVthTmp[26:11];		// 
 					2'd2: VthWrite <= state1 + StepVthTmp[26:11];
 					2'd3: VthWrite <= state2 + StepVthTmp[26:11];

				default:  VthWrite<= ErasedVth_reg_16bits;
				endcase 
				//*********** data storage  ***************//
				ErasedVthTmp <= ErasedVth_reg_16bits;												// delay one plus
				VoltageLevelTmp <= VoltageLevel;
				
				ProgrammeAndInitdVoltage <= {VthWrite,ErasedVthTmp[15:2],VoltageLevelTmp};			//*******  [31:16] is the voltage after programmed , [15:2]  is the voltage before programmed , [1:0] is voltage level ***//
			end		// end else if(ErasedVthValid_flag)
		end 		// end of always
		

	 assign VoltageAfterProgrammed = ProgrammeAndInitdVoltage;		// Voltage output 
//	 assign ProgrammedVoltage  = {Vthoutput,ErasedVthAddr_14};
	 


endmodule
