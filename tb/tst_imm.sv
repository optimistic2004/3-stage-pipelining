`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.07.2026 21:43:31
// Design Name: 
// Module Name: tst_imm
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


module tst_imm;
logic [31:0] instruction;
 logic [2:0]  imm_type;
  logic  [31:0] immediate;
  
  immediate_generator dut(.instruction(instruction),
                           .imm_type(imm_type),
                           .immediate(immediate));
  
  
  initial begin
  instruction=32'b0;
  end
  
  task check;
  input [31:0] expected;
  input [31:0] got;
  begin
 if (got === expected) begin
        $display(" Pass: expected=%h , got=%h", expected, got);
        end else begin
        $display("  Fail:  expected=%h,  got=%h", expected, got);
        end
        end
        endtask
        
 initial begin
    // ---------- test-1: R-type ----------
    // ADD x5, x1, x2  -> funct7=0000000, rs2=2, rs1=1, funct3=000, rd=5, opcode=0110011
    $display("\ntest-1: R-type");
    instruction = {7'b0000000, 5'd2, 5'd1, 3'b000, 5'd5, 7'b0110011};
    imm_type = 3'b101;              // R-type -> immediate forced to 0
    #3;
    check(32'h00000000, immediate);
 
    // ---------- test-2: I-type positive ----------
    // ADDI x5, x1, +5 -> imm=12'h005, rs1=1, funct3=000, rd=5, opcode=0010011
    $display("\ntest-2: I-type (+)");
    instruction = {12'h005, 5'd1, 3'b000, 5'd5, 7'b0010011};
    imm_type = 3'b000;
    #3;
    check(32'h00000005, immediate);
 
    // ---------- test-3: I-type negative ----------
    // ADDI x5, x1, -5 -> imm=12'hffb, rs1=1, funct3=000, rd=5, opcode=0010011
    $display("\ntest-3: I-type (-)");
    instruction = {12'hffb, 5'd1, 3'b000, 5'd5, 7'b0010011};
    imm_type = 3'b000;
    #3;
    check(32'hfffffffb, immediate);
 
    // ---------- test-4: I-type load ----------
    // LW x3, 16(x2) -> imm=12'h010, rs1=2, funct3=010, rd=3, opcode=0000011
    $display("\ntest-4: I-type load (LW)");
    instruction = {12'h010, 5'd2, 3'b010, 5'd3, 7'b0000011};
    imm_type = 3'b000;
    #3;
    check(32'h00000010, immediate);
 
    // ---------- test-5: I-type JALR ----------
    // JALR x0, 4(x1) -> imm=12'h004, rs1=1, funct3=000, rd=0, opcode=1100111
    $display("\ntest-5: I-type (JALR)");
    instruction = {12'h004, 5'd1, 3'b000, 5'd0, 7'b1100111};
    imm_type = 3'b000;
    #3;
    check(32'h00000004, immediate);
 
    // ---------- test-6: S-type positive ----------
    // SW x2, 32(x1) -> imm=12'h020 -> imm[11:5]=0000001, imm[4:0]=00000
    // rs2=2, rs1=1, funct3=010, opcode=0100011
    $display("\ntest-6: S-type (+)");
    instruction = {7'b0000001, 5'd2, 5'd1, 3'b010, 5'b00000, 7'b0100011};
    imm_type = 3'b001;
    #3;
    check(32'h00000020, immediate);
 
    // ---------- test-7: S-type negative ----------
    // SW x2, -32(x1) -> imm=12'hfe0 -> imm[11:5]=1111111, imm[4:0]=00000
    $display("\ntest-7: S-type (-)");
    instruction = {7'b1111111, 5'd2, 5'd1, 3'b010, 5'b00000, 7'b0100011};
    imm_type = 3'b001;
    #3;
    check(32'hffffffe0, immediate);
 
    // ---------- test-8: B-type positive ----------
    // BEQ x1, x2, +8 -> imm[12]=0, imm[10:5]=000000, imm[4:1]=0100, imm[11]=0
    $display("\ntest-8: B-type (+)");
    instruction = {1'b0, 6'b000000, 5'd2, 5'd1, 3'b000, 4'b0100, 1'b0, 7'b1100011};
    imm_type = 3'b010;
    #3;
    check(32'h00000008, immediate);
 
    // ---------- test-9: B-type negative ----------
    // BNE x1, x2, -8 -> imm[12]=1, imm[11]=1, imm[10:5]=111111, imm[4:1]=1100
    $display("\ntest-9: B-type (-)");
    instruction = {1'b1, 6'b111111, 5'd2, 5'd1, 3'b001, 4'b1100, 1'b1, 7'b1100011};
    imm_type = 3'b010;
    #3;
    check(32'hfffffff8, immediate);
 
    // ---------- test-10: U-type LUI ----------
    // LUI x5, 0x12345 -> imm[31:12]=20'h12345, rd=5, opcode=0110111
    $display("\ntest-10: U-type (LUI)");
    instruction = {20'h12345, 5'd5, 7'b0110111};
    imm_type = 3'b011;
    #3;
    check(32'h12345000, immediate);
 
    // ---------- test-11: U-type AUIPC ----------
    // AUIPC x6, 0xabcde -> imm[31:12]=20'habcde, rd=6, opcode=0010111
    $display("\ntest-11: U-type (AUIPC)");
    instruction = {20'habcde, 5'd6, 7'b0010111};
    imm_type = 3'b011;
    #3;
    check(32'habcde000, immediate);
 
    // ---------- test-12: J-type positive ----------
    // JAL x1, +16 -> imm[20]=0, imm[19:12]=00000000, imm[11]=0, imm[10:1]=0000001000
    $display("\ntest-12: J-type (+)");
    instruction = {1'b0, 10'b0000001000, 1'b0, 8'b00000000, 5'd1, 7'b1101111};
    imm_type = 3'b100;
    #3;
    check(32'h00000010, immediate);
 
    // ---------- test-13: J-type negative ----------
    // JAL x2, -2 -> imm[20]=1, imm[19:12]=11111111, imm[11]=1, imm[10:1]=1111111111
    $display("\ntest-13: J-type (-)");
    instruction = {1'b1, 10'b1111111111, 1'b1, 8'b11111111, 5'd2, 7'b1101111};
    imm_type = 3'b100;
    #3;
    check(32'hfffffffe, immediate);
 
    $display("\nAll tests complete.");
    $finish;
  end
 
endmodule
