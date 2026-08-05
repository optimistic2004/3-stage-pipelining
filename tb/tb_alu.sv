`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.08.2026 20:29:56
// Design Name: 
// Module Name: tb_alu
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

module alu_tst;

  // ── inputs ──────────────────────────────────
  logic [31:0] rs1_data;
  logic [31:0] rs2_data;
  logic [31:0] immediate;
  logic        alu_src;
  logic [3:0]  alu_op;

  // ── outputs ─────────────────────────────────
  logic [31:0] result;
  logic        zero;
  logic        negative;
  logic        overflow;

  // ── DUT ─────────────────────────────────────
  alu dut(
    .rs1_data (rs1_data),
    .rs2_data (rs2_data),
    .immediate(immediate),
    .alu_src  (alu_src),
    .alu_op   (alu_op),
    .result   (result),
    .zero     (zero),
    .negative (negative),
    .overflow (overflow)
  );

  integer pass_count, fail_count;

  // ── task ─────────────────────────────────────
  task check;
    input [127:0] label;
    // inputs to drive
    input [31:0]  in_rs1_data;
    input [31:0]  in_rs2_data;
    input [31:0]  in_immediate;
    input         in_alu_src;
    input [3:0]   in_alu_op;
    // expected outputs
    input [31:0]  exp_result;
    input         exp_zero;
    input         exp_negative;
    input         exp_overflow;
    begin
      // drive inputs
      rs1_data  = in_rs1_data;
      rs2_data  = in_rs2_data;
      immediate = in_immediate;
      alu_src   = in_alu_src;
      alu_op    = in_alu_op;
      #10; // wait for combinational logic to settle

      if (result   === exp_result   &&
          zero     === exp_zero     &&
          negative === exp_negative &&
          overflow === exp_overflow) begin
        $display("PASS %0s", label);
        pass_count = pass_count + 1;
      end else begin
        $display("FAIL %0s", label);
        if (result   !== exp_result) begin
          $display("  result   exp=%h got=%h", exp_result,   result);
        end
        if (zero     !== exp_zero) begin
          $display("  zero     exp=%b got=%b", exp_zero,     zero);
        end
        if (negative !== exp_negative) begin
          $display("  negative exp=%b got=%b", exp_negative, negative);
        end
        if (overflow !== exp_overflow) begin
          $display("  overflow exp=%b got=%b", exp_overflow, overflow);
        end
        fail_count = fail_count + 1;
      end
    end
  endtask
  
  covergroup alu_co;
  al:coverpoint alu_op {
     bins ADD={4'b0000};
     bins SUB={4'b0001};
     bins xorr={4'b0010};
     bins SRL={4'b0011};
     bins SRA={4'b0100};
     bins SLL={4'b0101};
     bins SLT={4'b0110};
     bins ORR={4'b1000};
     bins ANDD={4'b1001};
     }
   src: coverpoint alu_src{
    bins imm={1,0};}
    //bins sec_op={0}} 
     
                    
endgroup
 alu_co cov=new();   
  initial begin
  
    pass_count = 0;
    fail_count = 0;

    // ── ADD tests ────────────────────────────
    //       label         rs1          rs2          imm          src  op      exp_result   z  n  ov
    check("ADD basic",
      32'h00000005, 32'h00000003, 32'h00000000, 0, 4'b0000,
      32'h00000008, 0, 0, 0);
      cov.sample();
    check("ADD zero result",
      32'h00000005, 32'hFFFFFFFB, 32'h00000000, 0, 4'b0000,
      32'h00000000, 1, 0, 0);  // zero flag must be 1
      cov.sample();
    check("ADD negative result",
      32'h00000001, 32'hFFFFFFFE, 32'h00000000, 0, 4'b0000,
      32'hFFFFFFFF, 0, 1, 0);  // negative flag must be 1
      cov.sample();
    check("ADD overflow pos+pos=neg",
      32'h7FFFFFFF, 32'h00000001, 32'h00000000, 0, 4'b0000,
      32'h80000000, 0, 1, 1);  // overflow must be 1
      cov.sample();
    // ── ADDI tests (alu_src=1) ───────────────
    check("ADDI basic",
      32'h00000005, 32'h00000000, 32'h0000000C, 1, 4'b0000,
      32'h00000011, 0, 0, 0);  // uses immediate not rs2
     cov.sample();
    check("ADDI negative imm",
      32'h00000010, 32'h00000000, 32'hFFFFFFFC, 1, 4'b0000,
      32'h0000000C, 0, 0, 0);  // 16 + (-4) = 12
     cov.sample();
    // ── SUB tests ────────────────────────────
    check("SUB basic",
      32'h00000008, 32'h00000003, 32'h00000000, 0, 4'b0001,
      32'h00000005, 0, 0, 0);
     cov.sample();
    check("SUB zero result",
      32'h00000005, 32'h00000005, 32'h00000000, 0, 4'b0001,
      32'h00000000, 1, 0, 0);  // zero flag must be 1
      cov.sample();
    check("SUB overflow neg-pos=pos",
      32'h80000000, 32'h00000001, 32'h00000000, 0, 4'b0001,
      32'h7FFFFFFF, 0, 0, 1);  // overflow must be 1
     cov.sample();
    // ── XOR tests ────────────────────────────
    check("XOR basic",
      32'hFF00FF00, 32'h0F0F0F0F, 32'h00000000, 0, 4'b0010,
      32'hF00FF00F, 0, 1, 0);
      cov.sample();
    check("XOR same values",
      32'hDEADBEEF, 32'hDEADBEEF, 32'h00000000, 0, 4'b0010,
      32'h00000000, 1, 0, 0);  // zero flag must be 1
      cov.sample();
    // ── SLL tests ────────────────────────────
    check("SLL by 1",
      32'h00000001, 32'h00000001, 32'h00000000, 0, 4'b0101,
      32'h00000002, 0, 0, 0);
      cov.sample();
    check("SLL by 4",
      32'h00000001, 32'h00000004, 32'h00000000, 0, 4'b0101,
      32'h00000010, 0, 0, 0);
     cov.sample();
    // ── SRL tests ────────────────────────────
    check("SRL basic",
      32'h00000008, 32'h00000001, 32'h00000000, 0, 4'b0011,
      32'h00000004, 0, 0, 0);
    cov.sample();
    check("SRL no sign extend",
      32'h80000000, 32'h00000001, 32'h00000000, 0, 4'b0011,
      32'h40000000, 0, 0, 0);  // MSB becomes 0
   cov.sample();
    // ── SRA tests ────────────────────────────
    check("SRA sign extends",
      32'h80000000, 32'h00000001, 32'h00000000, 0, 4'b0100,
      32'hC0000000, 0, 1, 0);  // MSB stays 1
    cov.sample();
    // ── SLT tests ────────────────────────────
    check("SLT less than",
      32'h00000001, 32'h00000002, 32'h00000000, 0, 4'b0110,
      32'h00000001, 0, 0, 0);  // 1 < 2 → result=1
    cov.sample();
    check("SLT not less than",
      32'h00000005, 32'h00000003, 32'h00000000, 0, 4'b0110,
      32'h00000000, 1, 0, 0);  // 5 < 3 false → result=0
    cov.sample();
    check("SLT negative signed",
      32'hFFFFFFFF, 32'h00000001, 32'h00000000, 0, 4'b0110,
      32'h00000001, 0, 0, 0);  // -1 < 1 → result=1
    cov.sample();
    // ── SLTU tests ───────────────────────────
    check("SLTU unsigned",
      32'hFFFFFFFF, 32'h00000001, 32'h00000000, 0, 4'b0111,
      32'h00000000, 1, 0, 0);  // 0xFFFFFFFF > 1 unsigned → result=0
    cov.sample();
    // ── OR tests ─────────────────────────────
    check("OR basic",
      32'hFF000000, 32'h00FF0000, 32'h00000000, 0, 4'b1000,
      32'hFFFF0000, 0, 1, 0);
     cov.sample();
    // ── AND tests ────────────────────────────
    check("AND basic",
      32'hFF00FF00, 32'h0F0F0F0F, 32'h00000000, 0, 4'b1001,
      32'h0F000F00, 0, 0, 0);
      cov.sample();
    // ── LUI passthrough ──────────────────────
    check("LUI passthrough",
      32'h00000000, 32'h00000000, 32'h12345000, 1, 4'b1010,
      32'h12345000, 0, 0, 0);  // immediate passes through
       cov.sample();
    // ── unknown opcode ───────────────────────
    check("unknown alu_op",
      32'hDEADBEEF, 32'hDEADBEEF, 32'h00000000, 0, 4'b1111,
      32'h00000000, 1, 0, 0);  // default = 0
   cov.sample();

    $display("  passed: %0d   failed: %0d", pass_count, fail_count);
    
$display("Coverage = %0.2f %%", cov.get_coverage());

    $finish;
    
  end


endmodule