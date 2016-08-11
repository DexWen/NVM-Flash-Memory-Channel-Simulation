`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 		Singapore University of Technology and Design
// Engineer: 		Jiaying Wen (IDC)
// 
// Create Date:    16:28:47 04/26/2016 
// Design Name: 
// Module Name:    ChannelModel_top 
// Project Name:   NVMChannelModel
// Target Devices: 
// Tool versions: 
// Description:    	Top module for ChannelModel
//							1. connect all sub-modules
//							2. All-bit line structure
//
// Dependencies:    Parameter: 1. Erased Stated:  Verify voltage = [3.75 2.55 3.15] 2bits/cell (Configurable)
//																  DeltaVoltage   = 0.3V                        (Configurable)
//															     Mean           = 1.1V								  (Configurable)
//																  standard       = 0.35								  (Configurable)
//										 2. RTN parameters: Cycle          = 10000							  (Configure in ROM)
//											  					  Kr             = 0.00025	                    (Configure in ROM)
//										 3. Cell-to-cell:   sigmaY  		  = 0.064   							(Configurable)
//																  sigmaXY 		  = 0.0048							   (Configurable)
//										 4. Retention:	     Ks      		  = 0.38    							(Configurable)
//																  Kd     		  = 4*10^(-4)							(Configurable)
//										 	     				  Km      		  = 4*10^(-6)  						(Configurable)
//																  x0     		  = Mean of Erased Stated 			(Configurable)
//										 	     				  t		  		  = 10^5  								(Configurable)
//																 
//
// Revision: 
// Revision 0.01 - File Created 0.11 - File partially implemented
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ChannelModel_top2(
					clk,
					reset,
					VoltageLevel,
					RetentionDoneFlag,
			//********** data test ****************		
					IdealProgrammedVoltage,		// data 1 & data 2
					VthAfterRTN,					// data 3
					VoltageInputToRetention,	// data 4
			//************************************		
					VoltageOutAfterRetention	// data 5
	//				CCIDoneFlag,
	//				VoltageToRetention
					);
	 input  				clk;
	 input  				reset;
	 input  	[1:0]		VoltageLevel;
	 
	 output	[15:0]	VoltageOutAfterRetention;				//data5
	 output				RetentionDoneFlag;
	 
				 
				 
	output	wire 		[31:0]	IdealProgrammedVoltage;		//data1 & 2
	output	wire 		[31:0]	VthAfterRTN;					//data3
	output	wire 		[31:0]	VoltageInputToRetention;	//data4
		wire		[31:0]	CCIVthInput[15:0];
		wire		[31:0]	VoltageToRetention;			
		wire					CCIDoneFlag;

	 wire					dataInputCCIValid;
	 
	 
	 
	 wire		[31:0]	VoltageAfterCCI[15:0];	
	 wire					cciDoneFlag;	
	 wire					RetentionDoneFlag;
	 




			VoltageProgram programProcess_uut(
													.VoltageLevel(VoltageLevel),
													.clk(clk),
													.reset(reset),
													.VoltageAfterProgrammed(IdealProgrammedVoltage)
													);

					RTN_distortion RTN_uut	(
													.clk(clk),
													.reset(reset),
													.RTNInputData(IdealProgrammedVoltage),
													.RTNOutputData(VthAfterRTN)		//33bits [32:16]Vth after RTN,	[15:0] Erased Voltage   
													);
													
					DataBuffer	Buff_uut	(													
													.clk(clk),
													.reset(reset),
													.dataIn(VthAfterRTN),

													.DesDataOut0(CCIVthInput[0]),				
													.DesDataOut1(CCIVthInput[1]),				
													.DesDataOut2(CCIVthInput[2]),				
													.DesDataOut3(CCIVthInput[3]),				
													.DesDataOut4(CCIVthInput[4]),				
													.DesDataOut5(CCIVthInput[5]),				
													.DesDataOut6(CCIVthInput[6]),				
													.DesDataOut7(CCIVthInput[7]),				
													.DesDataOut8(CCIVthInput[8]),				
													.DesDataOut9(CCIVthInput[9]),				
													.DesDataOut10(CCIVthInput[10]),				
													.DesDataOut11(CCIVthInput[11]),				
													.DesDataOut12(CCIVthInput[12]),				
													.DesDataOut13(CCIVthInput[13]),				
													.DesDataOut14(CCIVthInput[14]),				
													.DesDataOut15(CCIVthInput[15]),				
		/*											.DesDataOut16(CCIVthInput[16]),				
													.DesDataOut17(CCIVthInput[17]),				
													.DesDataOut18(CCIVthInput[18]),				
													.DesDataOut19(CCIVthInput[19]),				
													.DesDataOut20(CCIVthInput[20]),				
													.DesDataOut21(CCIVthInput[21]),				
													.DesDataOut22(CCIVthInput[22]),				
													.DesDataOut23(CCIVthInput[23]),				
													.DesDataOut24(CCIVthInput[24]),				
													.DesDataOut25(CCIVthInput[25]),				
													.DesDataOut26(CCIVthInput[26]),				
													.DesDataOut27(CCIVthInput[27]),				
													.DesDataOut28(CCIVthInput[28]),				
													.DesDataOut29(CCIVthInput[29]),				
													.DesDataOut30(CCIVthInput[30]),				
													.DesDataOut31(CCIVthInput[31]),		*/
	//												.wordLineCnt(WordLineNumber),
													.d_valid(dataInputCCIValid)													
													);
																		
																		
						CellToCell_Interference cci_uut(
													.clk(clk),
													.reset(reset),
													.inputReady(dataInputCCIValid),
//													.WordLine_Cnt(WordLineNumber),
													.CCIinputData0(CCIVthInput[0]),
													.CCIinputData1(CCIVthInput[1]),
													.CCIinputData2(CCIVthInput[2]),
													.CCIinputData3(CCIVthInput[3]),
													.CCIinputData4(CCIVthInput[4]),
													.CCIinputData5(CCIVthInput[5]),
													.CCIinputData6(CCIVthInput[6]),
													.CCIinputData7(CCIVthInput[7]),
													.CCIinputData8(CCIVthInput[8]),
													.CCIinputData9(CCIVthInput[9]),
													.CCIinputData10(CCIVthInput[10]),
													.CCIinputData11(CCIVthInput[11]),
													.CCIinputData12(CCIVthInput[12]),
													.CCIinputData13(CCIVthInput[13]),
													.CCIinputData14(CCIVthInput[14]),
													.CCIinputData15(CCIVthInput[15]),
			/*										.CCIinputData16(CCIVthInput[16]),
													.CCIinputData17(CCIVthInput[17]),
													.CCIinputData18(CCIVthInput[18]),
													.CCIinputData19(CCIVthInput[19]),
													.CCIinputData20(CCIVthInput[20]),
													.CCIinputData21(CCIVthInput[21]),
													.CCIinputData22(CCIVthInput[22]),
													.CCIinputData23(CCIVthInput[23]),
													.CCIinputData24(CCIVthInput[24]),
													.CCIinputData25(CCIVthInput[25]),
													.CCIinputData26(CCIVthInput[26]),
													.CCIinputData27(CCIVthInput[27]),
													.CCIinputData28(CCIVthInput[28]),
													.CCIinputData29(CCIVthInput[29]),
													.CCIinputData30(CCIVthInput[30]),
													.CCIinputData31(CCIVthInput[31]),   */
								
													.VthAfterCCI0(VoltageAfterCCI[0]),
													.VthAfterCCI1(VoltageAfterCCI[1]),
													.VthAfterCCI2(VoltageAfterCCI[2]),								
													.VthAfterCCI3(VoltageAfterCCI[3]),
													.VthAfterCCI4(VoltageAfterCCI[4]),
													.VthAfterCCI5(VoltageAfterCCI[5]),
													.VthAfterCCI6(VoltageAfterCCI[6]),
													.VthAfterCCI7(VoltageAfterCCI[7]),
													.VthAfterCCI8(VoltageAfterCCI[8]),
													.VthAfterCCI9(VoltageAfterCCI[9]),
													.VthAfterCCI10(VoltageAfterCCI[10]),
													.VthAfterCCI11(VoltageAfterCCI[11]),
													.VthAfterCCI12(VoltageAfterCCI[12]),
													.VthAfterCCI13(VoltageAfterCCI[13]),
													.VthAfterCCI14(VoltageAfterCCI[14]),
													.VthAfterCCI15(VoltageAfterCCI[15]),
				/*									.VthAfterCCI16(VoltageAfterCCI[16]),
													.VthAfterCCI17(VoltageAfterCCI[17]),
													.VthAfterCCI18(VoltageAfterCCI[18]),
													.VthAfterCCI19(VoltageAfterCCI[19]),
													.VthAfterCCI20(VoltageAfterCCI[20]),
													.VthAfterCCI21(VoltageAfterCCI[21]),
													.VthAfterCCI22(VoltageAfterCCI[22]),
													.VthAfterCCI23(VoltageAfterCCI[23]),
													.VthAfterCCI24(VoltageAfterCCI[24]),
													.VthAfterCCI25(VoltageAfterCCI[25]),
													.VthAfterCCI26(VoltageAfterCCI[26]),
													.VthAfterCCI27(VoltageAfterCCI[27]),
													.VthAfterCCI28(VoltageAfterCCI[28]),
													.VthAfterCCI29(VoltageAfterCCI[29]),
													.VthAfterCCI30(VoltageAfterCCI[30]),
													.VthAfterCCI31(VoltageAfterCCI[31]),			*/
												
													.CCI_Done(cciDoneFlag)		
													);															

					
			ParallelToSerialConversion ParlToSeri_uut	(
													.clk(clk),
													.reset(reset),
													.inputValid(cciDoneFlag),
													
													.input_Vth0(VoltageAfterCCI[0]),
													.input_Vth1(VoltageAfterCCI[1]),
													.input_Vth2(VoltageAfterCCI[2]),
													.input_Vth3(VoltageAfterCCI[3]),
													.input_Vth4(VoltageAfterCCI[4]),
													.input_Vth5(VoltageAfterCCI[5]),
													.input_Vth6(VoltageAfterCCI[6]),
													.input_Vth7(VoltageAfterCCI[7]),
													.input_Vth8(VoltageAfterCCI[8]),
													.input_Vth9(VoltageAfterCCI[9]),
													.input_Vth10(VoltageAfterCCI[10]),
													.input_Vth11(VoltageAfterCCI[11]),
													.input_Vth12(VoltageAfterCCI[12]),
													.input_Vth13(VoltageAfterCCI[13]),
													.input_Vth14(VoltageAfterCCI[14]),
													.input_Vth15(VoltageAfterCCI[15]),
			/*										.input_Vth16(VoltageAfterCCI[16]),
													.input_Vth17(VoltageAfterCCI[17]),
													.input_Vth18(VoltageAfterCCI[18]),
													.input_Vth19(VoltageAfterCCI[19]),
													.input_Vth20(VoltageAfterCCI[20]),
													.input_Vth21(VoltageAfterCCI[21]),
													.input_Vth22(VoltageAfterCCI[22]),
													.input_Vth23(VoltageAfterCCI[23]),
													.input_Vth24(VoltageAfterCCI[24]),
													.input_Vth25(VoltageAfterCCI[25]),
													.input_Vth26(VoltageAfterCCI[26]),
													.input_Vth27(VoltageAfterCCI[27]),
													.input_Vth28(VoltageAfterCCI[28]),
													.input_Vth29(VoltageAfterCCI[29]),
													.input_Vth30(VoltageAfterCCI[30]),
													.input_Vth31(VoltageAfterCCI[31]), */
													
													.outputVoltage(VoltageInputToRetention),
													.outputValid(CCIDoneFlag)

													);			
													
													
													
/************** using Rom **************************************************													
	Retention_Distortion Retention_uut	(
													.clk(clk),
													.reset(reset),
													.inputValid(CCIDoneFlag),	
												   .inputVoltage(VoltageInputToRetention),
													.outputVoltage(VoltageOutAfterRetention),
													.outputValid(RetentionDoneFlag)
													);
***************************************************************************/													
		 Retention_Distortion_UsingBoxMuller Retention_uut(
					.clk(clk),
					.reset(reset),
					.inputValid(CCIDoneFlag),
					.inputVoltage(VoltageInputToRetention),
					.outputVoltage(VoltageOutAfterRetention),
					.outputValid(RetentionDoneFlag)
				 );
	 
										
													
													
													
												
							//				assign 	VoltageToRetention = VoltageInputToRetention[31:16];


endmodule
