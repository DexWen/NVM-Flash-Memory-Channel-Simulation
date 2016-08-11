`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:40:56 07/12/2016 
// Design Name: 
// Module Name:    sinAndCosUnit 
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
module sinAndCosUnit(	
				input 				clk,
				input					reset,
				input					enable,
				input		[31:0] 	address,		//使用插值的方法扩展位
				output				sinAndCos_Done,
				output	[15:0]	output_sin,
				output	[15:0]	output_cos	
				);
				
reg	[2:0]			state1;
reg	[15:0]		delta1 ;
reg					doneFlag1;
reg	[15:0]		sinDataTmp;

reg	[2:0]			state2;
reg	[15:0]		delta2 ;
reg					doneFlag2;
reg	[15:0]		cosDataTmp;
				
wire	[15:0]		sinData,sinDataNext,cosData,cosDataNext;
wire	[9:0]			Addr_10bits_sin;
wire	[9:0]			AddrN_10bits_sin;		
wire	[5:0]			insertAddrSin;

wire	[9:0]			Addr_10bits_cos;
wire	[9:0]			AddrN_10bits_cos;
wire	[5:0]			insertAddrCos;
				
//*********** 对ROM1 进行取值 ***************************************//
assign  	Addr_10bits_sin  = address [15:6];
assign  	AddrN_10bits_sin = address [15:6] + 10'b1;

		
	g0sin_BoxMuller_rom sin_uut(					//
					  .clka(clk),
					  .addra(Addr_10bits_sin),
					  .douta(sinData),
					  .clkb(clk),
					  .addrb(AddrN_10bits_sin),
					  .doutb(sinDataNext)
					);
					
//*********** sin 插值取地址 ********************************************//
assign insertAddrSin  = address[5:0];

	always@ (posedge clk or posedge reset)
	begin
		if(reset)
		begin
			state1 <= 3'b0;
			delta1 <= 0;
			doneFlag1 <= 1'b0;
		end		//end if (reset)
		else 
		begin
			case(state1)
			3'd0:
				begin
					if(sinData > sinDataNext)
						delta1 <= sinData - sinDataNext;
					else 
						delta1 <= sinDataNext - sinData;
					state1 <= 3'd1;
				end			// end case 0
			3'd1:
				begin
					delta1 <= delta1 << 6;
					state1 <= 3'd2;
				end			// end case 1
			3'd2:
				begin
					delta1 <= delta1*insertAddrSin;
					state1 <= 3'd3;
				end			// end case 2
			3'd3:
				begin
					sinDataTmp <= delta1 + sinData;
					doneFlag1 <= 1'b1;
				end			// end case 3
			default:
				begin
					doneFlag1 <= 1'b0;
				end			// end default
			endcase		//end case	
		end		//end if (!reset)
	end		//end always
//***********************************************					
					
					
					
//*********** 对ROM2 进行取值 ***************************************//
assign  	Addr_10bits_cos  = address [31:22];
assign  	AddrN_10bits_cos = address [31:22] + 10'b1;


		
	g1cos_BoxMuller_rom cos_uut(					//
					  .clka(clk),
					  .addra(Addr_10bits_cos),
					  .douta(cosData),
					  .clkb(clk),
					  .addrb(AddrN_10bits_cos),
					  .doutb(cosDataNext)
					);
					
//*********** Cos 插值取地址 ********************************************//
assign insertAddrCos  = address[5:0];

	always@ (posedge clk or posedge reset)
	begin
		if(reset)
		begin
			state2 <= 3'b0;
			delta2 <= 0;
			doneFlag2 <= 1'b0;
		end		//end if (reset)
		
		else 
		begin
			case(state2)
			3'd0:
				begin
					if(cosData > cosDataNext)
						delta2 <= cosData - cosDataNext;
					else 
						delta2 <= cosDataNext - cosData;
					state2 <= 3'd1;
				end			// end case 0
			3'd1:
				begin
					delta2 <= delta2 << 6;
					state2 <= 3'd2;
				end			// end case 1
			3'd2:
				begin
					delta2 <= delta2*insertAddrCos;
					state2 <= 3'd3;
				end			// end case 2
			3'd3:
				begin
					cosDataTmp <= delta2 + cosData;
					doneFlag2 <= 1'b1;
				end			// end case 3
			default:
				begin
					doneFlag2 <= 1'b0;
				end			// end default
			endcase		//end case	
		end		//end if (!reset)
	end		//end always
//***********************************************				


assign sinAndCos_Done = doneFlag1 && doneFlag2;
assign output_sin     = sinDataTmp;
assign output_cos     = cosDataTmp;


endmodule
