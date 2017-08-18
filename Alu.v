`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/06 08:35:41
// Design Name: 
// Module Name: Alu
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


module Alu(
  X, Y, S,
  Equal, Result
  );
  input [31:0] X, Y;
  input [3:0] S;

  output Equal;
  output reg [31:0] Result;
  assign  Equal = (X == Y) ? 1 : 0;
  always @ ( X or Y or S ) begin
    
    case (S)
    0 : Result = X << Y[4:0];
    1 : Result = $signed(X) >>> Y[4:0];
    2 : Result = X >> Y[4:0];
    3 : Result = 0;//no ins
    4 : Result = 0;//no ins
    5 : Result = X + Y;
    6 : Result = X - Y;
    7 : Result = X & Y;
    8 : Result = X | Y;
    9 : Result = X ^ Y;
    10 : Result = ~(X | Y);
    11 : Result = (($signed(X) < $signed(Y)) ? 1 : 0);
    12 : Result = (($unsigned(X) < $unsigned(Y)) ? 1 : 0);
    default : Result = 0;
    endcase
  end
endmodule

