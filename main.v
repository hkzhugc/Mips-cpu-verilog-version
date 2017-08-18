`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2017/03/06 14:19:12
// Design Name:
// Module Name: main
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


module main(
  change_seg_shown, fast_clk, reset,
  seg_out, seg_an, dp, PC_enable
    );
    input [1:0] change_seg_shown;
    input reset;
    input fast_clk;
    output [6:0] seg_out;
    output [7:0] seg_an;
    output dp;
    reg ms = 0;
    reg ms_1000_fast = 0;
    wire clk;
    assign clk = ms;
    assign clk_1000_ms = ms_1000_fast;
    reg [25:0] div1000hz_temp = 0;
    reg [25:0] div1whz_temp = 0;
    always @ (posedge fast_clk) begin
            div1000hz_temp <= div1000hz_temp + 1;
            div1whz_temp <= div1whz_temp + 1;
            if(div1000hz_temp == 500000)
            begin
                div1000hz_temp <= 0;
                ms <= ~ms;
            end
            if(div1whz_temp == 50000)
            begin
                div1whz_temp <= 0;
                ms_1000_fast <= ~ms_1000_fast;
            end
        end
    output PC_enable;
    wire PC_enable, load_use;
    wire _or;
    reg halt_end = 0;
    wire Branch;
    wire [31:0] instruction, IRout_if_id, IR_out_id_ex, IR_out_ex_mem, IR_out_mem_wb, Branch_dst, PC_in, PC_out;

    reg [31:0] cnt = 0;
    reg [31:0] load_use_cnt = 0;
    reg [31:0] Branch_cnt = 0;
    always @ (posedge clk) begin
        if(reset) begin
            cnt = 0;
            load_use_cnt = 0;
            Branch_cnt = 0;
        end
        else begin
            if (~halt_end)
            cnt = cnt + 1;
            if(load_use & ~halt_end)
            load_use_cnt = load_use_cnt + 1;
            if(PCdst & ~halt_end)
            Branch_cnt = Branch_cnt + 1;
        end
    end

    assign PC_enable = ~(halt_end | load_use);
    wire PCdst;
    assign PC_in = (PCdst) ? Branch_dst : (PC_out + 4);
    _regforMain PC(clk, PC_enable, reset, PC_in, PC_out);

    dist_mem_gen_0 instruction_ROM(
      .a(PC_out[11:2]),      // input wire [9 : 0] a
      .spo(instruction)  // output wire [31 : 0] spo
    );

    wire [31:0] PC_add_4out_if_id, PC_out_if_id;

    IF_ID if_id(
      reset, clk, PCdst, load_use,
      instruction, PC_out + 4, PC_out,
      IRout_if_id, PC_add_4out_if_id, PC_out_if_id
      );

    wire [31:0] PC_jmp_id, PC_add_4out_id;

    assign PC_jmp_id = {PC_add_4out_if_id[31:28], IRout_if_id[25:0], 2'h0};
    assign PC_add_4out_id = PC_add_4out_if_id;

    wire isCop, rs_is_zero, Jump, J, beq, bne, I, ALUSrc,  R, RegDst,
      MemWrite, MemRead, MemtoReg, RegWrite, Shift, syscall, Unsigned, Jr, Jal,
      HalfWord, ComBranch;
    wire [3:0] ALUOp;

    control_unit c_u(
      IRout_if_id,
    	isCop, rs_is_zero, Jump, J, beq, bne, I, ALUSrc,  R, RegDst,
        MemWrite, MemRead, MemtoReg, RegWrite, Shift, syscall, Unsigned, Jr, Jal,
        HalfWord, ComBranch, ALUOp, _or
      );

    wire [4:0] rs_temp_id, rs;
    assign rs_temp_id = (syscall) ? 2 : IRout_if_id[25:21];
    assign rs = (Jr) ? 5'h1f : rs_temp_id;

    wire [4:0] rt;
    assign rt = (syscall) ? 4 : IRout_if_id[20:16];

    wire [4:0] rw_temp_id, Write_num;
    assign rw_temp_id = (RegDst) ? IRout_if_id[15:11] : IRout_if_id[20:16];
    assign Write_num = (Jal) ? 5'h1f : rw_temp_id;

    wire [1:0] selno;
    assign selno = IRout_if_id[12:11];

    wire [31:0] shift_num_id, unsigned_extend_id, signed_extend_id, extend_id;

    assign shift_num_id = {{27{1'b0}}, IRout_if_id[10:6]};
    assign unsigned_extend_id = {{16{1'b0}}, IRout_if_id[15:0]};
    assign signed_extend_id = {{16{IRout_if_id[15]}}, IRout_if_id[15:0]};

    assign extend_id = (Unsigned) ? unsigned_extend_id : signed_extend_id;

    wire [31:0] val_s0, val_s3, val_s2, val_ra, R1_val, R2_val;
    wire [31:0] DataToReg;
    wire [4:0] WB_RegWrite_num;
    wire WB_RegWrite;

    RegFile reg_file(
      rs, rt, WB_RegWrite_num, DataToReg, WB_RegWrite, clk, reset,
      val_s0, val_s3, val_s2, val_ra, R1_val, R2_val
      );
    wire if_id_isNop;
    assign if_id_isNop = (IRout_if_id == 0) ? 1 : 0;

    wire [31:0] id_sig;

    assign id_sig[31:30] = 0;
    assign id_sig[29] = RegWrite;
    assign id_sig[28] = Jal;
    assign id_sig[27:23] = rs;
    assign id_sig[22:21] = selno;
    assign id_sig[20] = R;
    assign id_sig[19] = I;
    assign id_sig[18] = J;
    assign id_sig[17] = rs_is_zero;
    assign id_sig[16] = HalfWord;
    assign id_sig[15] = isCop;
    assign id_sig[14] = MemRead;
    assign id_sig[13] = MemWrite;
    assign id_sig[12] = MemtoReg;
    assign id_sig[11] = syscall;
    assign id_sig[10:7] = ALUOp;
    assign id_sig[6] = ALUSrc;
    assign id_sig[5] = Shift;
    assign id_sig[4] = Jr;
    assign id_sig[3] = Jump;
    assign id_sig[2] = ComBranch;
    assign id_sig[1] = bne;
    assign id_sig[0] = beq;

    wire [31:0] sig_out_id_ex, PC_jmp_out_id_ex, PC_add_4_out_id_ex, R1_out_id_ex;
    wire [31:0] R2_out_id_ex, shift_num_out_id_ex, extend_out_id_ex, PC_out_id_ex;
    wire [4:0] RD_out_id_ex;
    wire [9:0] src_reg_num_out_id_ex;

    ID_EX id_ex(
      reset, clk, if_id_isNop, PCdst, load_use, halt_end,
      id_sig, PC_jmp_id, PC_add_4out_id, R1_val, R2_val, shift_num_id, extend_id, IRout_if_id, PC_out_if_id,
      Write_num, {rt, rs},
      sig_out_id_ex, PC_jmp_out_id_ex, PC_add_4_out_id_ex, R1_out_id_ex, R2_out_id_ex, shift_num_out_id_ex, extend_out_id_ex, IR_out_id_ex, PC_out_id_ex,
      RD_out_id_ex, src_reg_num_out_id_ex
      );

    wire [31:0] EX_rs_val, EX_rt_val;
    assign EX_rs_val = R1_out_id_ex;
    assign EX_rt_val = R2_out_id_ex;

    wire EX_beq, EX_bne, EX_ComBranch, EX_Jump, EX_Jr, EX_Shift, EX_ALUSrc, EX_syscall,
      EX_MemWrite, EX_MemRead, EX_isCop, EX_rs_iszero, EX_J, EX_I, EX_R, EX_RegWrite;

    wire [1:0] EX_selno;
    wire [3:0] EX_ALUOp;
    wire [4:0] EX_rs, EX_rt;

    assign EX_rs = src_reg_num_out_id_ex[4:0];
    assign EX_rt = src_reg_num_out_id_ex[9:5];

    assign EX_selno = sig_out_id_ex[22:21];
    assign EX_ALUOp = sig_out_id_ex[10:7];

    assign EX_beq = sig_out_id_ex[0];
    assign EX_bne = sig_out_id_ex[1];
    assign EX_ComBranch = sig_out_id_ex[2];
    assign EX_Jump = sig_out_id_ex[3];
    assign EX_Jr = sig_out_id_ex[4];
    assign EX_Shift = sig_out_id_ex[5];
    assign EX_ALUSrc = sig_out_id_ex[6];
    assign EX_syscall = sig_out_id_ex[11];
    assign EX_MemWrite = sig_out_id_ex[13];
    assign EX_MemRead = sig_out_id_ex[14];
    assign EX_isCop = sig_out_id_ex[15];
    assign EX_rs_iszero = sig_out_id_ex[17];
    assign EX_J = sig_out_id_ex[18];
    assign EX_I = sig_out_id_ex[19];
    assign EX_R = sig_out_id_ex[20];
    assign EX_RegWrite = sig_out_id_ex[29];

    wire [31:0] branch_dst;

    assign branch_dst = (extend_out_id_ex << 2) + PC_add_4_out_id_ex;

    wire [31:0] data2rs, data2rt;
    dst_mux d_m(
      PC_add_4_out_id_ex, branch_dst, PC_jmp_out_id_ex, data2rs,
      Branch, EX_Jump, EX_Jr,
      Branch_dst
      );
    wire [31:0] _Y, _X;
    assign _X = (EX_Shift) ? data2rt : data2rs;
    AluSrc_mux a_m(
      data2rt, extend_out_id_ex, shift_num_out_id_ex,
      EX_ALUSrc, EX_Shift, EX_ComBranch, EX_syscall,
      _Y
      );
    wire Equal, true;
    wire [31:0] EX_alures;
    assign true = EX_alures[0];
    Alu _alu(
        _X, _Y, EX_ALUOp,
        Equal, EX_alures
      );

    branch_decoder b_dec(
        EX_beq, Equal, EX_bne, true, EX_ComBranch,
        Branch
      );

    reg EX_halt = 0;
    always @ ( negedge clk) begin
        if(reset) begin
        EX_halt = 0;
        end
        else begin
          if(Equal & EX_syscall)
          EX_halt = 1;
          else
          EX_halt = 0;
        end
    end

    wire [31:0] sig_out_ex_mem, AluOut_out_ex_mem, R2_out_out_ex_mem, PC_out_ex_mem;
    wire [4:0] RDdst_out_ex_mem;
    wire halt_out_ex_mem;

    EX_MEM ex_mem(
      reset, clk,
      sig_out_id_ex, EX_alures, data2rt, IR_out_id_ex, PC_out_id_ex,
      RD_out_id_ex, EX_halt,
      sig_out_ex_mem, AluOut_out_ex_mem, R2_out_out_ex_mem, IR_out_ex_mem, PC_out_ex_mem,
      RDdst_out_ex_mem, halt_out_ex_mem
      );

    wire MEM_MemWrite, MEM_MemRead, MEM_RegWrite;
    assign MEM_MemWrite = sig_out_ex_mem[13];
    assign MEM_MemRead = sig_out_ex_mem[14];
    assign MEM_RegWrite = sig_out_ex_mem[29];

    wire [31:0] data_from_ram;
    RAM my_ram (
      .a(AluOut_out_ex_mem[11:2]),      // input wire [9 : 0] a
      .d(R2_out_out_ex_mem),      // input wire [31 : 0] d
      .clk(clk),  // input wire clk
      .we(MEM_MemWrite),    // input wire we
      .spo(data_from_ram)  // output wire [31 : 0] spo
      );

    wire [31:0] read_data_out_mem_wb, sig_out_mem_wb, AluOut_out_mem_wb, PC_out_mem_wb;
    wire [4:0] RDdst_out_mem_wb;
    wire halt_out_mem_wb;

    MEM_WB mem_wb(
      reset, clk,
      data_from_ram, sig_out_ex_mem, AluOut_out_ex_mem, IR_out_ex_mem, PC_out_ex_mem,
      RDdst_out_ex_mem, halt_out_ex_mem,
      read_data_out_mem_wb, sig_out_mem_wb, AluOut_out_mem_wb, IR_out_mem_wb, PC_out_mem_wb,
      RDdst_out_mem_wb, halt_out_mem_wb
      );
    assign WB_RegWrite_num = RDdst_out_mem_wb;

    wire WB_Jal, WB_HalfWord, WB_MemtoReg;

    assign WB_RegWrite = sig_out_mem_wb[29];
    assign WB_Jal = sig_out_mem_wb[28];
    assign WB_HalfWord = sig_out_mem_wb[16];
    assign WB_MemtoReg = sig_out_mem_wb[12];

    wire [31:0] WB_data_from_Ram, WB_data_from_Ram_half;
    assign WB_data_from_Ram_half = {{16{read_data_out_mem_wb[15]}}, read_data_out_mem_wb[15:0]};

    assign WB_data_from_Ram = (WB_HalfWord) ?  WB_data_from_Ram_half : read_data_out_mem_wb;

    wire [31:0] WB_val_MemtoReg;
    assign WB_val_MemtoReg = (WB_MemtoReg) ? WB_data_from_Ram : AluOut_out_mem_wb;

    assign DataToReg = (WB_Jal) ? (PC_out_mem_wb + 4) : WB_val_MemtoReg;

    reg Stop = 0;

    always @ ( posedge halt_out_mem_wb or posedge reset) begin
    if(reset)
      Stop = 0;
    else
      Stop = 1;
    end

    always @ ( posedge clk) begin
    if(reset)
      halt_end = 0;
    else
      halt_end = Stop;
    end



    //---load_use-----//
    wire rt_equ_EX_RegWrite, rs_equ_EX_RegWrite;
    wire load_usecheck_rs_rt, load_usecheck_rs, load_usecheck_rt;

    assign rt_equ_EX_RegWrite = (rt == RD_out_id_ex) ? 1 : 0;
    assign rs_equ_EX_RegWrite = (rs == RD_out_id_ex) ? 1 : 0;

    assign load_usecheck_rs = rs_equ_EX_RegWrite & EX_RegWrite;
    assign load_usecheck_rt = rt_equ_EX_RegWrite & EX_RegWrite;
    assign load_usecheck_rs_rt = load_usecheck_rs | load_usecheck_rt;

    wire id_ex_isNop = (IR_out_id_ex == 0) ? 1 : 0;

    wire load_use_relative;
    assign load_use_relative =
      (((MemWrite | MemRead | beq | bne | R) & ~syscall & load_usecheck_rs_rt)
      | ((I | syscall) & load_usecheck_rs)) & ~id_ex_isNop;

    assign PCdst = EX_Jr | Branch | EX_Jump;

    wire rt_Mem_relative, rs_Mem_relative, rt_Wb_relative, rs_Wb_relative;
    assign rt_Mem_relative = (EX_rt == RDdst_out_ex_mem) ? (MEM_RegWrite) : 0;
    assign rs_Mem_relative = (EX_rs == RDdst_out_ex_mem) ? (MEM_RegWrite) : 0;
    assign rt_Wb_relative = (EX_rt == RDdst_out_mem_wb) ? (WB_RegWrite) : 0;
    assign rs_Wb_relative = (EX_rs == RDdst_out_mem_wb) ? (WB_RegWrite) : 0;

    wire check_rs, check_rt, check_rs_rt;
    assign check_rs = rs_Mem_relative | rs_Wb_relative;
    assign check_rt = rt_Mem_relative | rt_Wb_relative;
    assign check_rs_rt = check_rs | check_rt;

    wire data_relative;
    wire check_2Reg, check_1Reg;
    assign check_2Reg = ((EX_MemWrite | EX_MemRead | EX_beq | EX_bne | EX_R) & ~EX_syscall) & check_rs_rt;
    assign check_1Reg = (EX_I | EX_syscall) & check_rs;
    assign data_relative =  (check_2Reg | check_1Reg) & ~id_ex_isNop;

    assign load_use = EX_MemRead & load_use_relative;

    wire rt_Mem, rt_Wb, rs_Mem, rs_Wb;
    assign rt_Mem = data_relative & rt_Mem_relative;
    assign rt_Wb = data_relative & rt_Wb_relative;
    assign rs_Mem = data_relative & rs_Mem_relative;
    assign rs_Wb = data_relative & rs_Wb_relative;

    wire [31:0] data_from_mem, data_from_wb;
    assign data_from_mem = AluOut_out_ex_mem;
    assign data_from_wb = DataToReg;

    wire [31:0] rs_temp, rt_temp;
    assign rs_temp = (rs_Wb) ? data_from_wb : R1_out_id_ex;
    assign rt_temp = (rt_Wb) ? data_from_wb : R2_out_id_ex;

    assign data2rs = (rs_Mem) ? data_from_mem : rs_temp;
    assign data2rt = (rt_Mem) ? data_from_mem : rt_temp;

    //---load_use-----//

    //-----seg_num-----//
    reg [31:0] seg_num = 0;
    always @ ( posedge clk) begin
      if(EX_syscall)
        seg_num = data2rt;
    end

    reg [31:0] N = 0;
    always @ ( posedge clk ) begin
      case(change_seg_shown)
      0 : N = seg_num;
      1 : N = cnt;
      2 : N = load_use_cnt;
      3 : N = Branch_cnt;
      endcase
    end
    shownum my_shown(
    			N,
    			clk_1000_ms,
    			seg_out,
    			seg_an,
    			dp
    			);
endmodule
