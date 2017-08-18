`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2017/03/05 16:00:18
// Design Name:
// Module Name: control_unit_tb
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

module _regforRegfile (
  clk, ennable, reset, Din,
  dataout
  );
  input clk, ennable, reset;
  input [31:0] Din;
  output [31:0] dataout;
  reg [31:0] data = 0;
  assign dataout = data;
  always @ ( negedge clk ) begin
    if (reset) begin
      data = 0;
    end
    else if (ennable) begin
      data = Din;
    end
  end
endmodule //

module RegFile (
  R1_no, R2_no, RW_no, Din, WE, clk, reset,
  val_s0, val_s3, val_s2, val_ra, R1_val, R2_val
  );
  input [4:0] R1_no;
  input [4:0] R2_no;
  input [4:0] RW_no;
  input [31:0] Din;
  input WE, clk, reset;
  output [31:0] val_s0;
  output [31:0] val_s3;
  output [31:0] val_s2;
  output [31:0] val_ra;
  output [31:0] R1_val;
  output [31:0] R2_val;

  wire [31:0] _reg0, _reg1, _reg2, _reg3, _reg4, _reg5, _reg6, _reg7,
       _reg8, _reg9, _reg10, _reg11, _reg12, _reg13, _reg14, _reg15,
       _reg16, _reg17, _reg18, _reg19, _reg20, _reg21, _reg22, _reg23,
       _reg24, _reg25, _reg26, _reg27, _reg28, _reg29, _reg30, _reg31;

  wire [31:0] we_n;

  assign we_n[0] = 0;
  assign we_n[1] = (RW_no == 1) ? (WE & 1) : 0;
  assign we_n[2] = (RW_no == 2) ? (WE & 1) : 0;
  assign we_n[3] = (RW_no == 3) ? (WE & 1) : 0;
  assign we_n[4] = (RW_no == 4) ? (WE & 1) : 0;
  assign we_n[5] = (RW_no == 5) ? (WE & 1) : 0;
  assign we_n[6] = (RW_no == 6) ? (WE & 1) : 0;
  assign we_n[7] = (RW_no == 7) ? (WE & 1) : 0;
  assign we_n[8] = (RW_no == 8) ? (WE & 1) : 0;
  assign we_n[9] = (RW_no == 9) ? (WE & 1) : 0;
  assign we_n[10] = (RW_no == 10) ? (WE & 1) : 0;
  assign we_n[11] = (RW_no == 11) ? (WE & 1) : 0;
  assign we_n[12] = (RW_no == 12) ? (WE & 1) : 0;
  assign we_n[13] = (RW_no == 13) ? (WE & 1) : 0;
  assign we_n[14] = (RW_no == 14) ? (WE & 1) : 0;
  assign we_n[15] = (RW_no == 15) ? (WE & 1) : 0;
  assign we_n[16] = (RW_no == 16) ? (WE & 1) : 0;
  assign we_n[17] = (RW_no == 17) ? (WE & 1) : 0;
  assign we_n[18] = (RW_no == 18) ? (WE & 1) : 0;
  assign we_n[19] = (RW_no == 19) ? (WE & 1) : 0;
  assign we_n[20] = (RW_no == 20) ? (WE & 1) : 0;
  assign we_n[21] = (RW_no == 21) ? (WE & 1) : 0;
  assign we_n[22] = (RW_no == 22) ? (WE & 1) : 0;
  assign we_n[23] = (RW_no == 23) ? (WE & 1) : 0;
  assign we_n[24] = (RW_no == 24) ? (WE & 1) : 0;
  assign we_n[25] = (RW_no == 25) ? (WE & 1) : 0;
  assign we_n[26] = (RW_no == 26) ? (WE & 1) : 0;
  assign we_n[27] = (RW_no == 27) ? (WE & 1) : 0;
  assign we_n[28] = (RW_no == 28) ? (WE & 1) : 0;
  assign we_n[29] = (RW_no == 29) ? (WE & 1) : 0;
  assign we_n[30] = (RW_no == 30) ? (WE & 1) : 0;
  assign we_n[31] = (RW_no == 31) ? (WE & 1) : 0;

  _regforRegfile r0(clk, we_n[0], reset, 0, _reg0);
  _regforRegfile r1(clk, we_n[1], reset, Din, _reg1);
  _regforRegfile r2(clk, we_n[2], reset, Din, _reg2);
  _regforRegfile r3(clk, we_n[3], reset, Din, _reg3);
  _regforRegfile r4(clk, we_n[4], reset, Din, _reg4);
  _regforRegfile r5(clk, we_n[5], reset, Din, _reg5);
  _regforRegfile r6(clk, we_n[6], reset, Din, _reg6);
  _regforRegfile r7(clk, we_n[7], reset, Din, _reg7);
  _regforRegfile r8(clk, we_n[8], reset, Din, _reg8);
  _regforRegfile r9(clk, we_n[9], reset, Din, _reg9);
  _regforRegfile r10(clk, we_n[10], reset, Din, _reg10);
  _regforRegfile r11(clk, we_n[11], reset, Din, _reg11);
  _regforRegfile r12(clk, we_n[12], reset, Din, _reg12);
  _regforRegfile r13(clk, we_n[13], reset, Din, _reg13);
  _regforRegfile r14(clk, we_n[14], reset, Din, _reg14);
  _regforRegfile r15(clk, we_n[15], reset, Din, _reg15);
  _regforRegfile r16(clk, we_n[16], reset, Din, _reg16);
  _regforRegfile r17(clk, we_n[17], reset, Din, _reg17);
  _regforRegfile r18(clk, we_n[18], reset, Din, _reg18);
  _regforRegfile r19(clk, we_n[19], reset, Din, _reg19);
  _regforRegfile r20(clk, we_n[20], reset, Din, _reg20);
  _regforRegfile r21(clk, we_n[21], reset, Din, _reg21);
  _regforRegfile r22(clk, we_n[22], reset, Din, _reg22);
  _regforRegfile r23(clk, we_n[23], reset, Din, _reg23);
  _regforRegfile r24(clk, we_n[24], reset, Din, _reg24);
  _regforRegfile r25(clk, we_n[25], reset, Din, _reg25);
  _regforRegfile r26(clk, we_n[26], reset, Din, _reg26);
  _regforRegfile r27(clk, we_n[27], reset, Din, _reg27);
  _regforRegfile r28(clk, we_n[28], reset, Din, _reg28);
  _regforRegfile r29(clk, we_n[29], reset, Din, _reg29);
  _regforRegfile r30(clk, we_n[30], reset, Din, _reg30);
  _regforRegfile r31(clk, we_n[31], reset, Din, _reg31);

  assign val_s0 = _reg16;
  assign val_s3 = _reg19;
  assign val_s2 = _reg18;
  assign val_ra = _reg31;

  mutex32_width32 choose_r1(R1_no,
    _reg0, _reg1, _reg2, _reg3, _reg4, _reg5, _reg6, _reg7,
    _reg8, _reg9, _reg10, _reg11, _reg12, _reg13, _reg14, _reg15,
    _reg16, _reg17, _reg18, _reg19, _reg20, _reg21, _reg22, _reg23,
    _reg24, _reg25, _reg26, _reg27, _reg28, _reg29, _reg30, _reg31,
    R1_val);
    mutex32_width32 choose_r2(R2_no,
      _reg0, _reg1, _reg2, _reg3, _reg4, _reg5, _reg6, _reg7,
      _reg8, _reg9, _reg10, _reg11, _reg12, _reg13, _reg14, _reg15,
      _reg16, _reg17, _reg18, _reg19, _reg20, _reg21, _reg22, _reg23,
      _reg24, _reg25, _reg26, _reg27, _reg28, _reg29, _reg30, _reg31,
      R2_val);
endmodule // RegFile
