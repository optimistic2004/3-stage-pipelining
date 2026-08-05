`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.07.2026 21:47:18
// Design Name: 
// Module Name: tst_control
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


module tst_control;
 logic [6:0] opcode;
  logic [2:0] funct3;
  logic [6:0] funct7;
  logic [3:0] alu_op;
  logic      alu_src;   // 0=rs2_data,1=immediate
  logic        reg_write; // 1=write result to rd
  logic        mem_read;  // 1=load instruction
  logic       mem_write; // 1=store instruction
  logic  [1:0] wb_sel;    // 00=ALU, 01=mem, 10=PC+4
  logic     branch;    // 1=branch instruction
  logic        jump;
  
  control_unit dut(
    .opcode   (opcode),
    .funct3   (funct3),
    .funct7   (funct7),
    .alu_op   (alu_op),
    .alu_src  (alu_src),
    .reg_write(reg_write),
    .mem_read (mem_read),
    .mem_write(mem_write),
    .wb_sel   (wb_sel),
    .branch   (branch),
    .jump     (jump)
  );
  
  covergroup cntrl;
  op:coverpoint opcode{
       bins R_TYPE  = {7'b0110011};
        bins I_TYPE  = {7'b0010011};
        bins LOAD    = {7'b0000011};
        bins STORE   = {7'b0100011};
        bins BRANCH  = {7'b1100011};
        bins LUI     = {7'b0110111};
        bins AUIPC   = {7'b0010111};
        bins JAL     = {7'b1101111};
        bins JALR    = {7'b1100111};
    }
    f3:coverpoint funct3{
    bins values[]={[0:7]};
    }
    
    coverpoint alu_op {
        bins ADD  = {4'b0000};
        bins SUB  = {4'b0001};
        bins XOR  = {4'b0010};
        bins SRL  = {4'b0011};
        bins SRA  = {4'b0100};
        bins SLL  = {4'b0101};
        bins SLT  = {4'b0110};
        bins SLTU = {4'b0111};
        bins OR   = {4'b1000};
        bins AND  = {4'b1001};
        bins LUI  = {4'b1010};
    }
    coverpoint mem_read;
    coverpoint mem_write;
    coverpoint reg_write;
    coverpoint branch;
    coverpoint jump;
    coverpoint alu_src;
    coverpoint wb_sel;
    
  endgroup
  
  cntrl cov=new();
   integer pass_count,fail_count;
  
  task check;
  input [127:0] label;
  input [6:0]   in_opcode;
  input [2:0]   in_funct3;
  input [6:0]   in_funct7;
  // expected outputs
  input [3:0]   exp_alu_op;
  input         exp_alu_src;
  input         exp_reg_write;
  input         exp_mem_read;
  input         exp_mem_write;
  input [1:0]   exp_wb_sel;
  input         exp_branch;
  input         exp_jump;
  begin
    // set inputs
    opcode = in_opcode;
    funct3 = in_funct3;
    funct7 = in_funct7;
    #10;

    if (alu_op    === exp_alu_op    &&
        alu_src   === exp_alu_src   &&
        reg_write === exp_reg_write &&
        mem_read  === exp_mem_read  &&
        mem_write === exp_mem_write &&
        wb_sel    === exp_wb_sel    &&
        branch    === exp_branch    &&
        jump      === exp_jump) begin
      $display("PASS %0s", label);
      pass_count = pass_count + 1;
    end else begin
      $display("FAIL %0s", label);
      $display("  alu_op    exp=%04b got=%04b", exp_alu_op,    alu_op);
      $display("  alu_src   exp=%b   got=%b",   exp_alu_src,   alu_src);
      $display("  reg_write exp=%b   got=%b",   exp_reg_write, reg_write);
      $display("  mem_read  exp=%b   got=%b",   exp_mem_read,  mem_read);
      $display("  mem_write exp=%b   got=%b",   exp_mem_write, mem_write);
      $display("  wb_sel    exp=%02b  got=%02b", exp_wb_sel,    wb_sel);
      $display("  branch    exp=%b   got=%b",   exp_branch,    branch);
      $display("  jump      exp=%b   got=%b",   exp_jump,      jump);
      fail_count = fail_count + 1;
    end
  end
endtask
  
 initial begin
  pass_count = 0;
  fail_count = 0;

  //          label     opc        f3     f7          aluop  src  rw  mr  mw  wb    br  jmp
  check("ADD",  7'b0110011, 3'b000, 7'b0000000,  4'b0000, 0,   1,  0,  0,  2'b00, 0,  0);
  cov.sample();
  check("SUB",  7'b0110011, 3'b000, 7'b0100000,  4'b0001, 0,   1,  0,  0,  2'b00, 0,  0);
   cov.sample();
  check("SLL",  7'b0110011, 3'b001, 7'b0000000,  4'b0101, 0,   1,  0,  0,  2'b00, 0,  0);
   cov.sample();
  check("SLT",  7'b0110011, 3'b010, 7'b0000000,  4'b0110, 0,   1,  0,  0,  2'b00, 0,  0);
   cov.sample();
  check("SLTU", 7'b0110011, 3'b011, 7'b0000000,  4'b0111, 0,   1,  0,  0,  2'b00, 0,  0);
   cov.sample();
  check("XOR",  7'b0110011, 3'b100, 7'b0000000,  4'b0010, 0,   1,  0,  0,  2'b00, 0,  0);
   cov.sample();
  check("SRL",  7'b0110011, 3'b101, 7'b0000000,  4'b0011, 0,   1,  0,  0,  2'b00, 0,  0);
   cov.sample();
  check("SRA",  7'b0110011, 3'b101, 7'b0100000,  4'b0100, 0,   1,  0,  0,  2'b00, 0,  0);
   cov.sample();
  check("OR",   7'b0110011, 3'b110, 7'b0000000,  4'b1000, 0,   1,  0,  0,  2'b00, 0,  0);
   cov.sample();
  check("AND",  7'b0110011, 3'b111, 7'b0000000,  4'b1001, 0,   1,  0,  0,  2'b00, 0,  0);
   cov.sample();

  check("ADDI", 7'b0010011, 3'b000, 7'b0000000,  4'b0000, 1,   1,  0,  0,  2'b00, 0,  0);
   cov.sample();
  check("ANDI", 7'b0010011, 3'b111, 7'b0000000,  4'b1001, 1,   1,  0,  0,  2'b00, 0,  0);
   cov.sample();
  check("SRLI", 7'b0010011, 3'b101, 7'b0000000,  4'b0011, 1,   1,  0,  0,  2'b00, 0,  0);
   cov.sample();
  check("SRAI", 7'b0010011, 3'b101, 7'b0100000,  4'b0100, 1,   1,  0,  0,  2'b00, 0,  0);
   cov.sample();

  check("LW",   7'b0000011, 3'b010, 7'b0000000,  4'b0000, 1,   1,  1,  0,  2'b01, 0,  0);
   cov.sample();
  check("SW",   7'b0100011, 3'b010, 7'b0000000,  4'b0000, 1,   0,  0,  1,  2'b00, 0,  0);
   cov.sample();
  check("BEQ",  7'b1100011, 3'b000, 7'b0000000,  4'b0001, 0,   0,  0,  0,  2'b00, 1,  0);
   cov.sample();
  check("JAL",  7'b1101111, 3'b000, 7'b0000000,  4'b0000, 1,   1,  0,  0,  2'b10, 0,  1);
   cov.sample();
  check("LUI",  7'b0110111, 3'b000, 7'b0000000,  4'b1010, 1,   1,  0,  0,  2'b00, 0,  0);
   cov.sample();

  // unknown opcode - everything should be 0
  check("UNKNOWN", 7'b1111111, 3'b000, 7'b0000000, 4'b0000, 0,  0,  0,  0,  2'b00, 0,  0);

  $display("\n==========================================");
  $display("  passed: %0d   failed: %0d", pass_count, fail_count);
  $display("==========================================");
  
  $display("------------------------------------");
$display("Coverage = %0.2f %%", cov.get_coverage());
$display("------------------------------------");
  $finish;
 end
endmodule

