`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.07.2026 21:18:24
// Design Name: 
// Module Name: tst_decoder
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


module tst_decoder;
logic [31:0] instr;
  logic [6:0]  opcode;   
 logic[4:0]  rs1;
  logic [4:0]  rs2;
 logic [4:0]  rd;
  logic [2:0]  funct3;
 logic [6:0]  funct7;
  logic [31:0] immediate;
  logic  [2:0]  imm_type;
  
   id_decoder dut (
    .instr    (instr),
    .opcode   (opcode),
    .rs1      (rs1),
    .rs2      (rs2),
    .rd       (rd),
    .funct3   (funct3),
    .funct7   (funct7),
    .immediate(immediate),
    .imm_type (imm_type)
  );
  
   
  integer pass_count, fail_count;

  
  task check;
    input [63:0]  got;
    input [63:0]  expected;
    input [127:0] label;
    begin
      if (got === expected) begin
        $display("  PASS  %0s  got=%0h", label, got);
        pass_count = pass_count + 1;
      end else begin
        $display("  FAIL  %0s  expected=%0h  got=%0h", label, expected, got);
        fail_count = fail_count + 1;
      end
    end
  endtask

  // ── main test sequence ──────────────────────────────────
  initial begin
    pass_count = 0;
    fail_count = 0;
    instr = 32'b0;
    #10;

    // ════════════════════════════════════════════════════
    // TEST 1 - R-type   ADD x3, x1, x2
    //   funct7=0000000  rs2=x2(00010)  rs1=x1(00001)
    //   funct3=000  rd=x3(00011)  opcode=0110011
    // ════════════════════════════════════════════════════
    $display("\n--- TEST 1: R-type  ADD x3, x1, x2 ---");
    instr = 32'b0000000_00010_00001_000_00011_0110011;
    #10;
    check(opcode,    7'b0110011,       "opcode   ");
    check(rs1,       5'd1,             "rs1      ");
    check(rs2,       5'd2,             "rs2      ");
    check(rd,        5'd3,             "rd       ");
    check(funct3,    3'b000,           "funct3   ");
    check(funct7,    7'b0000000,       "funct7   ");
    check(imm_type,  3'b101,           "imm_type ");

    // ════════════════════════════════════════════════════
    // TEST 2 - I-type   ADDI x5, x1, 12
    //   imm[11:0]=000000001100  rs1=x1  funct3=000
    //   rd=x5  opcode=0010011
    //   expected immediate = 32'h0000000C (sign-extended 12)
    // ════════════════════════════════════════════════════
    $display("\n--- TEST 2: I-type  ADDI x5, x1, 12 ---");
    instr = 32'b000000001100_00001_000_00101_0010011;
    #10;
    check(opcode,    7'b0010011,       "opcode   ");
    check(rs1,       5'd1,             "rs1      ");
    check(rd,        5'd5,             "rd       ");
    check(funct3,    3'b000,           "funct3   ");
    check(imm_type,  3'b000,           "imm_type ");
    check(immediate, 32'h0000000C,     "immediate");

    // ════════════════════════════════════════════════════
    // TEST 3 - I-type negative   ADDI x5, x1, -4
    //   imm = 111111111100 (two's complement -4)
    //   expected immediate = 32'hFFFFFFFC
    // ════════════════════════════════════════════════════
    $display("\n--- TEST 3: I-type  ADDI x5, x1, -4 ---");
    instr = 32'b111111111100_00001_000_00101_0010011;
    #10;
    check(imm_type,  3'b000,           "imm_type ");
    check(immediate, 32'hFFFFFFFC,     "immediate");

    // ════════════════════════════════════════════════════
    // TEST 4 - Load   LW x6, 8(x2)
    //   imm=000000001000  rs1=x2  funct3=010
    //   rd=x6  opcode=0000011
    //   expected immediate = 32'h00000008
    // ════════════════════════════════════════════════════
    $display("\n--- TEST 4: I-type (load)  LW x6, 8(x2) ---");
    instr = 32'b000000001000_00010_010_00110_0000011;
    #10;
    check(opcode,    7'b0000011,       "opcode   ");
    check(rs1,       5'd2,             "rs1      ");
    check(rd,        5'd6,             "rd       ");
    check(funct3,    3'b010,           "funct3   ");
    check(imm_type,  3'b000,           "imm_type ");
    check(immediate, 32'h00000008,     "immediate");

    // ════════════════════════════════════════════════════
    // TEST 5 - S-type   SW x2, 16(x1)
    //   imm[11:5]=0000001  rs2=x2  rs1=x1  funct3=010
    //   imm[4:0]=10000  opcode=0100011
    //   imm = 0000001_10000 = 32 (decimal) → 32'h00000010... 
    //   wait: 16 decimal = 0x10
    //   imm[11:5]=0000000  imm[4:0]=10000 → 0b0000000_10000 = 16
    // ════════════════════════════════════════════════════
    $display("\n--- TEST 5: S-type  SW x2, 16(x1) ---");
    instr = 32'b0000000_00010_00001_010_10000_0100011;
    #10;
    check(opcode,    7'b0100011,       "opcode   ");
    check(rs1,       5'd1,             "rs1      ");
    check(rs2,       5'd2,             "rs2      ");
    check(funct3,    3'b010,           "funct3   ");
    check(imm_type,  3'b001,           "imm_type ");
    check(immediate, 32'h00000010,     "immediate");

    // ════════════════════════════════════════════════════
    // TEST 6 - B-type   BEQ x1, x2, +8
    //   offset = 8 = 0b0_000000_0100_0
    //   imm[12]=0 imm[10:5]=000000 imm[4:1]=0100 imm[11]=0
    //   instruction[31]=0  [7]=0  [30:25]=000000
    //   [11:8]=0100
    // ════════════════════════════════════════════════════
    $display("\n--- TEST 6: B-type  BEQ x1, x2, +8 ---");
    instr = 32'b0_000000_00010_00001_000_0100_0_1100011;
    #10;
    check(opcode,    7'b1100011,       "opcode   ");
    check(rs1,       5'd1,             "rs1      ");
    check(rs2,       5'd2,             "rs2      ");
    check(funct3,    3'b000,           "funct3   ");
    check(imm_type,  3'b010,           "imm_type ");
    check(immediate, 32'h00000008,     "immediate");

    // ════════════════════════════════════════════════════
    // TEST 7 - U-type   LUI x7, 0x12345
    //   imm[31:12] = 0x12345
    //   expected immediate = 32'h12345000
    // ════════════════════════════════════════════════════
    $display("\n--- TEST 7: U-type  LUI x7, 0x12345 ---");
    instr = 32'b00010010001101000101_00111_0110111;
    #10;
    check(opcode,    7'b0110111,       "opcode   ");
    check(rd,        5'd7,             "rd       ");
    check(imm_type,  3'b011,           "imm_type ");
    check(immediate, 32'h12345000,     "immediate");

    // ════════════════════════════════════════════════════
    // TEST 8 - J-type   JAL x1, +20
    //   offset = 20 = 0b0_0000000001_0_00000010100
    //   imm[20]=0 imm[10:1]=0000001010 imm[11]=0 imm[19:12]=00000000
    //   expected immediate = 32'h00000014
    // ════════════════════════════════════════════════════
    $display("\n--- TEST 8: J-type  JAL x1, +20 ---");
    //          [31]  [30:21]     [20] [19:12]   rd    opcode
    instr = 32'b0_0000001010_0_00000000_00001_1101111;
    #10;
    check(opcode,    7'b1101111,       "opcode   ");
    check(rd,        5'd1,             "rd       ");
    check(imm_type,  3'b100,           "imm_type ");
    check(immediate, 32'h00000014,     "immediate");

    // ════════════════════════════════════════════════════
    // TEST 9 - JALR   JALR x0, x1, 0
    //   I-type, imm=0
    // ════════════════════════════════════════════════════
    $display("\n--- TEST 9: I-type (JALR)  JALR x0, x1, 0 ---");
    instr = 32'b000000000000_00001_000_00000_1100111;
    #10;
    check(opcode,    7'b1100111,       "opcode   ");
    check(rs1,       5'd1,             "rs1      ");
    check(rd,        5'd0,             "rd       ");
    check(imm_type,  3'b000,           "imm_type ");
    check(immediate, 32'h00000000,     "immediate");

    // ════════════════════════════════════════════════════
    // TEST 10 - default/unknown opcode
    // ════════════════════════════════════════════════════
    $display("\n--- TEST 10: unknown opcode ---");
    instr = 32'hDEADBEEF;
    #10;
    check(imm_type,  3'b000,           "imm_type ");

   
    $display("\n==========================================");
    $display("  RESULTS:  %0d passed,  %0d failed", pass_count, fail_count);
    $display("==========================================\n");

    $finish;
  end

 


  
  
  endmodule
