`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 		Singapore University of Technology and Design
// Engineer: 		Jiaying Wen (IDC)
// 
// Create Date:    13:30:56 05/10/2016 
// Design Name: 
// Module Name:    DataBuffer 
// Project Name: 	 NVMChannelModel
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
/**************************************************

 Name:  DataBufferAndCelltoCellInterence
 Date:  2016-05-10
 Describe:	32 32-bits data Serdes
 Port:	  	
***************************************************/

module DataBuffer( 	
							input 			clk,					
							input 			reset,				//
							input  [31:0]	dataIn,
							
							output [31:0]	DesDataOut0,	
							output [31:0]	DesDataOut1,				
							output [31:0]	DesDataOut2,				
							output [31:0]	DesDataOut3,				
							output [31:0]	DesDataOut4,				
							output [31:0]	DesDataOut5,				
							output [31:0]	DesDataOut6,				
							output [31:0]	DesDataOut7,				
							output [31:0]	DesDataOut8,				
							output [31:0]	DesDataOut9,				
							output [31:0]	DesDataOut10,				
							output [31:0]	DesDataOut11,				
							output [31:0]	DesDataOut12,				
							output [31:0]	DesDataOut13,				
							output [31:0]	DesDataOut14,				
							output [31:0]	DesDataOut15,				
/*							output [31:0]	DesDataOut16,				
							output [31:0]	DesDataOut17,				
							output [31:0]	DesDataOut18,				
							output [31:0]	DesDataOut19,				
							output [31:0]	DesDataOut20,				
							output [31:0]	DesDataOut21,				
							output [31:0]	DesDataOut22,				
							output [31:0]	DesDataOut23,				
							output [31:0]	DesDataOut24,				
							output [31:0]	DesDataOut25,				
							output [31:0]	DesDataOut26,				
							output [31:0]	DesDataOut27,				
							output [31:0]	DesDataOut28,				
							output [31:0]	DesDataOut29,				
							output [31:0]	DesDataOut30,				
							output [31:0]	DesDataOut31,		*/		
	
							output 			d_valid
						//	output [12:0]	wordLineCnt			//2^13=8192    	

						);
						
   parameter 			length_Bitline=16,	length_d=32;    	//17bits data   16bits origin voltage
	
	reg						 [length_d-1:0]	dataOut0;				//data  output
   reg						 [length_d-1:0]	dataOut1;				//data  output
	reg						 [length_d-1:0]	dataOut2;				//data  output
	reg						 [length_d-1:0]	dataOut3;				//data  output
	reg						 [length_d-1:0]	dataOut4;				//data  output
	reg						 [length_d-1:0]	dataOut5;				//data  output
	reg						 [length_d-1:0]	dataOut6;				//data  output
	reg						 [length_d-1:0]	dataOut7;				//data  output
	reg						 [length_d-1:0]	dataOut8;				//data  output
	reg						 [length_d-1:0]	dataOut9;				//data  output
	reg						 [length_d-1:0]	dataOut10;				//data  output
	reg						 [length_d-1:0]	dataOut11;				//data  output
	reg						 [length_d-1:0]	dataOut12;				//data  output
	reg						 [length_d-1:0]	dataOut13;				//data  output
	reg						 [length_d-1:0]	dataOut14;				//data  output
	reg						 [length_d-1:0]	dataOut15;				//data  output
/*	reg						 [length_d-1:0]	dataOut16;				//data  output
	reg						 [length_d-1:0]	dataOut17;				//data  output
	reg						 [length_d-1:0]	dataOut18;				//data  output
	reg						 [length_d-1:0]	dataOut19;				//data  output
	reg						 [length_d-1:0]	dataOut20;				//data  output
	reg						 [length_d-1:0]	dataOut21;				//data  output
	reg						 [length_d-1:0]	dataOut22;				//data  output
	reg						 [length_d-1:0]	dataOut23;				//data  output
	reg						 [length_d-1:0]	dataOut24;				//data  output
	reg						 [length_d-1:0]	dataOut25;				//data  output
	reg						 [length_d-1:0]	dataOut26;				//data  output
	reg						 [length_d-1:0]	dataOut27;				//data  output
	reg						 [length_d-1:0]	dataOut28;				//data  output
	reg						 [length_d-1:0]	dataOut29;				//data  output
	reg						 [length_d-1:0]	dataOut30;				//data  output
	reg						 [length_d-1:0]	dataOut31;				//data  output*/
	
	reg						 [3:0]				count10;
	reg												inputValid;
	
	reg						 [length_d-1:0]	buffer0[length_Bitline-1:0];
	reg						 [length_d-1:0]	buffer1[length_Bitline-1:0];
   reg    											dataValid;
	reg    					 						sel;

// CCI unit
	reg    											ready;
   reg    					[4:0] 				i;
//	reg 						[12:0]				wordLineCnt8191;	
	
	
	//******  discard the first 10 data , because the first serval data is invalid***********//	
		always @ (posedge clk or posedge reset)
		begin
			if(reset)
			begin
				inputValid <= 1'b0;
				count10    <= 4'b0;
				
			end
			else 
			begin
				if(inputValid)
					count10 <= count10;
				else if (!inputValid)
				begin
					count10 <= count10 + 4'b1;
					if (count10 == 4'd10)
						inputValid <= 1'b1;			
				end
			end
		end
	
	
	
	
	
    always @(posedge clk)
    begin 
			if (reset)
        	begin
				dataOut0<=0;
            dataOut1<=0;
				dataOut2<=0;
				dataOut3<=0;
				dataOut4<=0;
				dataOut5<=0;
				dataOut6<=0;
				dataOut7<=0;
				dataOut8<=0;
				dataOut9<=0;
				dataOut10<=0;
				dataOut11<=0;
				dataOut12<=0;
				dataOut13<=0;
				dataOut14<=0;
				dataOut15<=0;
/*				dataOut16<=0;
				dataOut17<=0;
				dataOut18<=0;
				dataOut19<=0;
				dataOut20<=0;
				dataOut21<=0;
				dataOut22<=0;
				dataOut23<=0;
				dataOut24<=0;
				dataOut25<=0;
				dataOut26<=0;
				dataOut27<=0;
				dataOut28<=0;
				dataOut29<=0;
				dataOut30<=0;
				dataOut31<=0;*/
				
//				wordLineCnt8191<= 13'b0;
				sel<=0; 
				dataValid <= 0;
				i<=0;
			end
			else if(!reset)
			begin
				if(inputValid==1'b1)
					begin  
					/****** sel=0 use buffer0 ***************/	
						if(sel==1'b0)
						begin	
							buffer0[i]<= dataIn;
							i<=i+ 5'b1;
							ready<=0;
						end						// if(inputValid==1'b0)
					/****** sel=1 use buffer1 ***************/
						else if (sel == 1'b1) //sel==1
						begin
							buffer1[i]<=dataIn;
							i<=i+5'b1;
							ready<=0;
						end						//end of if(inputValid==1'b1)
						
						if(i==length_Bitline-1)
						begin
							sel<= ~sel ;
							i<=0;
							ready<=1;    		//ready to output
						end					 	// end of if(i==length_Bitline-1)
						else if (i == 5'd1)
						begin
							dataValid <= 1'b0;
						end 					 
					
				if(ready==1)
				begin
					if(sel==1)
						begin

							dataOut0<=buffer0[0];
							dataOut1<=buffer0[1];
							dataOut2<=buffer0[2];
							dataOut3<=buffer0[3];
							dataOut4<=buffer0[4];
							dataOut5<=buffer0[5];
							dataOut6<=buffer0[6];
							dataOut7<=buffer0[7];
							dataOut8<=buffer0[8];
							dataOut9<=buffer0[9];
							dataOut10<=buffer0[10];
							dataOut11<=buffer0[11];
							dataOut12<=buffer0[12];
							dataOut13<=buffer0[13];
							dataOut14<=buffer0[14];
							dataOut15<=buffer0[15];
/*							dataOut16<=buffer0[16];
							dataOut17<=buffer0[17];
							dataOut18<=buffer0[18];
							dataOut19<=buffer0[19];
							dataOut20<=buffer0[20];
							dataOut21<=buffer0[21];
							dataOut22<=buffer0[22];
							dataOut23<=buffer0[23];
							dataOut24<=buffer0[24];
							dataOut25<=buffer0[25];
							dataOut26<=buffer0[26];
							dataOut27<=buffer0[27];
							dataOut28<=buffer0[28];
							dataOut29<=buffer0[29];
							dataOut30<=buffer0[30];
							dataOut31<=buffer0[31];*/
							
							dataValid<=1;
							
						end			//  end of if(sel==1)
					else 
						 begin  
							dataOut0<=buffer1[0];
							dataOut1<=buffer1[1];
							dataOut2<=buffer1[2];  
							dataOut3<=buffer1[3];
							dataOut4<=buffer1[4];
							dataOut5<=buffer1[5];
							dataOut6<=buffer1[6];
							dataOut7<=buffer1[7];
							dataOut8<=buffer1[8];
							dataOut9<=buffer1[9];
							dataOut10<=buffer1[10];
							dataOut11<=buffer1[11];
							dataOut12<=buffer1[12];
							dataOut13<=buffer1[13];
							dataOut14<=buffer1[14];
							dataOut15<=buffer1[15];
/*							dataOut16<=buffer1[16];
							dataOut17<=buffer1[17];
							dataOut18<=buffer1[18];
							dataOut19<=buffer1[19];
							dataOut20<=buffer1[20];
							dataOut21<=buffer1[21];
							dataOut22<=buffer1[22];
							dataOut23<=buffer1[23];
							dataOut24<=buffer1[24];
							dataOut25<=buffer1[25];
							dataOut26<=buffer1[26];
							dataOut27<=buffer1[27];
							dataOut28<=buffer1[28];
							dataOut29<=buffer1[29];
							dataOut30<=buffer1[30];
							dataOut31<=buffer1[31];
							*/
							dataValid<=1;
							
						 end			//  end of if(sel==0)
					ready  <=0;
/*					if (wordLineCnt8191 == 13'd8191)
						wordLineCnt8191  <= 13'b0;
					else
						wordLineCnt8191  <= wordLineCnt8191 + 13'b1;*/
					end	 			//  end of  if(ready==1)
			end						//  end of  if(inputValid==1'b1)
		end							//  end of  if(reset==0)	
	end		
		
		
//		assign  	  wordLineCnt = wordLineCnt8191;
		assign  	  d_valid     = dataValid;

		assign 	  DesDataOut0 = dataOut0;
		assign     DesDataOut1 = dataOut1;
		assign     DesDataOut2 = dataOut2;
		assign     DesDataOut3 = dataOut3;
		assign     DesDataOut4 = dataOut4;
		assign     DesDataOut5 = dataOut5;
		assign     DesDataOut6 = dataOut6;
		assign     DesDataOut7 = dataOut7;
		assign     DesDataOut8 = dataOut8;
		assign     DesDataOut9 = dataOut9;
		assign     DesDataOut10 = dataOut10;
		assign     DesDataOut11 = dataOut11;
		assign     DesDataOut12 = dataOut12;
		assign     DesDataOut13 = dataOut13;
		assign     DesDataOut14 = dataOut14;
		assign     DesDataOut15 = dataOut15;
/*		assign     DesDataOut16 = dataOut16;
		assign     DesDataOut17 = dataOut17;
		assign     DesDataOut18 = dataOut18;
		assign     DesDataOut19 = dataOut19;
		assign     DesDataOut20 = dataOut20;
		assign     DesDataOut21 = dataOut21;
		assign     DesDataOut22 = dataOut22;
		assign     DesDataOut23 = dataOut23;
		assign     DesDataOut24 = dataOut24;
		assign     DesDataOut25 = dataOut25;
		assign     DesDataOut26 = dataOut26;
		assign     DesDataOut27 = dataOut27;
		assign     DesDataOut28 = dataOut28;
		assign     DesDataOut29 = dataOut29;
		assign     DesDataOut30 = dataOut30;
		assign     DesDataOut31 = dataOut31;*/
		 
		
	
		
endmodule 
