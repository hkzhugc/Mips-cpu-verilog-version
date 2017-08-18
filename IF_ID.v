`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2017/03/06 14:21:50
// Design Name:
// Module Name: IF_ID
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module IF_ID(
  reset, clk, PCdst, insert_nop,
  IRin, PC_add_4in, PCin,
  IRout, PC_add_4out, PCout
    );
    input reset;
    input clk, PCdst, insert_nop;
    input [31:0] IRin, PC_add_4in, PCin;

    wire [31:0] D_IR, D_PC_add_4, D_PC;

    output [31:0] IRout, PC_add_4out, PCout;
    assign D_IR = (PCdst) ? 0 : IRin;
    assign D_PC_add_4 = (PCdst) ? 0 : PC_add_4in;
    assign D_PC = (PCdst) ? 0 : PCin;

    _regforMain IR(clk, ~insert_nop, reset, D_IR, IRout);
    _regforMain PC_add_4(clk, ~insert_nop, reset, D_PC_add_4, PC_add_4out);
    _regforMain PC(clk, ~insert_nop, reset, D_PC, PCout);
endmodule
