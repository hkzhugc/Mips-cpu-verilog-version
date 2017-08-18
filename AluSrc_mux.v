`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2017/03/06 16:57:03
// Design Name:
// Module Name: AluSrc_mux
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


module AluSrc_mux(
R2, extend, shift_num,
AluSrc, shift, ComBranch, syscall,
Y
    );
    input [31:0] R2, extend, shift_num;
    input AluSrc, shift, ComBranch, syscall;
    output [31:0] Y;

    wire [31:0] a, b, c;

    assign a = (AluSrc) ? extend : R2;
    assign b = (shift) ? shift_num : a;
    assign c = (ComBranch) ? 0 : b;
    assign Y = (syscall) ? 10 : c;
endmodule
