`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2017/03/05 19:07:01
// Design Name:
// Module Name: mutex2_width32
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


module mutex2_width32(
    sel,
    data0,
    data1,
    dataout
    );
    input sel;
    input [31:0] data0, data1;
    output [31:0] dataout;
    assign dataout = sel ? data1 : data0;
endmodule

module mutex4_width32(
    sel,
    data0, data1,
    data2, data3,
    dataout
    );
    input [1:0] sel;
    input [31:0] data0, data1, data2, data3;
    output [31:0] dataout;
    wire [31:0] dataout0, dataout1;
    mutex2_width32 mux0(sel[0], data0, data1, dataout0);
    mutex2_width32 mux1(sel[0], data2, data3, dataout1);
    assign dataout = sel[1] ? dataout1 : dataout0;
endmodule

module mutex8_width32(
    sel,
    data0, data1, data2, data3,
    data4, data5, data6, data7,
    dataout
    );
    input [2:0] sel;
    input [31:0] data0, data1, data2, data3;
    input [31:0] data4, data5, data6, data7;
    output [31:0] dataout;
    wire [31:0] dataout0, dataout1;
    mutex4_width32 mux0(sel[1:0], data0, data1, data2, data3, dataout0);
    mutex4_width32 mux1(sel[1:0], data4, data5, data6, data7, dataout1);
    assign dataout = sel[2] ? dataout1 : dataout0;
endmodule

module mutex16_width32(
    sel,
    data0, data1, data2, data3, data4, data5, data6, data7,
    data8, data9, data10, data11, data12, data13, data14, data15,
    dataout
    );
    input [3:0] sel;
    input [31:0] data0, data1, data2, data3, data4, data5, data6, data7;
    input [31:0] data8, data9, data10, data11, data12, data13, data14, data15;
    output [31:0] dataout;
    wire [31:0] dataout0, dataout1;
    mutex8_width32 mux0(sel[2:0], data0, data1, data2, data3, data4, data5, data6, data7, dataout0);
    mutex8_width32 mux1(sel[2:0], data8, data9, data10, data11, data12, data13, data14, data15, dataout1);
    assign dataout = sel[3] ? dataout1 : dataout0;
endmodule

module mutex32_width32(
    sel,
    data0, data1, data2, data3, data4, data5, data6, data7, data8, data9, data10, data11, data12, data13, data14, data15,
    data16, data17, data18, data19, data20, data21, data22, data23, data24, data25, data26, data27, data28, data29, data30, data31,
    dataout
    );
    input [4:0] sel;
    input [31:0] data0, data1, data2, data3, data4, data5, data6, data7, data8, data9, data10, data11, data12, data13, data14, data15;
    input [31:0] data16, data17, data18, data19, data20, data21, data22, data23, data24, data25, data26, data27, data28, data29, data30, data31;

    output [31:0] dataout;
    wire [31:0] dataout0, dataout1;
    mutex16_width32 mux0(sel[3:0], data0, data1, data2, data3, data4, data5, data6, data7, data8, data9, data10, data11, data12, data13, data14, data15, dataout0);
    mutex16_width32 mux1(sel[3:0], data16, data17, data18, data19, data20, data21, data22, data23, data24, data25, data26, data27, data28, data29, data30, data31, dataout1);
    assign dataout = sel[4] ? dataout1 : dataout0;
endmodule
