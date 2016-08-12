`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:49:42 05/13/2016 
// Design Name: 
// Module Name:    CCI_distortion 
// Project Name:   NVMChannelModel
// Target Devices: 
// Tool versions: 
// Description:   ** input **
//						1. 32bits target cell voltage
//                2. All bit line structure, every cell affected by 3 direction interference mainly( vertical x1 and diagonal x2 )
//						3. The XY_CCI_left, XY_CCI_right, Y_CCI are the delta voltage from diagonal and vertical direction of the interfering cell
//                ** output **
//                1. Vlotage after cell-to-cell interference 
//						2. 32bits Output includes 16bits voltage and 16bits origin voltage before cci.
//						3. cciDone is a flag message.  
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module CCI_distortionUnit(
    input 				clk,
    input 				en,
    input 	[31:0]	affectedCellVoltage,
	 
    input 	[15:0]	XY_CCI_left,
    input 	[15:0]	Y_CCI,
    input 	[15:0]	XY_CCI_right,
	 
    output 	[31:0]	VlotageAferCCI,
	 output  			cciDone
    );
	 
	 
	 parameter sigmaY = 15'd131	;			// 0.064  * (2^11) = 131.072
	 parameter sigmaXY = 15'd10	;			//	0.0048 * (2^11) = 9.8304
	 
	 reg									startCCI=0;
	 reg		signed		[15:0]	absDeltaValueXY1,absDeltaValueXY1_tmp;
	 reg		signed		[15:0]	absDeltaValueY,absDeltaValueY_tmp;
	 reg		signed		[15:0]	absDeltaValueXY2,absDeltaValueXY2_tmp;
	 reg						[31:0]	V_tmp1,V_tmp2,V_tmp3;

	 reg						[31:0]	CellVoltageD1,CellVoltageD2,CellVoltageD3;
	 
	 reg						[15:0]   VlotageAferCCI_tmp,initVoltage_tmp;	
	 reg									cciDoneFlag;
		
	
	always @( posedge clk )
	begin
		if(en)
		begin
			startCCI 			<= 1'b1;
			absDeltaValueXY1 	<= XY_CCI_left;
			absDeltaValueY 	<= Y_CCI;
			absDeltaValueXY2	<=	XY_CCI_right;
		end

		if(startCCI==1'b1)
		begin
		//*********** delay 1****************//
			if( absDeltaValueXY1 < 0	)                       	//deal with negative DeltaValueXY1
				absDeltaValueXY1_tmp <= ~(absDeltaValueXY1 - 16'd1);   //complement transform
			else
				absDeltaValueXY1_tmp <= absDeltaValueXY1;
				
			if( absDeltaValueY <  0	)
				absDeltaValueY_tmp <= ~(absDeltaValueY - 16'd1);
			else
				absDeltaValueY_tmp <= absDeltaValueY;	
				
			if( absDeltaValueXY2 <  0	)
				absDeltaValueXY2_tmp <= ~(absDeltaValueXY2 - 16'd1)	;
			else
				absDeltaValueXY2_tmp <= absDeltaValueXY2;
				
			CellVoltageD1 <= affectedCellVoltage;
			
		//*********** delay 2****************//	
			V_tmp1 <= absDeltaValueXY1_tmp * sigmaXY;
			V_tmp2 <= absDeltaValueY_tmp   * sigmaY;
			V_tmp3 <= absDeltaValueXY2_tmp * sigmaXY;
			CellVoltageD2 <= CellVoltageD1;
			
		//*********** delay 3****************//	
			VlotageAferCCI_tmp <= CellVoltageD2[31:16] + V_tmp1[26:11] +V_tmp2[26:11] + V_tmp3[26:11];
			initVoltage_tmp <= CellVoltageD2[15:0];
			cciDoneFlag <= 1'b1;	//useless
		end			// end of if(startCCI==1'b1)
	end			// end always
	
	
	assign VlotageAferCCI = { {VlotageAferCCI_tmp},initVoltage_tmp};
	assign cciDone  		 =	cciDoneFlag;

endmodule
