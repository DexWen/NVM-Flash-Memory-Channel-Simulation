`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 			Singapore University of Technology and Design
// Engineer: 			Jiaying Wen (IDC)
// 
// Create Date:    11:24:40 05/12/2016 
// Design Name: 
// Module Name:    	CellToCell_Interference 
// Project Name: 		NVMChannelModel
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
 module CellToCell_Interference(
								input					clk,
								input    			reset,
								input					inputReady,
		//						input		[12:0]	WordLine_Cnt,	
								
								// 
								input		[31:0]	CCIinputData0,
								input		[31:0]	CCIinputData1,
								input		[31:0]	CCIinputData2,
								input		[31:0]	CCIinputData3,
								input		[31:0]	CCIinputData4,
								input		[31:0]	CCIinputData5,
								input		[31:0]	CCIinputData6,
								input		[31:0]	CCIinputData7,
								input		[31:0]	CCIinputData8,
								input		[31:0]	CCIinputData9,
								input		[31:0]	CCIinputData10,
								input		[31:0]	CCIinputData11,
								input		[31:0]	CCIinputData12,
								input		[31:0]	CCIinputData13,
								input		[31:0]	CCIinputData14,
								input		[31:0]	CCIinputData15,
/*								input		[31:0]	CCIinputData16,
								input		[31:0]	CCIinputData17,
								input		[31:0]	CCIinputData18,
								input		[31:0]	CCIinputData19,
								input		[31:0]	CCIinputData20,
								input		[31:0]	CCIinputData21,
								input		[31:0]	CCIinputData22,
								input		[31:0]	CCIinputData23,
								input		[31:0]	CCIinputData24,
								input		[31:0]	CCIinputData25,
								input		[31:0]	CCIinputData26,
								input		[31:0]	CCIinputData27,
								input		[31:0]	CCIinputData28,
								input		[31:0]	CCIinputData29,
								input		[31:0]	CCIinputData30,
								input		[31:0]	CCIinputData31,*/
								
								
								output	[31:0]	VthAfterCCI0,
								output	[31:0]	VthAfterCCI1,
								output	[31:0]	VthAfterCCI2,								
								output	[31:0]	VthAfterCCI3,
								output	[31:0]	VthAfterCCI4,
								output	[31:0]	VthAfterCCI5,
								output	[31:0]	VthAfterCCI6,
								output	[31:0]	VthAfterCCI7,
								output	[31:0]	VthAfterCCI8,
								output	[31:0]	VthAfterCCI9,
								output	[31:0]	VthAfterCCI10,
								output	[31:0]	VthAfterCCI11,
								output	[31:0]	VthAfterCCI12,
								output	[31:0]	VthAfterCCI13,
								output	[31:0]	VthAfterCCI14,
								output	[31:0]	VthAfterCCI15,
/*								output	[31:0]	VthAfterCCI16,
								output	[31:0]	VthAfterCCI17,
								output	[31:0]	VthAfterCCI18,
								output	[31:0]	VthAfterCCI19,
								output	[31:0]	VthAfterCCI20,
								output	[31:0]	VthAfterCCI21,
								output	[31:0]	VthAfterCCI22,
								output	[31:0]	VthAfterCCI23,
								output	[31:0]	VthAfterCCI24,
								output	[31:0]	VthAfterCCI25,
								output	[31:0]	VthAfterCCI26,
								output	[31:0]	VthAfterCCI27,
								output	[31:0]	VthAfterCCI28,
								output	[31:0]	VthAfterCCI29,
								output	[31:0]	VthAfterCCI30,
								output	[31:0]	VthAfterCCI31,*/
								
								output				CCI_Done
								);
			
		//***** get the programmed  voltage and  initial voltage  *******
		//********* 	programmed voltage    *******
		
			
			
			
			
			reg	[15:0]	DeltaVoltage 		[15:0];
			reg	[12:0]	WordLine_Cnt				;
			
			reg	[31:0]	PresentVoltage		[15:0];
			reg	[31:0]	PreviousVoltage	[15:0];
			reg				en;
			
			
			
			
			wire				cciDoneFlag			[15:0];
							
								
			always @ (posedge clk or posedge reset)
			begin
				if(reset)
				begin
					PresentVoltage[0] <= 0;
					PresentVoltage[1] <= 0;
					PresentVoltage[2] <= 0;
					PresentVoltage[3] <= 0;
					PresentVoltage[4] <= 0;
					PresentVoltage[5] <= 0;
					PresentVoltage[6] <= 0;
					PresentVoltage[7] <= 0;
					PresentVoltage[8] <= 0;
					PresentVoltage[9] <= 0;
					PresentVoltage[10] <= 0;
					PresentVoltage[11] <= 0;
					PresentVoltage[12] <= 0;
					PresentVoltage[13] <= 0;
					PresentVoltage[14] <= 0;
					PresentVoltage[15] <= 0;
	/*				PresentVoltage[16] <= 0;
					PresentVoltage[17] <= 0;
					PresentVoltage[18] <= 0;
					PresentVoltage[19] <= 0;
					PresentVoltage[20] <= 0;
					PresentVoltage[21] <= 0;
					PresentVoltage[22] <= 0;
					PresentVoltage[23] <= 0;
					PresentVoltage[24] <= 0;
					PresentVoltage[25] <= 0;
					PresentVoltage[26] <= 0;
					PresentVoltage[27] <= 0;
					PresentVoltage[28] <= 0;
					PresentVoltage[29] <= 0;
					PresentVoltage[30] <= 0;
					PresentVoltage[31] <= 0;*/
					
					PreviousVoltage[0]<=0;	
					PreviousVoltage[1]<=0;
					PreviousVoltage[2]<=0;
					PreviousVoltage[3]<=0;
					PreviousVoltage[4]<=0;
					PreviousVoltage[5]<=0;
					PreviousVoltage[6]<=0;
					PreviousVoltage[7]<=0;
					PreviousVoltage[8]<=0;
					PreviousVoltage[9]<=0;
					PreviousVoltage[10]<=0;
					PreviousVoltage[11]<=0;
					PreviousVoltage[12]<=0;
					PreviousVoltage[13]<=0;
					PreviousVoltage[14]<=0;
					PreviousVoltage[15]<=0;
/*					PreviousVoltage[16]<=0;
					PreviousVoltage[17]<=0;
					PreviousVoltage[18]<=0;
					PreviousVoltage[19]<=0;
					PreviousVoltage[20]<=0;
					PreviousVoltage[21]<=0;
					PreviousVoltage[22]<=0;
					PreviousVoltage[23]<=0;
					PreviousVoltage[24]<=0;
					PreviousVoltage[25]<=0;
					PreviousVoltage[26]<=0;
					PreviousVoltage[27]<=0;
					PreviousVoltage[28]<=0;
					PreviousVoltage[29]<=0;
					PreviousVoltage[30]<=0;
					PreviousVoltage[31]<=0;*/
					WordLine_Cnt       <=0;									
					en 					 <= 1'b0;
				end	
				else 
				begin
					if(inputReady)
					begin
						if (WordLine_Cnt==13'b0)
						begin
							PresentVoltage[0]  <= CCIinputData0[31:0];
							PresentVoltage[1]  <= CCIinputData1[31:0];
							PresentVoltage[2]  <= CCIinputData2[31:0];
							PresentVoltage[3]  <= CCIinputData3[31:0];
							PresentVoltage[4]  <= CCIinputData4[31:0];
							PresentVoltage[5]  <= CCIinputData5[31:0];
							PresentVoltage[6]  <= CCIinputData6[31:0];
							PresentVoltage[7]  <= CCIinputData7[31:0];
							PresentVoltage[8]  <= CCIinputData8[31:0];
							PresentVoltage[9]  <= CCIinputData9[31:0];
							PresentVoltage[10] <= CCIinputData10[31:0];
							PresentVoltage[11] <= CCIinputData11[31:0];
							PresentVoltage[12] <= CCIinputData12[31:0];
							PresentVoltage[13] <= CCIinputData13[31:0];
							PresentVoltage[14] <= CCIinputData14[31:0];
							PresentVoltage[15] <= CCIinputData15[31:0];
/*							PresentVoltage[16] <= CCIinputData16[31:0];
							PresentVoltage[17] <= CCIinputData17[31:0];
							PresentVoltage[18] <= CCIinputData18[31:0];
							PresentVoltage[19] <= CCIinputData19[31:0];
							PresentVoltage[20] <= CCIinputData20[31:0];
							PresentVoltage[21] <= CCIinputData21[31:0];
							PresentVoltage[22] <= CCIinputData22[31:0];
							PresentVoltage[23] <= CCIinputData23[31:0];
							PresentVoltage[24] <= CCIinputData24[31:0];
							PresentVoltage[25] <= CCIinputData25[31:0];
							PresentVoltage[26] <= CCIinputData26[31:0];
							PresentVoltage[27] <= CCIinputData27[31:0];
							PresentVoltage[28] <= CCIinputData28[31:0];
							PresentVoltage[29] <= CCIinputData29[31:0];
							PresentVoltage[30] <= CCIinputData30[31:0];
							PresentVoltage[31] <= CCIinputData31[31:0]; */
							
							PreviousVoltage[0]<=PresentVoltage[0];	
							PreviousVoltage[1]<=PresentVoltage[1];
							PreviousVoltage[2]<=PresentVoltage[2];
							PreviousVoltage[3]<=PresentVoltage[3];
							PreviousVoltage[4]<=PresentVoltage[4];
							PreviousVoltage[5]<=PresentVoltage[5];
							PreviousVoltage[6]<=PresentVoltage[6];
							PreviousVoltage[7]<=PresentVoltage[7];
							PreviousVoltage[8]<=PresentVoltage[8];
							PreviousVoltage[9]<=PresentVoltage[9];
							PreviousVoltage[10]<=PresentVoltage[10];
							PreviousVoltage[11]<=PresentVoltage[11];
							PreviousVoltage[12]<=PresentVoltage[12];
							PreviousVoltage[13]<=PresentVoltage[13];
							PreviousVoltage[14]<=PresentVoltage[14];
							PreviousVoltage[15]<=PresentVoltage[15];
/*							PreviousVoltage[16]<=PresentVoltage[16];
							PreviousVoltage[17]<=PresentVoltage[17];
							PreviousVoltage[18]<=PresentVoltage[18];
							PreviousVoltage[19]<=PresentVoltage[19];
							PreviousVoltage[20]<=PresentVoltage[20];
							PreviousVoltage[21]<=PresentVoltage[21];
							PreviousVoltage[22]<=PresentVoltage[22];
							PreviousVoltage[23]<=PresentVoltage[23];
							PreviousVoltage[24]<=PresentVoltage[24];
							PreviousVoltage[25]<=PresentVoltage[25];
							PreviousVoltage[26]<=PresentVoltage[26];
							PreviousVoltage[27]<=PresentVoltage[27];
							PreviousVoltage[28]<=PresentVoltage[28];
							PreviousVoltage[29]<=PresentVoltage[29];
							PreviousVoltage[30]<=PresentVoltage[30];
							PreviousVoltage[31]<=PresentVoltage[31];*/
							
							DeltaVoltage[0] <=  0;		
							DeltaVoltage[1]  <= 0;
							DeltaVoltage[2]  <= 0;
							DeltaVoltage[3]  <= 0;
							DeltaVoltage[4]  <= 0;
							DeltaVoltage[5]  <= 0;
							DeltaVoltage[6]  <= 0;
							DeltaVoltage[7]  <= 0;
							DeltaVoltage[8]  <= 0;
							DeltaVoltage[9]  <= 0;
							DeltaVoltage[10] <= 0;
							DeltaVoltage[11] <= 0;
							DeltaVoltage[12] <= 0;
							DeltaVoltage[13] <= 0;
							DeltaVoltage[14] <= 0;
							DeltaVoltage[15] <= 0;
/*							DeltaVoltage[16] <= 0;
							DeltaVoltage[17] <= 0;
							DeltaVoltage[18] <= 0;
							DeltaVoltage[19] <= 0;
							DeltaVoltage[20] <= 0;
							DeltaVoltage[21] <= 0;
							DeltaVoltage[22] <= 0;
							DeltaVoltage[23] <= 0;
							DeltaVoltage[24] <= 0;
							DeltaVoltage[25] <= 0;
							DeltaVoltage[26] <= 0;
							DeltaVoltage[27] <= 0;
							DeltaVoltage[28] <= 0;
							DeltaVoltage[29] <= 0;
							DeltaVoltage[30] <= 0;
							DeltaVoltage[31] <= 0;*/
							
							en <= 1'b1;

							
						end	//end of if (WordLine_Cnt==13'b0)	
						
						else	//if (13'd0<WordLine_Cnt)
						begin 
							PreviousVoltage[0]<=PresentVoltage[0];	
							PreviousVoltage[1]<=PresentVoltage[1];
							PreviousVoltage[2]<=PresentVoltage[2];
							PreviousVoltage[3]<=PresentVoltage[3];
							PreviousVoltage[4]<=PresentVoltage[4];
							PreviousVoltage[5]<=PresentVoltage[5];
							PreviousVoltage[6]<=PresentVoltage[6];
							PreviousVoltage[7]<=PresentVoltage[7];
							PreviousVoltage[8]<=PresentVoltage[8];
							PreviousVoltage[9]<=PresentVoltage[9];
							PreviousVoltage[10]<=PresentVoltage[10];
							PreviousVoltage[11]<=PresentVoltage[11];
							PreviousVoltage[12]<=PresentVoltage[12];
							PreviousVoltage[13]<=PresentVoltage[13];
							PreviousVoltage[14]<=PresentVoltage[14];
							PreviousVoltage[15]<=PresentVoltage[15];
/*							PreviousVoltage[16]<=PresentVoltage[16];
							PreviousVoltage[17]<=PresentVoltage[17];
							PreviousVoltage[18]<=PresentVoltage[18];
							PreviousVoltage[19]<=PresentVoltage[19];
							PreviousVoltage[20]<=PresentVoltage[20];
							PreviousVoltage[21]<=PresentVoltage[21];
							PreviousVoltage[22]<=PresentVoltage[22];
							PreviousVoltage[23]<=PresentVoltage[23];
							PreviousVoltage[24]<=PresentVoltage[24];
							PreviousVoltage[25]<=PresentVoltage[25];
							PreviousVoltage[26]<=PresentVoltage[26];
							PreviousVoltage[27]<=PresentVoltage[27];
							PreviousVoltage[28]<=PresentVoltage[28];
							PreviousVoltage[29]<=PresentVoltage[29];
							PreviousVoltage[30]<=PresentVoltage[30];
							PreviousVoltage[31]<=PresentVoltage[31];*/
							
							PresentVoltage[0]  <= CCIinputData0[31:0];
							PresentVoltage[1]  <= CCIinputData1[31:0];
							PresentVoltage[2]  <= CCIinputData2[31:0];
							PresentVoltage[3]  <= CCIinputData3[31:0];
							PresentVoltage[4]  <= CCIinputData4[31:0];
							PresentVoltage[5]  <= CCIinputData5[31:0];
							PresentVoltage[6]  <= CCIinputData6[31:0];
							PresentVoltage[7]  <= CCIinputData7[31:0];
							PresentVoltage[8]  <= CCIinputData8[31:0];
							PresentVoltage[9]  <= CCIinputData9[31:0];
							PresentVoltage[10] <= CCIinputData10[31:0];
							PresentVoltage[11] <= CCIinputData11[31:0];
							PresentVoltage[12] <= CCIinputData12[31:0];
							PresentVoltage[13] <= CCIinputData13[31:0];
							PresentVoltage[14] <= CCIinputData14[31:0];
							PresentVoltage[15] <= CCIinputData15[31:0];
/*							PresentVoltage[16] <= CCIinputData16[31:0];
							PresentVoltage[17] <= CCIinputData17[31:0];
							PresentVoltage[18] <= CCIinputData18[31:0];
							PresentVoltage[19] <= CCIinputData19[31:0];
							PresentVoltage[20] <= CCIinputData20[31:0];
							PresentVoltage[21] <= CCIinputData21[31:0];
							PresentVoltage[22] <= CCIinputData22[31:0];
							PresentVoltage[23] <= CCIinputData23[31:0];
							PresentVoltage[24] <= CCIinputData24[31:0];
							PresentVoltage[25] <= CCIinputData25[31:0];
							PresentVoltage[26] <= CCIinputData26[31:0];
							PresentVoltage[27] <= CCIinputData27[31:0];
							PresentVoltage[28] <= CCIinputData28[31:0];
							PresentVoltage[29] <= CCIinputData29[31:0];
							PresentVoltage[30] <= CCIinputData30[31:0];
							PresentVoltage[31] <= CCIinputData31[31:0];*/
							
							DeltaVoltage[0] <= CCIinputData0[31:16]-CCIinputData0[15:0];		
							DeltaVoltage[1]  <= CCIinputData1[31:16]-CCIinputData1[15:0];
							DeltaVoltage[2]  <= CCIinputData2[31:16]-CCIinputData2[15:0];
							DeltaVoltage[3]  <= CCIinputData3[31:16]-CCIinputData3[15:0];
							DeltaVoltage[4]  <= CCIinputData4[31:16]-CCIinputData4[15:0];
							DeltaVoltage[5]  <= CCIinputData5[31:16]-CCIinputData5[15:0];
							DeltaVoltage[6]  <= CCIinputData6[31:16]-CCIinputData6[15:0];
							DeltaVoltage[7]  <= CCIinputData7[31:16]-CCIinputData7[15:0];
							DeltaVoltage[8]  <= CCIinputData8[31:16]-CCIinputData8[15:0];
							DeltaVoltage[9]  <= CCIinputData9[31:16]-CCIinputData9[15:0];
							DeltaVoltage[10] <= CCIinputData10[31:16]-CCIinputData10[15:0];
							DeltaVoltage[11] <= CCIinputData11[31:16]-CCIinputData11[15:0];
							DeltaVoltage[12] <= CCIinputData12[31:16]-CCIinputData12[15:0];
							DeltaVoltage[13] <= CCIinputData13[31:16]-CCIinputData13[15:0];
							DeltaVoltage[14] <= CCIinputData14[31:16]-CCIinputData14[15:0];
							DeltaVoltage[15] <= CCIinputData15[31:16]-CCIinputData15[15:0];
/*							DeltaVoltage[16] <= CCIinputData16[31:16]-CCIinputData16[15:0];
							DeltaVoltage[17] <= CCIinputData17[31:16]-CCIinputData17[15:0];
							DeltaVoltage[18] <= CCIinputData18[31:16]-CCIinputData18[15:0];
							DeltaVoltage[19] <= CCIinputData19[31:16]-CCIinputData19[15:0];
							DeltaVoltage[20] <= CCIinputData20[31:16]-CCIinputData20[15:0];
							DeltaVoltage[21] <= CCIinputData21[31:16]-CCIinputData21[15:0];
							DeltaVoltage[22] <= CCIinputData22[31:16]-CCIinputData22[15:0];
							DeltaVoltage[23] <= CCIinputData23[31:16]-CCIinputData23[15:0];
							DeltaVoltage[24] <= CCIinputData24[31:16]-CCIinputData24[15:0];
							DeltaVoltage[25] <= CCIinputData25[31:16]-CCIinputData25[15:0];
							DeltaVoltage[26] <= CCIinputData26[31:16]-CCIinputData26[15:0];
							DeltaVoltage[27] <= CCIinputData27[31:16]-CCIinputData27[15:0];
							DeltaVoltage[28] <= CCIinputData28[31:16]-CCIinputData28[15:0];
							DeltaVoltage[29] <= CCIinputData29[31:16]-CCIinputData29[15:0];
							DeltaVoltage[30] <= CCIinputData30[31:16]-CCIinputData30[15:0];
							DeltaVoltage[31] <= CCIinputData31[31:16]-CCIinputData31[15:0];*/
													
							en <= 1'b1;
						end	//end of (13'd0<WordLine_Cnt < 13'd8191)
						WordLine_Cnt   <= WordLine_Cnt + 13'b1;
						if(WordLine_Cnt == 13'd8191)
							WordLine_Cnt   <=13'd0;
						
					end		//end of if(inputReady)
					else
					begin
						en <= 1'b0;
					end
				end			//end of else if(!reset)
			end				//end of always
			
			CCI_distortionUnit 	 	cell_0(.clk(clk),  .en(en), .affectedCellVoltage(PreviousVoltage[0]),  .XY_CCI_left(16'd0),            .Y_CCI(DeltaVoltage[0]),  .XY_CCI_right(DeltaVoltage[1] ),  .VlotageAferCCI(VthAfterCCI0),  .cciDone(cciDoneFlag[0]));	
			CCI_distortionUnit 	 	cell_1(.clk(clk),  .en(en), .affectedCellVoltage(PreviousVoltage[1]),  .XY_CCI_left(DeltaVoltage[0]),  .Y_CCI(DeltaVoltage[1]),  .XY_CCI_right(DeltaVoltage[2] ),  .VlotageAferCCI(VthAfterCCI1),  .cciDone(cciDoneFlag[1]));	
			CCI_distortionUnit		cell_2(.clk(clk),  .en(en), .affectedCellVoltage(PreviousVoltage[2]),  .XY_CCI_left(DeltaVoltage[1]),  .Y_CCI(DeltaVoltage[2]),  .XY_CCI_right(DeltaVoltage[3] ),  .VlotageAferCCI(VthAfterCCI2),  .cciDone(cciDoneFlag[2]));
			CCI_distortionUnit		cell_3(.clk(clk),  .en(en), .affectedCellVoltage(PreviousVoltage[3]),  .XY_CCI_left(DeltaVoltage[2]),  .Y_CCI(DeltaVoltage[3]),  .XY_CCI_right(DeltaVoltage[4] ),  .VlotageAferCCI(VthAfterCCI3),  .cciDone(cciDoneFlag[3]));
			CCI_distortionUnit		cell_4(.clk(clk),  .en(en), .affectedCellVoltage(PreviousVoltage[4]),  .XY_CCI_left(DeltaVoltage[3]),  .Y_CCI(DeltaVoltage[4]),  .XY_CCI_right(DeltaVoltage[5] ),  .VlotageAferCCI(VthAfterCCI4),  .cciDone(cciDoneFlag[4]));
			CCI_distortionUnit		cell_5(.clk(clk),  .en(en), .affectedCellVoltage(PreviousVoltage[5]),  .XY_CCI_left(DeltaVoltage[4]),  .Y_CCI(DeltaVoltage[5]),  .XY_CCI_right(DeltaVoltage[6] ),  .VlotageAferCCI(VthAfterCCI5),  .cciDone(cciDoneFlag[5]));
			CCI_distortionUnit		cell_6(.clk(clk),  .en(en), .affectedCellVoltage(PreviousVoltage[6]),  .XY_CCI_left(DeltaVoltage[5]),  .Y_CCI(DeltaVoltage[6]),  .XY_CCI_right(DeltaVoltage[7] ),  .VlotageAferCCI(VthAfterCCI6),  .cciDone(cciDoneFlag[6]));
			CCI_distortionUnit		cell_7(.clk(clk),  .en(en), .affectedCellVoltage(PreviousVoltage[7]),  .XY_CCI_left(DeltaVoltage[6]),  .Y_CCI(DeltaVoltage[7]),  .XY_CCI_right(DeltaVoltage[8] ),  .VlotageAferCCI(VthAfterCCI7),  .cciDone(cciDoneFlag[7]));
			CCI_distortionUnit		cell_8(.clk(clk),  .en(en), .affectedCellVoltage(PreviousVoltage[8]),  .XY_CCI_left(DeltaVoltage[7]),  .Y_CCI(DeltaVoltage[8]),  .XY_CCI_right(DeltaVoltage[9] ),  .VlotageAferCCI(VthAfterCCI8),  .cciDone(cciDoneFlag[8]));
			CCI_distortionUnit		cell_9(.clk(clk),  .en(en), .affectedCellVoltage(PreviousVoltage[9]),  .XY_CCI_left(DeltaVoltage[8]),  .Y_CCI(DeltaVoltage[9]),  .XY_CCI_right(DeltaVoltage[10] ), .VlotageAferCCI(VthAfterCCI9),  .cciDone(cciDoneFlag[9]));
			CCI_distortionUnit		cell_10(.clk(clk), .en(en), .affectedCellVoltage(PreviousVoltage[10]), .XY_CCI_left(DeltaVoltage[9]),  .Y_CCI(DeltaVoltage[10]), .XY_CCI_right(DeltaVoltage[11] ), .VlotageAferCCI(VthAfterCCI10), .cciDone(cciDoneFlag[10]));
			CCI_distortionUnit		cell_11(.clk(clk), .en(en), .affectedCellVoltage(PreviousVoltage[11]), .XY_CCI_left(DeltaVoltage[10]), .Y_CCI(DeltaVoltage[11]), .XY_CCI_right(DeltaVoltage[12] ), .VlotageAferCCI(VthAfterCCI11), .cciDone(cciDoneFlag[11]));
			CCI_distortionUnit		cell_12(.clk(clk), .en(en), .affectedCellVoltage(PreviousVoltage[12]), .XY_CCI_left(DeltaVoltage[11]), .Y_CCI(DeltaVoltage[12]), .XY_CCI_right(DeltaVoltage[13] ), .VlotageAferCCI(VthAfterCCI12), .cciDone(cciDoneFlag[12]));
			CCI_distortionUnit		cell_13(.clk(clk), .en(en), .affectedCellVoltage(PreviousVoltage[13]), .XY_CCI_left(DeltaVoltage[12]), .Y_CCI(DeltaVoltage[13]), .XY_CCI_right(DeltaVoltage[14] ), .VlotageAferCCI(VthAfterCCI13), .cciDone(cciDoneFlag[13]));
			CCI_distortionUnit		cell_14(.clk(clk), .en(en), .affectedCellVoltage(PreviousVoltage[14]), .XY_CCI_left(DeltaVoltage[13]), .Y_CCI(DeltaVoltage[14]), .XY_CCI_right(DeltaVoltage[15] ), .VlotageAferCCI(VthAfterCCI14), .cciDone(cciDoneFlag[14]));
			CCI_distortionUnit		cell_15(.clk(clk), .en(en), .affectedCellVoltage(PreviousVoltage[15]), .XY_CCI_left(DeltaVoltage[14]), .Y_CCI(DeltaVoltage[15]), .XY_CCI_right(16'd0 ), 				 .VlotageAferCCI(VthAfterCCI15), .cciDone(cciDoneFlag[15]));
/*			CCI_distortion		cell_16(.clk(clk), .en(en), .affectedCellVoltage(PreviousVoltage[16]), .XY_CCI_left(DeltaVoltage[15]), .Y_CCI(DeltaVoltage[16]), .XY_CCI_right(DeltaVoltage[17] ), .VlotageAferCCI(VthAfterCCI16), .cciDone(cciDoneFlag[16]));
			CCI_distortion		cell_17(.clk(clk), .en(en), .affectedCellVoltage(PreviousVoltage[17]), .XY_CCI_left(DeltaVoltage[16]), .Y_CCI(DeltaVoltage[17]), .XY_CCI_right(DeltaVoltage[18] ), .VlotageAferCCI(VthAfterCCI17), .cciDone(cciDoneFlag[17]));
			CCI_distortion		cell_18(.clk(clk), .en(en), .affectedCellVoltage(PreviousVoltage[18]), .XY_CCI_left(DeltaVoltage[17]), .Y_CCI(DeltaVoltage[18]), .XY_CCI_right(DeltaVoltage[19] ), .VlotageAferCCI(VthAfterCCI18), .cciDone(cciDoneFlag[18]));
			CCI_distortion		cell_19(.clk(clk), .en(en), .affectedCellVoltage(PreviousVoltage[19]), .XY_CCI_left(DeltaVoltage[18]), .Y_CCI(DeltaVoltage[19]), .XY_CCI_right(DeltaVoltage[20] ), .VlotageAferCCI(VthAfterCCI19), .cciDone(cciDoneFlag[19]));
			CCI_distortion		cell_20(.clk(clk), .en(en), .affectedCellVoltage(PreviousVoltage[20]), .XY_CCI_left(DeltaVoltage[19]), .Y_CCI(DeltaVoltage[20]), .XY_CCI_right(DeltaVoltage[21] ), .VlotageAferCCI(VthAfterCCI20), .cciDone(cciDoneFlag[20]));
			CCI_distortion		cell_21(.clk(clk), .en(en), .affectedCellVoltage(PreviousVoltage[21]), .XY_CCI_left(DeltaVoltage[20]), .Y_CCI(DeltaVoltage[21]), .XY_CCI_right(DeltaVoltage[22] ), .VlotageAferCCI(VthAfterCCI21), .cciDone(cciDoneFlag[21]));
			CCI_distortion		cell_22(.clk(clk), .en(en), .affectedCellVoltage(PreviousVoltage[22]), .XY_CCI_left(DeltaVoltage[21]), .Y_CCI(DeltaVoltage[22]), .XY_CCI_right(DeltaVoltage[23] ), .VlotageAferCCI(VthAfterCCI22), .cciDone(cciDoneFlag[22]));
			CCI_distortion		cell_23(.clk(clk), .en(en), .affectedCellVoltage(PreviousVoltage[23]), .XY_CCI_left(DeltaVoltage[22]), .Y_CCI(DeltaVoltage[23]), .XY_CCI_right(DeltaVoltage[24] ), .VlotageAferCCI(VthAfterCCI23), .cciDone(cciDoneFlag[23]));
			CCI_distortion		cell_24(.clk(clk), .en(en), .affectedCellVoltage(PreviousVoltage[24]), .XY_CCI_left(DeltaVoltage[23]), .Y_CCI(DeltaVoltage[24]), .XY_CCI_right(DeltaVoltage[25] ), .VlotageAferCCI(VthAfterCCI24), .cciDone(cciDoneFlag[24]));
			CCI_distortion		cell_25(.clk(clk), .en(en), .affectedCellVoltage(PreviousVoltage[25]), .XY_CCI_left(DeltaVoltage[24]), .Y_CCI(DeltaVoltage[25]), .XY_CCI_right(DeltaVoltage[26] ), .VlotageAferCCI(VthAfterCCI25), .cciDone(cciDoneFlag[25]));
			CCI_distortion		cell_26(.clk(clk), .en(en), .affectedCellVoltage(PreviousVoltage[26]), .XY_CCI_left(DeltaVoltage[25]), .Y_CCI(DeltaVoltage[26]), .XY_CCI_right(DeltaVoltage[27] ), .VlotageAferCCI(VthAfterCCI26), .cciDone(cciDoneFlag[26]));
			CCI_distortion		cell_27(.clk(clk), .en(en), .affectedCellVoltage(PreviousVoltage[27]), .XY_CCI_left(DeltaVoltage[26]), .Y_CCI(DeltaVoltage[27]), .XY_CCI_right(DeltaVoltage[28] ), .VlotageAferCCI(VthAfterCCI27), .cciDone(cciDoneFlag[27]));
			CCI_distortion		cell_28(.clk(clk), .en(en), .affectedCellVoltage(PreviousVoltage[28]), .XY_CCI_left(DeltaVoltage[27]), .Y_CCI(DeltaVoltage[28]), .XY_CCI_right(DeltaVoltage[29] ), .VlotageAferCCI(VthAfterCCI28), .cciDone(cciDoneFlag[28]));
			CCI_distortion		cell_29(.clk(clk), .en(en), .affectedCellVoltage(PreviousVoltage[29]), .XY_CCI_left(DeltaVoltage[28]), .Y_CCI(DeltaVoltage[29]), .XY_CCI_right(DeltaVoltage[30] ), .VlotageAferCCI(VthAfterCCI29), .cciDone(cciDoneFlag[29]));
			CCI_distortion		cell_30(.clk(clk), .en(en), .affectedCellVoltage(PreviousVoltage[30]), .XY_CCI_left(DeltaVoltage[29]), .Y_CCI(DeltaVoltage[30]), .XY_CCI_right(DeltaVoltage[31] ), .VlotageAferCCI(VthAfterCCI30), .cciDone(cciDoneFlag[30]));
			CCI_distortion		cell_31(.clk(clk), .en(en), .affectedCellVoltage(PreviousVoltage[31]), .XY_CCI_left(DeltaVoltage[30]), .Y_CCI(DeltaVoltage[31]), .XY_CCI_right(16'd0 ),            .VlotageAferCCI(VthAfterCCI31), .cciDone(cciDoneFlag[31]));
*/

	assign  CCI_Done = cciDoneFlag[0] && cciDoneFlag[1] && cciDoneFlag[2] && cciDoneFlag[3] && cciDoneFlag[4] && cciDoneFlag[5] && cciDoneFlag[6] && cciDoneFlag[7] && cciDoneFlag[8] && cciDoneFlag[9] && cciDoneFlag[10] && cciDoneFlag[11] && cciDoneFlag[12] && cciDoneFlag[13] && cciDoneFlag[14] && cciDoneFlag[15] ; // && cciDoneFlag[16] && cciDoneFlag[17] && cciDoneFlag[18] && cciDoneFlag[19] && cciDoneFlag[20] && cciDoneFlag[21] && cciDoneFlag[22] && cciDoneFlag[23] && cciDoneFlag[24] &&  cciDoneFlag[25] && cciDoneFlag[26] && cciDoneFlag[27] && cciDoneFlag[28] && cciDoneFlag[29] && cciDoneFlag[30] && cciDoneFlag[31];


endmodule
