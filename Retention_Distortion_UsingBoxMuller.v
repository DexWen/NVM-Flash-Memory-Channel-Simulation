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
// Description:  part 1. Random number as a address used by rom
//							 2. Read Rom1 
// Dependencies:	mu    = Ks(x-x0)*Kd*N^(0.5) *ln(1 +t/t0) => part1. Ks*Kd*N^(0.5) *ln(1 +t/t0),constant  	part2.(x-x0) 
//					   sigma	= Ks(x-x0)*Km*N^(0.6) *ln(1 +t/t0) => part1. Ks*Km*N^(0.6) *ln(1 +t/t0),constant    part2.(x-x0)
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
	
	reg									outputValidReg,symbol,symbolDelay;
	reg				[15:0]			deltaVth;
	
	//** mu and sigma ****//
	reg				[15:0]			   mu_delay1, mu_delay2,mu_delay3;
	reg				[15:0]			sigma_delay, sigma,sigmaRom_1;
	reg				[31:0]			mu_d,sigma_d;
	
	reg				[15:0]			Pt,delta1 ,gvgTmp_16;
	reg				[31:0]			Pt_d,gvgTmp_32;
	
	reg				[31:0]			Vth_delay,Vth_delay1,Vth_delay2,Vth_delay3,Vth_delay4,Vth_delay5,Vth_delay6,Vth_delay7,Vth_delay8;
		
	wire				[6:0]				romAddr,romAddrN;
	
	wire				[15:0]			gvg_sin,gvg_cos;
	wire				[15:0]			sigmaRom,sigmaRomN;
	wire				[31:0]			PtxAddr;
	wire									rstTmp;
	wire									gvg_flag;
	
	parameter  RANDOMSEED				=	32'h9D21_A174;  //random number seed
	parameter  mean_1 					= 	16'b0;
   parameter  StandardDeviation_0 	= 	16'b1;
	
	//************** sigma ****************//
	// Ks=0.38, Km=4e(-6), Cycle=10^4, t=10^5, t0=1,   
	// sigma = Ks*Km*Cycle^0.6*log(1+t/t0);  
	// squrtSigma= sqrt(Ks*Km*Cycle^0.6*log(1+t/t0))= sqrt( (0.38) * (4e(-6)) * ((10000)^(-6)) * log(1+100000/1) ) = 0.0663 
	// sigma_d = sqrt(sigma * (Vth - x0)) = sqrt(sigma) * sqrt(Vth - x0) = 'squrtSigma' * sqrt(Vth - x0)	
	// 0.0663 * (2^11)=> 135.7825
	// ******* set 2 **************	
	// 2. Cycle=100 t= 720 (1 month = 720 hours)
	// squrtSigma= sqrt(Ks*Km*Cycle^0.6*log(1+t/t0))= sqrt( (0.38) * (4e(-6)) * ((100)^(-6)) * log(1+720/1) ) = 0.0126
	// 0.0126 * (2^11) = 25.7861
	// ******* set 3 **************	
	//	Cycle = 10000 t= 87600 (10 year)
	// squrtSigma = 0.0659  => * 2^11 => 134.999
	
	//************ mu *********************//
	// Kd=10e(-4)        
	// mu = Ks*Kd*Cycle^0.5*log(1+t/t0) = (0.38) * (10e(-4)) * ((10000)^(-5)) * log(1+100000/1) = 0.1750;
   //	mu_d    = mu * (Vth - x0)   
	// mu= 0.1750 * 2^11 = 358.3913
	// ******* set 2 **************	
	// 2. Cycle=100 t= 720 (1 month = 720 hours)
	// mu = Ks*Kd*Cycle^0.5*log(1+t/t0) = (0.38) * (10e(-4)) * ((100)^(-5)) * log(1+720/1) = 0.01;
   //	mu_d    = mu * (Vth - x0)   
	// mu= 0.01 * 2^11 = 20.4853
	// ******* set 3 **************	
	//	Cycle = 10000 t= 87600 (10 year)
	// mu = 0.1730 => * 2^11 => 354 
	parameter  squrtSigma 				= 	135;         
   parameter  mu         				=  354 ;       
	
	assign 	  rstTmp 					= 	~reset;					//RNG reset
		
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
				end		// end of if SetRandomSeed
				else if(SetRandomSeed==1)
					load_seed<=1'b0;
			end	// end of if reset
		end	// end of always
		
	 	rng  RNG_Retention_uut(
											.clk(clk),
											.reset(rstTmp),
											.loadseed_i(load_seed),
											.seed_i(randomSeed),
											.number_o(PtxAddr)
											);
																						
	//*************** set the address as rom address of log-data ***********************************************************//
		
			always @ (posedge clk or posedge reset)
			begin 
				if (reset)
					deltaVth <= 16'd0;
				else
				begin
					deltaVth <= inputVoltage[31:16] - inputVoltage[15:0];
					Vth_delay <= inputVoltage;
					
				end	// end of if (reset)
			end //end always		

			assign romAddr  = deltaVth[12:6] ;				// 16 bits ,7 bits as address -- 0.03125 * 2^11 =64(means that delta voltage contain (Vth/64) deltas)
			assign romAddrN = deltaVth[12:6] + 1'b1;		

