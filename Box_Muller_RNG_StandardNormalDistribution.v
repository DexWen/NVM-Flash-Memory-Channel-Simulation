`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:        
// Engineer: 		 Wen Jiaying  / wenjy0769@sina.com
//                    
// Create Date:    13:37:48 07/11/2016 
// Design Name:    
// Module Name:     
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
module Box_Muller_RNG_StandardNormalDistribution(
		input 				clk,
		input 				reset,
		input 				enable,
		input		[31:0]	rng_32bits,
		
		output  	[15:0]	grv1,		//gaussian random variables
		output  	[15:0]	grv2,
		output 				outputvalid
    );
	 
	 
	reg				[15:0]	sinTransfer_data;
	reg				[15:0]	cosTransfer_data;
	reg							outputvalid_reg;
 	reg							outputvalid_reg1,outputvalid_reg2,outputvalid_reg3,outputvalid_reg4,outputvalid_reg5,outputvalid_reg6,outputvalid_reg7;
	
	wire				[31:0]	grv_data1;
	wire				[31:0]	grv_data2;
	wire				[15:0]	grv1_mean0_std1	;
	wire				[15:0]	grv2_mean0_std1	;
   	
	
	wire				[15:0]	h1_addr_16bits  	;
	wire							h1_doneFlag;
	wire				[15:0]	h1_data;
	wire				[31:0]	h2_addr_32bits 	;
	
	wire				[15:0]	sin_data;
	wire				[15:0]	cos_data;
	wire							readyForMerge;
	
			

	
	 
//********** Random number for logarith & Square Rom **********//
	
//********** RNG for ROM address *********************************//		 // Directly ues input address in order to save sources
/*	
		assign 			   rstTmp 	= ~reset ;
		
		rng 	rngRom1_uut (
					.clk(clk),
					.reset(rstTmp),
					.loadseed_i(load_seed),
					.seed_i(seed_normal_RNG),
					.number_o(rng_32bits)		//32bits
					); */ 
					
					
//*********** h1-> ( (-2)*ln(x) ) ^ (1/2) *******************************************//
   assign h1_addr_16bits = rng_32bits[15:0];
	 
	
	logAndSquareUnit logAndSqure_uut(
						.clk(clk),
						.reset(reset),
						.enable(enable),
						.address(h1_addr_16bits),		//ʹ�ò�ֵ�ķ�����չλ
						.h1_Done(h1_doneFlag),
						.output_h(h1_data)
					 );					
				
//*********** h2-> sin & cos  *******************************************//	
	assign h2_addr_32bits = {{{rng_32bits[24:3],rng_32bits[31:25]},rng_32bits[2:0]}}; 	//

	sinAndCosUnit sinAndCos_uut(
						.clk(clk),
						.reset(reset),
						.enable(enable),
						.address(h2_addr_32bits),		//ʹ�ò�ֵ�ķ�����չλ
						.sinAndCos_Done(h2_doneFlag),
						.output_sin(sin_data),
						.output_cos(cos_data)
					 );		
					 
//************ Box-Muller output *******************************************//
	assign 	readyForMerge = h2_doneFlag && h1_doneFlag;
	
	always @ (posedge clk or negedge reset)
	begin
		if (!reset)
		begin	
			if(readyForMerge)
			begin		
				case({rng_32bits[12],rng_32bits[5]})
				2'd0:
				begin
					sinTransfer_data <=  sin_data;
					cosTransfer_data <=  cos_data;
				end
				2'd1:
				begin
					sinTransfer_data <=  {~sin_data[15:0]+1'b1};
					cosTransfer_data <=  cos_data;
				end
				2'd2:
				begin
					sinTransfer_data <=  sin_data;
					cosTransfer_data <=  {~cos_data[15:0]+1'b1};
				end
				2'd3:
				begin
					sinTransfer_data <=  {~sin_data[15:0]+1'b1};
					cosTransfer_data <=  {~cos_data[15:0]+1'b1};
				end
				default: ;
				endcase	//end case
				outputvalid_reg <= 1'b1;
			end	//end of if(readyForMerge)
		end	//end of if(!reset)
	end	//end always



multiplier16buts multi_uut1( 
					.clk(clk),
					.reset(reset),
					.a_in16bit(h1_data),	//����16λ�з�����
					.b_in16bit(sinTransfer_data),	
					.y_out32bit(grv_data1) 			//���32λ�з�����
								);  
								
multiplier16buts multi_uut2( 
						.clk(clk),
						.reset(reset),
						.a_in16bit(h1_data),	//����16λ�з�����
						.b_in16bit(cosTransfer_data),	
						.y_out32bit(grv_data2) 			//���32λ�з�����
								);  								

assign 	grv1_mean0_std1 = {grv_data1[31], grv_data1[26:12]};
assign 	grv2_mean0_std1 = {grv_data2[31], grv_data2[26:12]};


always @(posedge clk)
begin
	if(!reset)
	begin												// delay don't achieve much
		outputvalid_reg1  <= outputvalid_reg;
		outputvalid_reg2  <= outputvalid_reg1;
		outputvalid_reg3  <= outputvalid_reg2;
		outputvalid_reg4  <= outputvalid_reg3;
		outputvalid_reg5  <= outputvalid_reg4;
		outputvalid_reg6  <= outputvalid_reg5;
		outputvalid_reg7  <= outputvalid_reg6;

	end
end

assign 	grv1=grv1_mean0_std1;
assign 	grv2=grv2_mean0_std1;
assign 	outputvalid=outputvalid_reg7;

endmodule
