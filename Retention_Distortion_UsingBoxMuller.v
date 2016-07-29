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
module Retention_Distortion_UsingBoxMuller(
    input 				clk,
    input 				reset,
    input		 		inputValid,
    input 	[31:0]	inputVoltage,
    output 	[15:0]	outputVoltage,
    output 				outputValid
    );
	 
	 
	 
	reg 									load_seed = 1'b1;
	reg 				[31:0]			randomSeed=32'h97B41E82;

	reg									SetRandomSeed=1'd0;
	reg				[15:0]			VoltageAfterRetention;			
	reg									outputValidReg;
	reg				[15:0]			deltaVth;
	reg				[6:0]				romAddr_reg;
	reg				[15:0]			sigma_d;
	reg				[15:0]			mu_d;
	reg				[15:0]			pt;
	
	reg				[15:0]			currentVth,Vth_delay1,Vth_delay2,Vth_delay3,Vth_delay4,Vth_delay5,Vth_delay6,Vth_delay7,Vth_delay8Vth_delay9,Vth_delay10;


	wire				[6:0]				romAddr;
	wire				[6:0]				romAddrN;
	wire 				[15:0]			inputRTN;
	wire				[15:0]			gvg_sin;
	wire				[15:0]			gvg_cos;



	wire									rstTmp;
	wire									gvg_flag;
	
	parameter  RANDOMSEED=32'h3721AD74;  //random number seed
	parameter  mean_1 = 16'b0;
   parameter  StandardDeviation_0 = 16'b1;
		
	parameter  squrtSigma = 136;         // Ks=0.38, Km=4e(-6), Cycle=10^4, t=10^5, t0=1,   sigma = Ks*Km*Cycle^0.6*log(1+t/t0);  sigma_d = sqrt(sigma * (Vth - x0)) = sqrt(sigma) * sqrt(Vth - x0) = 'squrtSigma' * sqrt(Vth - x0) //squrtSigma=135.7825
   parameter  mu         =  358 ;       // Kd=10e(-4)                                         mu = Ks*Kd*Cycle^0.5*log(1+t/t0);  mu_d    = mu * (Vth - x0)   // mu=358.3913
	
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
																						
		//************************************************************************************************//
		
			always @ (posedge clk or posedge reset)
			begin 
				if (reset)
					deltaVth <= 16'd0;
				else
				begin
					deltaVth <= inputVoltage[31:16] - inputVoltage[15:0];
					currentVth <= inputVoltage[31:16];
					
//					romAddr <= deltaVth >> 6; // delta / 64 = account of Delta
				end	// end of if (reset)
			end //end always		

			assign romAddr  = deltaVth[15:6] ;
			assign romAddrN = deltaVth[15:6] + 1'b1;		
			
		//************ read sigma ***************************									
		retentionRomSigma	retentionRomSigma_uut(
						  .clka(clk),
						  .addra(romAddr),
						  .douta(sinData),
						  .clkb(clk),
						  .addrb(romAddrN),
						  .doutb(sigma)					// -delay1
						);				
				
		always @ (posedge clk or posedge reset)
		begin 
			if (reset)
				sigma_d <= 16'd0;
			else
			begin
				sigma_d <= sigma * squrtSigma;
				mu_d  <= deltaVth + mu;					// -delay1
			end	// end of if (reset)
		end //end always	
		
		//************* Using GaussianVariableGenerator --- 1. Less Precise 2. Using more resouce 3. flexiabel  ***************************//
	 		Box_Muller_RNG GaussianVariablesGenerator_uut(
				.clk(clk),
				.reset(reset),
				.enable(rstTmp),					// always enable
				.rng_32bits(PtxAddr),
				.mean(mean_1),
				.standard(StandardDeviation_0),
			/* delay  */
				.grv1(gvg_sin),								//gaussian random variables   output  signed	[15:0]	
				.grv2(gvg_cos),								//output  signed	[15:0]	
				.outputvalid(gvg_flag)			// out put	
				);
				
			always @ (posedge clk or negedge reset)
			begin 
				if (!reset)
				begin
					if (PtxAddr[20] == 1'b1)  // -delay1

						pt <= gvg_sin * sigma * squrtSigma + mu; 	// sin
					else 
						pt <= gvg_cos * sigma * squrtSigma + mu;		// cos
				end
			end //end always
			
	//************* Delay **************************************//
	always @( posedge clk )
	begin
		Vth_delay1 <= currentVth;
	   Vth_delay2 <= Vth_delay1;
		Vth_delay3 <= Vth_delay2;
		Vth_delay4 <= Vth_delay3;
		Vth_delay5 <= Vth_delay4;
		Vth_delay6 <= Vth_delay5;
		Vth_delay7 <= Vth_delay6;
		Vth_delay8 <= Vth_delay7;
		Vth_delay9 <= Vth_delay8;
		Vth_delay10 <= Vth_delay9;
//		Vth_delay <= Vth_delay;
//		Vth_delay <= Vth_delay;
//		Vth_delay <= Vth_delay;
		
	end	//end of always
	
	
	
	
	
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
							VoltageAfterRetention <= inputVoltage[31:16] - Pt ;
						end
				2'd2:
						begin
							VoltageAfterRetention <= inputVoltage[31:16] - Pt ;
						end
				2'd3:
						begin
							VoltageAfterRetention <= inputVoltage[31:16] - Pt;
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
