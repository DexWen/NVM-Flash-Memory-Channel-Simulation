`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:06:12 04/27/2016
// Design Name:   ChannelModel_top
// Module Name:   C:/Users/SUTD/codes/NVMChannelModel/ChannelModel_tb.v
// Project Name:  NVMChannelModel
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ChannelModel_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ChannelModel_tb;

	// Inputs
	reg clk;
	reg reset;
	reg [1:0] levelNum;

	// Outputs
	wire 			[15:0] 		output_v5;
	wire 			[31:0] 		output_v1,output_v3,output_v4;
	reg      	[15:0]		out_temp1,out_temp2,out_temp3,out_temp4,out_temp5;
	
	reg			[19:0]		cnt=18'b0;
	wire							RetetionDone;
	integer						dataFile1,dataFile2,dataFile3,dataFile4,dataFile5;
	
	// Instantiate the Unit Under Test (UUT)
	ChannelModel_top2 model1(
		.clk(clk), 
		.reset(reset), 
		.VoltageLevel(levelNum), 
		.RetentionDoneFlag(RetetionDone),
		.VoltageOutAfterRetention(output_v5),

		//*** inside signal ****
		.IdealProgrammedVoltage(output_v1),
		.VthAfterRTN(output_v3),
		.VoltageInputToRetention(output_v4)
		//**********************
	);		

	// **** for test  ***********
	/*	ChannelModel_top3 model2(
		.clk(clk), 
		.reset(reset), 
		.VoltageLevel(levelNum), 
		.InitialVth(output_v)
	);*/
	

	initial 
	begin
		// Initialize Inputs
		
		dataFile1 = $fopen("ErasedVoltage.txt","w");
		dataFile2 = $fopen("ProgrammedVlotage.txt","w");
		dataFile3 = $fopen("VoltageAfterTRN.txt","w");
		dataFile4 = $fopen("VoltageAfterCCI.txt","w");
		dataFile5 = $fopen("ModelsimDataAfterRetention.txt","w");
		
		clk = 0;
		reset=1'b1;
		levelNum=3'b0;
		// Wait 100 ns for global reset to finish
		#100	reset=1'b0;
        
		// Add stimulus here

	end
	
	always 
	begin
		#50 clk=~clk;
		
	end
	
	
	always @ (posedge clk or negedge reset)
	if (!reset)
	begin 
		cnt <=cnt+ 1;
		 
	end
	
	always @ (negedge clk or negedge reset)
	begin
		
		if (!reset)
		begin 
			levelNum = {$random} %4;
			out_temp1 = output_v1[15:0];
			out_temp2 = output_v1[31:16];
			out_temp3 = output_v3[31:16];
			out_temp4 = output_v4[31:16];
			out_temp5 = output_v5;
			
			if(cnt > 80)
			begin
			$fwrite(dataFile1,"\n %d",$signed(out_temp1));
			$fwrite(dataFile2,"\n %d",out_temp2);
			$fwrite(dataFile3,"\n %d",out_temp3);
			$fwrite(dataFile4,"\n %d",out_temp4);
			$fwrite(dataFile5,"\n %d",out_temp5);
			$display ("%d \n" ,out_temp5);
			end
			
		end
 
		if (cnt>=20'd327679 )		//  max 1048575
		begin
			$fclose (dataFile1);
			$fclose (dataFile2);
			$fclose (dataFile3);
			$fclose (dataFile4);
			$fclose (dataFile5);
			cnt= 20'd0;
			$display ("Finish! \n");
			$finish;
		end  
			
	end
      
endmodule
	
	
	
	
	
	
	
	
	
	
	//************** testbench i.e.1**********//
	// Instantiate the Unit Under Test (UUT)
	/*ChannelModel_top model1(
		.clk(clk), 
		.reset(reset), 
		.addr(addr), 
		.VthAfterRTN(output_v)
	);

	initial 
	begin
		// Initialize Inputs
					dataFile = $fopen("ISimDataAfterRTN.txt","w");
		clk = 0;
		reset=1'b1;
		addr = 12'b0;;

		// Wait 100 ns for global reset to finish
		#100	reset=1'b0;
        
		// Add stimulus here

	end
	
	always 
	#50 clk=~clk;
	
	always @ (posedge clk or negedge reset)
	if (!reset)
	begin 
		cnt <=cnt+ 1;
		if(addr !=14'd16383)
			addr  <= addr + 12'b1;
		else
			addr  <=  12'b0;
	
	end
	
	always @ (negedge clk or negedge reset)
	begin
		
		if (!reset)
		begin 

			out_temp <= output_v;
			$display ("%d \n" ,out_temp);
			$fwrite(dataFile,"\n %d",out_temp);
		 
		end
 
		if (cnt>=16'd16383)
		begin
			$fclose (dataFile);
			cnt<= 13'd0;
			$display ("Finish! \n");
			$finish;
		end
			
		
	end
      
endmodule*/

