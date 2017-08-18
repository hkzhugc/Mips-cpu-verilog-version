`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/02/28 15:22:18
// Design Name: 
// Module Name: shownum
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


module shownum(
			input wire [31:0] N,				//����ʾ���ֵ�8421��
			input wire Clk, 					//ɨ��ʱ��
			output reg [6:0] OUT,			//�������ʾ���
			output reg [7:0] AN,				//�����������ʾ
			output wire DP						//�����С����λ
			);
	reg [2:0] s;		//ɨ�����
	reg [3:0] Number;	//��ǰ��ʾ���ֵ�8421��
	initial begin
	s = 0;		
	Number = 0;
	end
	
	assign DP = 1;//δ�õ�С����λ,����С����λ��Ϊ1
	
	always @(*)
		case(s) //�õ���ǰ��ʾ����
			0:	Number = N[31:28];
			1:  Number =  N[27:24];
			2:	Number = N[23:20] ;
			3:	Number = N[19:16] ;
			4:  Number = N[15:12] ;
			5: Number = N[11:8] ;
			6:  Number = N[7:4] ;
            7: Number = N[3:0] ;
		endcase
	//�߶�������������ǰ��ʾ���ֵ�8421������
	always @(*)
		case(Number)
			0:	OUT = 7'b0000001;
			1:	OUT = 7'b1001111;
			2:	OUT = 7'b0010010;
			3:	OUT = 7'b0000110;
			4:	OUT = 7'b1001100;
			5:	OUT = 7'b0100100;
			6:	OUT = 7'b0100000;
			7:	OUT = 7'b0001111;
			8:	OUT = 7'b0000000;
			9:	OUT = 7'b0000100;
			'hA:	OUT = 7'b0001000;
			'hB:	OUT = 7'b1100000;
			'hC:	OUT = 7'b0110001;
			'hD:	OUT = 7'b1000010;
			'hE:	OUT = 7'b0110000;
			'hF:	OUT = 7'b0111000;
			default: OUT = 7'b0000001;
		endcase
	always @(*)
	begin
		begin
			AN = 8'b11111111;
			AN[s] = 0;		//��������ܵ���ʾ
		end
	end
	always @(posedge Clk)
	begin
		s <= (s==7)?0:s + 1;//ʵ��ɨ��
	end
endmodule
