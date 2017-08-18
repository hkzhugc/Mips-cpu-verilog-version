`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2017/03/06 14:30:13
// Design Name:
// Module Name: ID_EX
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


module ID_EX(
reset, clk, isNop, PC_dst, load_use, halt,
sig_in, PC_jmp_in, PC_add_4_in, R1_in, R2_in, shift_num_in, extend_in, IR_in, PC_in,
RD_in, src_reg_num_in,
sig_out, PC_jmp_out, PC_add_4_out, R1_out, R2_out, shift_num_out, extend_out, IR_out, PC_out,
RD_out, src_reg_num_out
    );
    input reset;
    input clk, isNop, PC_dst, load_use, halt;
    input [31:0] sig_in, PC_jmp_in, PC_add_4_in, R1_in, R2_in, shift_num_in, extend_in, IR_in, PC_in;
    input [4:0] RD_in;
    input [9:0] src_reg_num_in;

    output [31:0] sig_out, PC_jmp_out, PC_add_4_out, R1_out, R2_out, shift_num_out, extend_out, IR_out, PC_out;
    output [4:0] RD_out;
    output [9:0] src_reg_num_out;

    reg [4:0] RD = 0;
    reg [9:0] src_reg_num = 0;

    wire insert_nop;

    assign insert_nop = (PC_dst | load_use | halt);

    wire [31:0] D_sig, D_PC_jmp, D_PC_add_4, D_R1, D_R2, D_shift_num, D_extend, D_IR, D_PC, D_sig2;

    assign D_sig = (insert_nop) ? 0 : sig_in;
    assign D_PC_jmp = (insert_nop) ? 0 : PC_jmp_in;
    assign D_PC_add_4 = (insert_nop) ? 0 : PC_add_4_in;
    assign D_R1 = (insert_nop) ? 0 : R1_in;
    assign D_R2 = (insert_nop) ? 0 : R2_in;
    assign D_shift_num = (insert_nop) ? 0 : shift_num_in;
    assign D_extend = (insert_nop) ? 0 : extend_in;
    assign D_IR = (insert_nop) ? 0 : IR_in;
    assign D_PC = (insert_nop) ? 0 : PC_in;

    assign D_sig2 = (isNop) ? 0 : D_sig;

    _regforMain sig(clk, 1, reset, D_sig, sig_out);
    _regforMain PC_jmp(clk, 1, reset, D_PC_jmp, PC_jmp_out);
    _regforMain PC_add_4(clk, 1, reset, D_PC_add_4, PC_add_4_out);
    _regforMain R1(clk, 1, reset, D_R1, R1_out);
    _regforMain R2(clk, 1, reset, D_R2, R2_out);
    _regforMain shift_num(clk, 1, reset, D_shift_num, shift_num_out);
    _regforMain extend(clk, 1, reset, D_extend, extend_out);
    _regforMain IR(clk, 1, reset, D_IR, IR_out);
    _regforMain PC(clk, 1, reset, D_PC, PC_out);

    always @ ( posedge clk ) begin
      if(insert_nop | reset) begin
        RD <= 0;
        src_reg_num <= 0;
      end
      else begin
        RD <= RD_in;
        src_reg_num <= src_reg_num_in;
      end
    end

    assign src_reg_num_out = src_reg_num;
    assign RD_out = RD;
endmodule
