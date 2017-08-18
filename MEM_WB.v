`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2017/03/06 15:09:32
// Design Name:
// Module Name: MEM_WB
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


module MEM_WB(
reset, clk,
read_data_in, sig_in, AluOut_in, IR_in, PC_in,
RDdst_in, halt_in,
read_data_out, sig_out, AluOut_out, IR_out, PC_out,
RDdst_out, halt_out
    );
    input reset;
    input clk, halt_in;
    input [31:0] read_data_in, sig_in, AluOut_in, IR_in, PC_in;
    input [4:0] RDdst_in;

    output halt_out;
    output [31:0] read_data_out, sig_out, AluOut_out, IR_out, PC_out;
    output [4:0] RDdst_out;

    reg [4:0] RDdst = 0;
    reg halt = 0;

    _regforMain read_data(clk, 1, reset, read_data_in, read_data_out);
    _regforMain sig(clk, 1, reset, sig_in, sig_out);
    _regforMain AluOut(clk, 1, reset, AluOut_in, AluOut_out);
    _regforMain IR(clk, 1, reset, IR_in, IR_out);
    _regforMain PC(clk, 1, reset, PC_in, PC_out);


    always @ ( posedge clk ) begin
      if(reset) begin
      RDdst = 0;
      halt = 0;
      end
      else begin
      RDdst = RDdst_in;
      halt = halt_in;
      end
    end

    assign RDdst_out = RDdst;
    assign halt_out = halt;

endmodule
