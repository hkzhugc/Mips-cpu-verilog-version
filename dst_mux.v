`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2017/03/06 16:49:56
// Design Name:
// Module Name: dst_mux
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


module dst_mux(
  seq_dst, branch_dst, jump_dst, jr_dst,
  branch, jump, jr,
  PC_dst
    );

    input [31:0] seq_dst, branch_dst, jump_dst, jr_dst;
    input branch, jump, jr;
    output [31:0] PC_dst;

    wire [31:0] a, b;
    assign a = (branch) ? branch_dst : seq_dst;
    assign b = (jump) ? jump_dst : a;
    assign PC_dst = (jr) ? jr_dst : b;
endmodule
