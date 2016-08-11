`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:57:10 07/13/2016 
// Design Name: 
// Module Name:    multiplier16bits 
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
module multiplier16buts ( 
					input				clk,
					input				reset,
					input	[15:0]	a_in16bit,	//输入16位有符号数
					input	[15:0]	b_in16bit,	
					output [31:0]	y_out32bit	//输出32位有符号数
								);           		//16位有符号数乘法器，输出32位有符号数


	
  reg	[31:0]	y_out32bit_reg;         		//输出结果，负数则以补码形式保存
  reg	[15:0]   x1,x2,x3,x4;   			//x1,x2用来存放输入变量;x3,x4用来存放输入变量的原码
  reg         	x5;            			//用来存放输出数的符号位
  reg	[29:0]   x6;            			//30位寄存器，存放15位有效数位相乘结果
  reg	[31:0]   x7;            			//用来存放输出数据的原码
 
 always@ (posedge clk )
	 begin
		if( reset )              //复位使能，寄存器清零
			begin
			x1<=16'b0;
			x2<=16'b0;
			x3<=16'b0;
			x4<=16'b0;
			x5<=1'b0;
			x6<=30'b0;
			x7<=32'b0;
			y_out32bit_reg<=32'b0;
			end
		else
			 begin
			 x1<=a_in16bit;             //输入寄存器赋值
			 x2<=b_in16bit;
			 x3<=(x1[15]==0)?x1:{x1[15],~x1[14:0]+1'b1};     //判断最高位是否为1，即判断输入是否负数，如果是负数则取反加1，如果是正数则不变，目的是求输入的原码。
			 x4<=(x2[15]==0)?x2:{x2[15],~x2[14:0]+1'b1};     //同上
			 x5<=x3[15]^x4[15];                              //输入两数符号位相异或，得到输出数的符号位
			 x6<=x3[14:0]*x4[14:0];                          //输入15位有效数据相乘
			 x7<={x5,x6,1'b0};                               //得到输出数的原码，由1位符号位，30位有效数据位和1位无关位0组成，构成32位输出
			 y_out32bit_reg<=(x7[31]==0)?x7:{x7[31],~x7[30:0]+1'b1};  //判断输出数据是否负数，把相乘结果变成补码形式输出
			 end
	 end
	 assign y_out32bit=y_out32bit_reg;
endmodule
