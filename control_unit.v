`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2017/03/05 12:59:07
// Design Name:
// Module Name: control_unit
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


module control_unit_instruction_spliter(
	instruction,
	op, rs, rt, rd, shamt, func
);
	input [31:0] instruction;
	output [5:0] op;
	output [4:0] rs;
	output [4:0] rt;
	output [4:0] rd;
	output [4:0] shamt;
	output [5:0] func;

	assign op = instruction[31:26];
	assign rs = instruction[25:21];
	assign rt = instruction[20:16];
	assign rd = instruction[15:11];
	assign shamt = instruction[10:6];
	assign func = instruction[5:0];
endmodule

module Itype_decoder(
	op,
	_addi, _addiu, _andi, _ori, _xori, _lui, _lw, _sw, _beq, _bne, _slti, _sltiu
);
	input [5:0] op;
	output _addi, _addiu, _andi, _ori, _xori, _lui, _lw, _sw, _beq, _bne, _slti, _sltiu;

	assign _addi = ~op[5] & ~op[4] & op[3] & ~op[2] & ~op[1] & ~op[0];
	assign _addiu = ~op[5] & ~op[4] & op[3] & ~op[2] & ~op[1] & op[0];
	assign _andi = ~op[5] & ~op[4] & op[3] & op[2] & ~op[1] & ~op[0];
	assign _ori = ~op[5] & ~op[4] & op[3] & op[2] & ~op[1] & op[0];
	assign _xori = ~op[5] & ~op[4] & op[3] & op[2] & op[1] & ~op[0];
	assign _lui = ~op[5] & ~op[4] & op[3] & op[2] & op[1] & op[0];
	assign _lw = op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & op[0];
	assign _sw = op[5] & ~op[4] & op[3] & ~op[2] & op[1] & op[0];
	assign _beq = ~op[5] & ~op[4] & ~op[3] & op[2] & ~op[1] & ~op[0];
	assign _bne = ~op[5] & ~op[4] & ~op[3] & op[2] & ~op[1] & op[0];
	assign _slti = ~op[5] & ~op[4] & op[3] & ~op[2] & op[1] & ~op[0];
	assign _sltiu = ~op[5] & ~op[4] & op[3] & ~op[2] & op[1] & op[0];
endmodule

module Rtype_decoder(
	func, opiszero,
	_add, _addu, _sub, _subu, _and, _or, _xor, _nor, _slt, _sltu,
	_sll, _srl, _sra, _sllv, _srlv, _srav, _jr, _syscall
);
	input [5:0] func;
	input opiszero;

	output _add, _addu, _sub, _subu, _and, _or, _xor, _nor, _slt, _sltu, _sll, _srl;
	output _sra, _sllv, _srlv, _srav, _jr, _syscall;

	assign _add = func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0] & opiszero;
	assign _addu = func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & func[0] & opiszero;
	assign _sub = func[5] & ~func[4] & ~func[3] & ~func[2] & func[1] & ~func[0] & opiszero;
	assign _subu = func[5] & ~func[4] & ~func[3] & ~func[2] & func[1] & func[0] & opiszero;
	assign _and = func[5] & ~func[4] & ~func[3] & func[2] & ~func[1] & ~func[0] & opiszero;
	assign _or = func[5] & ~func[4] & ~func[3] & func[2] & ~func[1] & func[0] & opiszero;
	assign _xor = func[5] & ~func[4] & ~func[3] & func[2] & func[1] & ~func[0] & opiszero;
	assign _nor = func[5] & ~func[4] & ~func[3] & func[2] & func[1] & func[0] & opiszero;
	assign _slt = func[5] & ~func[4] & func[3] & ~func[2] & func[1] & ~func[0] & opiszero;
	assign _sltu = func[5] & ~func[4] & func[3] & ~func[2] & func[1] & func[0] & opiszero;
	assign _sll = ~func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0] & opiszero;
	assign _srl = ~func[5] & ~func[4] & ~func[3] & ~func[2] & func[1] & ~func[0] & opiszero;

	assign _sra = ~func[5] & ~func[4] & ~func[3] & ~func[2] & func[1] & func[0] & opiszero;
	assign _sllv = ~func[5] & ~func[4] & ~func[3] & func[2] & ~func[1] & ~func[0] & opiszero;
	assign _srlv = ~func[5] & ~func[4] & ~func[3] & func[2] & func[1] & ~func[0] & opiszero;
	assign _srav = ~func[5] & ~func[4] & ~func[3] & func[2] & func[1] & func[0] & opiszero;
	assign _jr = ~func[5] & ~func[4] & func[3] & ~func[2] & ~func[1] & ~func[0] & opiszero;
	assign _syscall = ~func[5] & ~func[4] & func[3] & func[2] & ~func[1] & ~func[0] & opiszero;

endmodule


module Jtype_decoder(
	op,
	j, jal
);
	input [5:0] op;
	output j, jal;

	assign j = ~op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & ~op[0];
	assign jal = ~op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & op[0];

endmodule


module control_unit(
	instruction,
	isCop, isCopread, jump, J_type, beq, bne, I_type, AluSrc,  R_type, RegDst,
    MemWrite, MemRead, MemtoReg, RegWrite, shift, syscall, Unsigned, jr, jal,
    isHalf, bltz, AluOp, _or
);
	input [31:0] instruction;

	output isCop, isCopread, jump, J_type, beq, bne, I_type, AluSrc,  R_type, RegDst,
	       MemWrite, MemRead, MemtoReg, RegWrite, shift, syscall, Unsigned, jr, jal,
	       isHalf, bltz, _or;
	output reg [3:0] AluOp = 0;


	wire [5:0] op;
	wire [4:0] rs;
	wire [4:0] rt;
	wire [4:0] rd;
	wire [4:0] shamt;
	wire [5:0] func;

	wire _addi, _addiu, _andi, _ori, _xori, _lui, _lw, _sw, _beq, _bne, _slti, _sltiu;
	wire _j, _jal;
	wire _add, _addu, _sub, _subu, _and, _or, _xor, _nor, _slt, _sltu, _sll, _srl,
		_sra, _sllv, _srlv, _srav, _jr, _syscall;

	control_unit_instruction_spliter split(instruction, op, rs, rt, rd, shamt, func);
	Itype_decoder i_decode(op,
		_addi, _addiu, _andi, _ori, _xori, _lui, _lw, _sw, _beq, _bne, _slti, _sltiu);

	wire opiszero, shamt_is_0;

	assign opiszero = (op == 6'h0) ? 1 : 0;

	Jtype_decoder j_decode(op, _j, _jal);

	Rtype_decoder R_decode(func, opiszero,
		_add, _addu, _sub, _subu, _and, _or, _xor, _nor, _slt, _sltu, _sll, _srl,
		_sra, _sllv, _srlv, _srav, _jr, _syscall);

	assign shamt_is_0 = (shamt == 5'h0) ? 1 : 0;

	wire lh, lw, bltz, rt_is0, com_branch, isLoad;

	assign lh = (op == 6'b100001) ? 1 : 0;
	assign isLoad = _lw | lh;
	assign rs_is0 = (rs == 5'h0) ? 1 : 0;
	assign rt_is0 = (rt == 5'h0) ? 1 : 0;
	assign isCopread = rs_is0;
	assign isCop = (op == 6'b010000) ? 1 : 0;
	assign com_branch = (op == 6'b000001) ? 1 : 0;
	assign bltz = rt_is0 & com_branch;

	assign J_type = _j | _jal;
	assign jump = J_type;
	assign beq = _beq;
	assign bne = _bne;
	assign I_type = (~opiszero & ~_jal & ~_j);
	assign R_type = opiszero;
	assign RegDst = opiszero;
	assign MemWrite = _sw;
	assign MemRead = isLoad;
	assign MemtoReg = isLoad;
	assign AluSrc = (I_type & ~_beq & ~_bne);

	wire isAdd, isAnd, isSub, isOr, isXor, COM;

	assign isAdd = (_lw | _addu | _addiu | _addi | _add | _sw);
	assign isAnd = (_and | _andi);
	assign isSub = (_sub | _subu);
	assign COM = (_slt | bltz | _slti);
	assign isOr = (_ori | _or);
	assign isXor = (_xori | _xori);

	assign RegWrite = (_addi | _jal | _addiu | _andi | _ori | isLoad | _xori | _slti | (isCop & isCopread) | (opiszero & ~_jr & ~_syscall));

	assign shift = (_sll | _srl | _sra);
	assign syscall = _syscall;

	assign Unsigned = (_addiu | _addu | _subu | _sltu);
	assign jr = _jr;
	assign jal = _jal;
	assign isHalf = lh;
	always @ ( instruction or _sra or _srl or isAdd or isSub or isOr or isXor or _nor or COM or _sltu) begin
			if (_sra) begin
				AluOp = 4'h1;
			end
			else if (_srl) begin
				AluOp = 4'h2;
			end
			else if (isAdd) begin
				AluOp = 4'h5;
			end
			else if (isSub) begin
				AluOp = 4'h6;
			end
			else if (isAnd) begin
				AluOp = 4'h7;
			end
			else if (isOr) begin
				AluOp = 4'h8;
			end
			else if (isXor) begin
				AluOp = 4'h9;
			end
			else if (_nor) begin
				AluOp = 4'ha;
			end
			else if (COM) begin
				AluOp = 4'hb;
			end
			else if (_sltu) begin
				AluOp = 4'hc;
			end
			else
			    AluOp = 0;
	end
endmodule
