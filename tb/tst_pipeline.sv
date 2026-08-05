`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.08.2026 15:33:34
// Design Name: 
// Module Name: tst_pipeline
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


module tst_pipeline;

  // ── inputs ──────────────────────────────────
  logic clk;
  logic reset;

  // ── DUT ─────────────────────────────────────
  pipeline dut(
    .clk  (clk),
    .reset(reset)
  );
  
 always #5 clk=~clk;
 
 

always@(posedge clk) begin
if(!reset) begin
 $display("Time        = %0t",$time);
$display("PC=%h",dut.pc_current);
$display("Instruction=%h",dut.instruction);
$display("Opcode=%b",dut.opcode);
$display("ALU result=%h",dut.ex_result);
end
end

covergroup pipe;

    coverpoint dut.pc_current
    {
      bins PC0  = {32'h00000000};
      bins PC4  = {32'h00000004};
      bins PC8  = {32'h00000008};
      bins PC12 = {32'h0000000C};
      bins PC16 = {32'h00000010};
      bins PC20 = {32'h00000014};
      bins PC24 = {32'h00000018};
      bins PC28 = {32'h0000001C};
    }
    
  op:coverpoint dut.opcode{
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
    
    coverpoint dut.ex_alu_op{
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
    
    
     
endgroup
pipe cov=new();
 always @(posedge clk)
    if(!reset)  cov.sample();
      
   task wait_cycles(input integer n);
  integer i;
  begin
      for(i=0;i<n;i=i+1)
          @(posedge clk);
      #1;
  end
  endtask
  
  task rst_check;
  begin
      reset = 1;
      repeat(2) @(posedge clk);
      #1;
      assert(dut.pc_current == 0);
      assert(dut.id_in == 0);
      assert(dut.id_pc == 0);
      reset = 0;
  end
  endtask


task check_pipeline;
begin
  // cycle1
      wait_cycles(1);
      assert (dut.instruction == 32'h002081B3)
        else $error("Cycle1 IF mismatch: got %h", dut.instruction);
 
      // cycle2 (2 more cycles => total 3 from reset release)
      wait_cycles(2);
      assert (dut.opcode == 7'b0110011) else $error("cycle3 opcode mismatch");
      assert (dut.rs1    == 5'd1)       else $error("cycle3 rs1 mismatch");
      assert (dut.rs2    == 5'd2)       else $error("cycle3 rs2 mismatch");
      assert (dut.rd     == 5'd3)       else $error("cycle3 rd mismatch");
      assert (dut.funct3 == 3'b000)     else $error("cycle3 funct3 mismatch");
      assert (dut.funct7 == 7'b0000000) else $error("cycle3 funct7 mismatch");
 
      // cycle3: ALU executes ADD, decoder shows SUB
      wait_cycles(3);
      assert (dut.ex_result == 32'd30)      else $error("cycle6 ADD result mismatch: %0d", dut.ex_result);
      assert (dut.ex_alu_op == 4'b0000)     else $error("cycle6 alu_op mismatch");
      assert (dut.rs1    == 5'd2)           else $error("cycle6 rs1 mismatch");
      assert (dut.rs2    == 5'd1)           else $error("cycle6 rs2 mismatch");
      assert (dut.rd     == 5'd4)           else $error("cycle6 rd mismatch");
      assert (dut.funct7 == 7'b0100000)     else $error("cycle6 funct7 mismatch");
 
      // cycle4: IF=and, ID=addi, EX=sub
      wait_cycles(4);
      assert (dut.opcode    == 7'b0010011) else $error("cycle10 opcode mismatch");
      assert (dut.rs1       == 5'd1)       else $error("cycle10 rs1 mismatch");
      assert (dut.rd        == 5'd5)       else $error("cycle10 rd mismatch");
      assert (dut.ex_result == 32'd10)     else $error("cycle10 SUB result mismatch: %0d", dut.ex_result);
 
      // cycle5: EX=addi(instr2), ID=and(instr3)
      wait_cycles(5);
      assert (dut.ex_result == 32'd20)  else $error("cycle15 ADDI result mismatch: %0d", dut.ex_result);
      assert (dut.funct3    == 3'b111)  else $error("cycle15 funct3 mismatch (expected AND funct3)");
 
      // cycle6: EX=and(instr3), ID=or(instr4)
      wait_cycles(6);
      assert (dut.ex_result == 32'd0)    else $error("cycle21 AND result mismatch: %0d", dut.ex_result);
      assert (dut.ex_alu_op == 4'b1001)  else $error("cycle21 AND alu_op mismatch");
      assert (dut.opcode    == 7'b0110011) else $error("cycle21 opcode mismatch");
      assert (dut.rs1       == 5'd1)     else $error("cycle21 rs1 mismatch");
      assert (dut.rs2       == 5'd2)     else $error("cycle21 rs2 mismatch");
      assert (dut.rd        == 5'd7)     else $error("cycle21 rd mismatch (expected x7)");
      assert (dut.funct3    == 3'b110)   else $error("cycle21 funct3 mismatch (expected OR funct3)");
      assert (dut.funct7    == 7'b0000000) else $error("cycle21 funct7 mismatch");
 
      // cycle7: EX=or(instr4), ID=xor(instr5)
      wait_cycles(7);
      assert (dut.ex_result == 32'd30)   else $error("cycle28 OR result mismatch: %0d", dut.ex_result);
      assert (dut.ex_alu_op == 4'b1000)  else $error("cycle28 OR alu_op mismatch");
      assert (dut.rd        == 5'd8)     else $error("cycle28 rd mismatch (expected x8)");
      assert (dut.funct3    == 3'b100)   else $error("cycle28 funct3 mismatch (expected XOR funct3)");
 
      // cycle8: EX=xor(instr5), ID=sll(instr6)
      wait_cycles(8);
      assert (dut.ex_result == 32'd30)   else $error("cycle36 XOR result mismatch: %0d", dut.ex_result);
      assert (dut.ex_alu_op == 4'b0010)  else $error("cycle36 XOR alu_op mismatch");
      assert (dut.rd        == 5'd9)     else $error("cycle36 rd mismatch (expected x9)");
      assert (dut.funct3    == 3'b001)   else $error("cycle36 funct3 mismatch (expected SLL funct3)");
 
      // cycle9: EX=sll(instr6), ID=sub-zero(instr7)
      wait_cycles(9);
      assert (dut.ex_result == 32'h00A00000) else $error("cycle45 SLL result mismatch: %h", dut.ex_result);
      assert (dut.ex_alu_op == 4'b0101)      else $error("cycle45 SLL alu_op mismatch");
      assert (dut.rd        == 5'd4)         else $error("cycle45 rd mismatch (expected x4)");
      assert (dut.rs1       == 5'd1)         else $error("cycle45 rs1 mismatch");
      assert (dut.rs2       == 5'd1)         else $error("cycle45 rs2 mismatch");
      assert (dut.funct7    == 7'b0100000)   else $error("cycle45 funct7 mismatch");
      assert (dut.funct3    == 3'b000)       else $error("cycle45 funct3 mismatch (expected SUB funct3)");
 
      // cycle10: EX=sub-zero(instr7). 
      wait_cycles(10);
      assert (dut.ex_result == 32'd0)    else $error("cycle55 SUB(zero) result mismatch: %0d", dut.ex_result);
      assert (dut.ex_alu_op == 4'b0001)  else $error("cycle55 SUB alu_op mismatch");
      assert (dut.ex_zero   == 1'b1)     else $error("cycle55 zero flag not asserted for x1-x1");
end
endtask
initial begin
clk=0;
rst_check();
//initialisng instruction memory with instructions
@(posedge clk);
dut.ifs.imem.mem[0] = 32'h002008133; // ADD x3,x1,x2
 
    dut.ifs.imem.mem[1] = 32'h40110233; // SUB x4,x2,x1
    dut.ifs.imem.mem[2] = 32'h00A08293; // addi X5,X1,10
   
    dut.ifs.imem.mem[3] = 32'h0020F333; // AND x6,x1,x2
  
    dut.ifs.imem.mem[4] = 32'h0020E3B3; // OR x7 x1 x2
   
    dut.ifs.imem.mem[5] = 32'h0020c433; // xOR x8 x1 x2
    
    dut.ifs.imem.mem[6] = 32'h002094B3; // SLL x9 x1 x2
   
    dut.ifs.imem.mem[7] = 32'h40108233; // sub x4 x1 x1 zero flag check 
     //register initialision
    dut.regfile.reg_file[1] = 32'd10; //x1=10
dut.regfile.reg_file[2] = 32'd20; //x2=20

  
    check_pipeline();
    wait_cycles(3);
 
    $display("------------------------------------");
    $display("Coverage = %0.2f %%", cov.get_coverage());
    $display("------------------------------------");
    #150 $finish;
  end
  
endmodule
