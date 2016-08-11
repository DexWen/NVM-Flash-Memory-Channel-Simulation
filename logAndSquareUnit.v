`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:45:10 07/11/2016 
// Design Name: 
// Module Name:    logAndSquareUnit 
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
module logAndSquareUnit(
					 input 					clk,
					 input 					reset,
					 input 					enable,
					 input	[15:0]		address,
					 output 	[15:0]		output_h,
				    output					h1_Done
					 );
					 

	reg 		[3:0] 	state   		=3'b0;
	reg		[15:0]	delta;
	reg		[15:0]	h1_tmp;
	reg					h1_Done_reg;
	
	wire					seed_LogAndSquare = 32'h1234_4567;
	wire 					rstTmp;
	wire 		[31:0]	rng_32bits;
	wire		[10:0]	Addr_11bits;
	wire		[10:0]	AddrN_11bits;
	wire		[15:0]	hData;
	wire		[15:0]	hDataNext;				 
	wire		[4:0] 	insertAddr;			 


					
					
//*********** 对ROM 进行取值 ***************************************//
assign  	Addr_11bits  = address [15:5];
assign  	AddrN_11bits = address [15:5] + 11'b1;

		
		h1_rom h1_rom_uut(					//h1:  ( (-2)*ln(x) ) ^ (1/2) * 2^11
					  .clka(clk),
					  .addra(Addr_11bits),
					  .douta(hData),
					  .clkb(clk),
					  .addrb(AddrN_11bits),
					  .doutb(hDataNext)
					);
					
	
//*********** 插值取地址 ********************************************//
assign insertAddr  = address[4:0];

	always@ (posedge clk or posedge reset)
	begin
		if(reset)
		begin
			state <= 3'b0;
			delta <= 0;
			h1_Done_reg <= 1'b0;
		end		//end if (reset)
		else 
		begin
			case(state)
			3'd0:
				begin
					if(hData > hDataNext)
						delta <= hData - hDataNext;
					else 
						delta <= hDataNext - hData;
					state <= 3'd1;
				end			// end case 0
			3'd1:
				begin
					delta <= (delta >> 5);
					state <= 3'd2;
				end			// end case 1
			3'd2:
				begin
					delta <= delta*insertAddr;
					state <= 3'd3;
				end			// end case 2
			3'd3:
				begin
					h1_tmp <= delta + hData;
					h1_Done_reg <= 1'b1;
				end			// end case 3
			default:
				begin
					h1_Done_reg <= 1'b0;
				end			// end default
			endcase		//end case	
		end		//end if (!reset)
	end		//end always

assign output_h = h1_tmp;
assign h1_Done=h1_Done_reg;

endmodule