//************ read sigma  7 bits expand to 16 bits***************************									
		retentionRomSigma	retentionRomSigma_uut(
						  .clka(clk),
						  .addra(romAddr),
						  .douta(sigmaRom),
						  .clkb(clk),
						  .addrb(romAddrN),
						  .doutb(sigmaRomN)					// -delay1
						);	
						
//************* Using GaussianVariableGenerator --- 1. Less Precise 2. Using more resouce 3. flexiabel  ***************************//
	Box_Muller_RNG_StandardNormalDistribution GaussianVariablesGenerator_uut(
						.clk(clk),
						.reset(reset),
						.enable(rstTmp),								// always enable
						.rng_32bits(PtxAddr),
					/* delay  */
						.grv1(gvg_sin),								//gaussian random variables   output  signed	[15:0]	
						.grv2(gvg_cos),								//output  signed	[15:0]	
						.outputvalid(gvg_flag)						// out put	
						);					
				
						
//*********** insert address 7 *******************// 	
	

	always@ (posedge clk or posedge reset)
	begin
		if(reset)
		begin
			outputValidReg <= 1'b0;
		end		//end if (reset)
		else 
		begin
			//** step 1 **// checked
			Vth_delay1 	<= Vth_delay;					// delay  beacause of reading Rom--retentionRomSigma, it takes one time solt
			
			delta1 		<= sigmaRomN - sigmaRom;	//	 used as 1 bit insert
			Vth_delay2 	<= Vth_delay1;					// delay for step 1
			sigmaRom_1  <= sigmaRom;					// delay
			
			
			//** step 2 **//     checked
			sigma 		<= delta1[15:1] + sigmaRom_1;				//   sqrt(sigma)   * 'sqrt(Vth - x0)' ,part2 
			Vth_delay3 	<= Vth_delay2;
			
			//** step 3 **//     checked
			//????????
			sigma_d 		<= squrtSigma * sigma  ;					//	 'sqrt(sigma)'  *  sqrt(Vth - x0)  , part1 + part2    sigma_d = Ks*Km*Cycle^0.6*log(1+t/t0)
			mu_d  		<= (Vth_delay3[31:16]- Vth_delay3[15:0]) * mu;	// mu
			Vth_delay4 	<= Vth_delay3;
			
			//** step 4 *****//    checked
	//*********?????????0??,1???,?????????????????**************//
			if (PtxAddr[20] == 1'b1)  // -delay1 ??????????(?????2????),PtxAddr[20]????????????,???????????
			begin
				//??RNG?????????,?????,????????,??????????,???????????
					// ????
				gvgTmp_16<=(gvg_sin[15]==0 )?gvg_sin:{gvg_sin[15],~gvg_sin[14:0]+1'b1};	//negative number
				sigma_delay <= sigma_d[26:11];															
				mu_delay1 <= mu_d[26:11];
				Vth_delay5 	<= Vth_delay4;
			end	// end (PtxAddr[20] == 1'b1)
			else
			begin
				gvgTmp_16<=(gvg_cos[15]==0 )?gvg_cos:{gvg_cos[15],~gvg_cos[14:0]+1'b1};
				sigma_delay <= sigma_d[26:11];
				mu_delay1 <= mu_d[26:11];
				Vth_delay5 	<= Vth_delay4;
			end	//end of	(PtxAddr[20] == 1'b1)
			
			//** step 5 **//    checked  
				// ????
			gvgTmp_32 <= gvgTmp_16[14:0] * sigma_delay[14:0]; //checked
			mu_delay2 <= mu_delay1;
			symbol <= gvgTmp_16[15];
			Vth_delay6 	<= Vth_delay5;

			//** step 6 **//  checked
				// ????
			Pt_d <= (symbol==0)?gvgTmp_32:{symbol,~gvgTmp_32[30:0]+1'b1};
			mu_delay3 <= mu_delay2;
			Vth_delay7 	<=  Vth_delay6;
			
			//** step 7 **//
				// ????
			Pt   			<=  Pt_d[26:11] + mu_delay3;
			Vth_delay8 	<=  Vth_delay7;
			
			//** step 8 **//
				//?? retention ??
			case (Vth_delay8[1:0])
			2'd0:
					begin
						VoltageAfterRetention <= Vth_delay8[31:16] ;
						outputValidReg <= 1'b1;
					end
			2'd1:
					begin
						VoltageAfterRetention <= Vth_delay8[31:16] - Pt ;
						outputValidReg <= 1'b1;
					end
			2'd2:
					begin
						VoltageAfterRetention <= Vth_delay8[31:16] - Pt ;
						outputValidReg <= 1'b1;
					end
			2'd3:
					begin
						VoltageAfterRetention <= Vth_delay8[31:16] - Pt;
						outputValidReg <= 1'b1;
					end
				default:	
					VoltageAfterRetention <= Vth_delay8[31:16];
			endcase 
		end	// end of if reset
	end	// end of always
	//**********************************************************//
	
	assign outputVoltage = VoltageAfterRetention;
	assign	outputValid = outputValidReg;
	
endmodule
