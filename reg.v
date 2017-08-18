module _regforMain (
  clk, ennable, reset, Din,
  dataout
  );
  input clk, ennable, reset;
  input [31:0] Din;
  output [31:0] dataout;
  reg [31:0] data = 0;
  assign dataout = data;
  always @ ( posedge clk ) begin
    if (reset) begin
      data = 0;
    end
    else if (ennable) begin
      data = Din;
    end
  end
endmodule //
