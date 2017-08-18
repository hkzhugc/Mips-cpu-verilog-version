`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2017/03/06 16:53:45
// Design Name:
// Module Name: branch_decoder
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


module branch_decoder(
beq, Equal, bne, true, ComBranch,
Branch
    );
    input beq, Equal, bne, true, ComBranch;
    output Branch;
    assign Branch = ((beq & Equal) | (~Equal & bne) | (~Equal & true & ComBranch));
endmodule
