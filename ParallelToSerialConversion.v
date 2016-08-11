`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:        Singapore University of Technology and Design
// Engineer: 		 Jiaying Wen (IDC)	
// 
// Create Date:    10:57:59 05/18/2016 
// Design Name: 
// Module Name:    ParallelToSerialConversion 
// Project Name:   NVMChannelModel
// Target Devices: 
// Tool versions: 
// Description:    32 parallel input serial output
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ParallelToSerialConversion(
											input					clk,
											input					reset,
											input					inputValid,
												
											input 	[31:0]	input_Vth0,
											input 	[31:0]	input_Vth1,
											input 	[31:0]	input_Vth2,
											input 	[31:0]	input_Vth3,
											input 	[31:0]	input_Vth4,
											input 	[31:0]	input_Vth5,
											input 	[31:0]	input_Vth6,
											input 	[31:0]	input_Vth7,
											input 	[31:0]	input_Vth8,
											input 	[31:0]	input_Vth9,
											input 	[31:0]	input_Vth10,
											input 	[31:0]	input_Vth11,
											input 	[31:0]	input_Vth12,
											input 	[31:0]	input_Vth13,
											input 	[31:0]	input_Vth14,
											input 	[31:0]	input_Vth15,
								/*			input 	[31:0]	input_Vth16,
											input 	[31:0]	input_Vth17,
											input 	[31:0]	input_Vth18,
											input 	[31:0]	input_Vth19,
											input 	[31:0]	input_Vth20,
											input 	[31:0]	input_Vth21,
											input 	[31:0]	input_Vth22,
											input 	[31:0]	input_Vth23,
											input 	[31:0]	input_Vth24,
											input 	[31:0]	input_Vth25,
											input 	[31:0]	input_Vth26,
											input 	[31:0]	input_Vth27,
											input 	[31:0]	input_Vth28,
											input 	[31:0]	input_Vth29,
											input 	[31:0]	input_Vth30,
											input 	[31:0]	input_Vth31,*/

												
											output 	[31:0]	outputVoltage,
											output 				outputValid
								);
								
		reg		[31:0]	dataTmp0		[15:0];						
		reg		[31:0]	dataTmp1		[15:0];
		reg					sel;
		reg		[3:0]		i;
		reg					ready;
		reg		[31:0]	outputVoltagTmp;
		reg					dataValid;
		
		always @ (posedge clk or posedge reset)
		begin
			if(reset)
			begin
				outputVoltagTmp <= 31'd0;
				dataValid     <= 1'b0;
				i				  <= 4'b0 ;
				sel			  <= 1'b0;
				ready			  <= 1'b0;
			end
				
			else 
			begin
				if(inputValid)
				begin
					if(sel == 1'b0)
					begin
						dataTmp0[0]  <= 	input_Vth0;
						dataTmp0[1]  <= 	input_Vth1;
						dataTmp0[2]  <= 	input_Vth2;
						dataTmp0[3]  <= 	input_Vth3;
						dataTmp0[4]  <= 	input_Vth4;
						dataTmp0[5]  <= 	input_Vth5;
						dataTmp0[6]  <= 	input_Vth6;
						dataTmp0[7]  <= 	input_Vth7;
						dataTmp0[8]  <= 	input_Vth8;
						dataTmp0[9]  <= 	input_Vth9;
						dataTmp0[10] <= 	input_Vth10;
						dataTmp0[11] <= 	input_Vth11;
						dataTmp0[12] <= 	input_Vth12;
						dataTmp0[13] <= 	input_Vth13;
						dataTmp0[14] <= 	input_Vth14;
						dataTmp0[15] <= 	input_Vth15;
/*						dataTmp0[16] <= 	input_Vth16;
						dataTmp0[17] <= 	input_Vth17;
						dataTmp0[18] <= 	input_Vth18;
						dataTmp0[19] <= 	input_Vth19;
						dataTmp0[20] <= 	input_Vth20;
						dataTmp0[21] <= 	input_Vth21;
						dataTmp0[22] <= 	input_Vth22;
						dataTmp0[23] <= 	input_Vth23;
						dataTmp0[24] <= 	input_Vth24;
						dataTmp0[25] <= 	input_Vth25;
						dataTmp0[26] <= 	input_Vth26;
						dataTmp0[27] <= 	input_Vth27;
						dataTmp0[28] <= 	input_Vth28;
						dataTmp0[29] <= 	input_Vth29;
						dataTmp0[30] <= 	input_Vth30;
						dataTmp0[31] <= 	input_Vth31;*/
						ready        <=   1'b1;
						sel			 <=   1'b1;
						i				 <=   4'd0;
					end   // end of if(sel == 1'b0)
					else 
					begin
						dataTmp1[0]  <= 	input_Vth0;
						dataTmp1[1]  <= 	input_Vth1;
						dataTmp1[2]  <= 	input_Vth2;
						dataTmp1[3]  <= 	input_Vth3;
						dataTmp1[4]  <= 	input_Vth4;
						dataTmp1[5]  <= 	input_Vth5;
						dataTmp1[6]  <= 	input_Vth6;
						dataTmp1[7]  <= 	input_Vth7;
						dataTmp1[8]  <= 	input_Vth8;
						dataTmp1[9]  <= 	input_Vth9;
						dataTmp1[10] <= 	input_Vth10;
						dataTmp1[11] <= 	input_Vth11;
						dataTmp1[12] <= 	input_Vth12;
						dataTmp1[13] <= 	input_Vth13;
						dataTmp1[14] <= 	input_Vth14;
						dataTmp1[15] <= 	input_Vth15;
/*						dataTmp1[16] <= 	input_Vth16;
						dataTmp1[17] <= 	input_Vth17;
						dataTmp1[18] <= 	input_Vth18;
						dataTmp1[19] <= 	input_Vth19;
						dataTmp1[20] <= 	input_Vth20;
						dataTmp1[21] <= 	input_Vth21;
						dataTmp1[22] <= 	input_Vth22;
						dataTmp1[23] <= 	input_Vth23;
						dataTmp1[24] <= 	input_Vth24;
						dataTmp1[25] <= 	input_Vth25;
						dataTmp1[26] <= 	input_Vth26;
						dataTmp1[27] <= 	input_Vth27;
						dataTmp1[28] <= 	input_Vth28;
						dataTmp1[29] <= 	input_Vth29;
						dataTmp1[30] <= 	input_Vth30;
						dataTmp1[31] <= 	input_Vth31;*/
						ready        <=   1'b1;
						sel			 <=   1'b0;
						i            <=   4'd0;
					end	// end of if(sel == 1'b1)
				end 		// end of if(inputValid)
				
				if (ready == 1'b1)
				begin
				   if(sel == 1'b1)
					begin
						outputVoltagTmp 	<= 	dataTmp0[i];
						i 						<= 	i+1'b1;
						dataValid     		<= 	1'b1;
					end	//end of  if(sel == 1'b1)
					else
					begin
						outputVoltagTmp 	<= 	dataTmp1[i];
						i 						<= 	i+1'b1;
						dataValid     		<= 	1'b1;
//						if(i == 5'd31)
//							ready <= 1'b0;
					end	//end of  if(sel == 1'b0)
				
				end		// end of if (ready == 1'b1)
			end			// end of if (!reset)
		end				// end of always

assign  			outputVoltage 	= 	outputVoltagTmp;
assign			outputValid		= 	dataValid ; 

endmodule
