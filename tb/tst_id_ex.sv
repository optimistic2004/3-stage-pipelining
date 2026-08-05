`timescale 1ns/1ps

module tst_id_ex;

  // Clock & Reset
  logic clk;
  logic reset;

  // ---------------- Inputs ----------------
  logic [31:0] in_rs1_data;
  logic [31:0] in_rs2_data;
  logic [31:0] in_immediate;
  logic [4:0]  in_rs1_addr;
  logic [4:0]  in_rs2_addr;
  logic [4:0]  in_rd;
  logic [31:0] in_pc;

  logic [3:0]  in_alu_op;
  logic        in_alu_src;
  logic        in_reg_write;
  logic        in_mem_read;
  logic        in_mem_write;
  logic [1:0]  in_wb_sel;
  logic        in_branch;
  logic        in_jump;

  // ---------------- Outputs ----------------
  logic [31:0] out_rs1_data;
  logic [31:0] out_rs2_data;
  logic [31:0] out_immediate;
  logic [4:0]  out_rs1_addr;
  logic [4:0]  out_rs2_addr;
  logic [4:0]  out_rd;
  logic [31:0] out_pc;

  logic [3:0]  out_alu_op;
  logic        out_alu_src;
  logic        out_reg_write;
  logic        out_mem_read;
  logic        out_mem_write;
  logic [1:0]  out_wb_sel;
  logic        out_branch;
  logic        out_jump;

  // ---------------- DUT ----------------
  id_ex dut(
      .clk(clk),
      .reset(reset),

      .in_rs1_data(in_rs1_data),
      .in_rs2_data(in_rs2_data),
      .in_immediate(in_immediate),
      .in_rs1_addr(in_rs1_addr),
      .in_rs2_addr(in_rs2_addr),
      .in_rd(in_rd),
      .in_pc(in_pc),

      .in_alu_op(in_alu_op),
      .in_alu_src(in_alu_src),
      .in_reg_write(in_reg_write),
      .in_mem_read(in_mem_read),
      .in_mem_write(in_mem_write),
      .in_wb_sel(in_wb_sel),
      .in_branch(in_branch),
      .in_jump(in_jump),

      .out_rs1_data(out_rs1_data),
      .out_rs2_data(out_rs2_data),
      .out_immediate(out_immediate),
      .out_rs1_addr(out_rs1_addr),
      .out_rs2_addr(out_rs2_addr),
      .out_rd(out_rd),
      .out_pc(out_pc),

      .out_alu_op(out_alu_op),
      .out_alu_src(out_alu_src),
      .out_reg_write(out_reg_write),
      .out_mem_read(out_mem_read),
      .out_mem_write(out_mem_write),
      .out_wb_sel(out_wb_sel),
      .out_branch(out_branch),
      .out_jump(out_jump)
  );

  //clk
  always #2 clk = ~clk;

  //compare task
  task automatic compare(input integer iter);
  begin

    assert(out_rs1_data == in_rs1_data)
      else $fatal("Iteration %0d : rs1_data mismatch",iter);

    assert(out_rs2_data == in_rs2_data)
      else $fatal("Iteration %0d : rs2_data mismatch",iter);

    assert(out_immediate == in_immediate)
      else $fatal("Iteration %0d : immediate mismatch",iter);

    assert(out_rs1_addr == in_rs1_addr)
      else $fatal("Iteration %0d : rs1_addr mismatch",iter);

    assert(out_rs2_addr == in_rs2_addr)
      else $fatal("Iteration %0d : rs2_addr mismatch",iter);

    assert(out_rd == in_rd)
      else $fatal("Iteration %0d : rd mismatch",iter);

    assert(out_pc == in_pc)
      else $fatal("Iteration %0d : pc mismatch",iter);

    assert(out_alu_op == in_alu_op)
      else $fatal("Iteration %0d : alu_op mismatch",iter);

    assert(out_alu_src == in_alu_src)
      else $fatal("Iteration %0d : alu_src mismatch",iter);

    assert(out_reg_write == in_reg_write)
      else $fatal("Iteration %0d : reg_write mismatch",iter);

    assert(out_mem_read == in_mem_read)
      else $fatal("Iteration %0d : mem_read mismatch",iter);

    assert(out_mem_write == in_mem_write)
      else $fatal("Iteration %0d : mem_write mismatch",iter);

    assert(out_wb_sel == in_wb_sel)
      else $fatal("Iteration %0d : wb_sel mismatch",iter);

    assert(out_branch == in_branch)
      else $fatal("Iteration %0d : branch mismatch",iter);

    assert(out_jump == in_jump)
      else $fatal("Iteration %0d : jump mismatch",iter);

    $display("PASS : Iteration %0d",iter);

  end
  endtask

  //reset task
  task automatic reset_test;
  begin

    assert(out_rs1_data==0);
    assert(out_rs2_data==0);
    assert(out_immediate==0);

    assert(out_rs1_addr==0);
    assert(out_rs2_addr==0);
    assert(out_rd==0);

    assert(out_pc==0);

    assert(out_alu_op==0);
    assert(out_alu_src==0);
    assert(out_reg_write==0);

    assert(out_mem_read==0);
    assert(out_mem_write==0);

    assert(out_wb_sel==0);

    assert(out_branch==0);
    assert(out_jump==0);

    $display("PASS : Reset Test");

  end
  endtask

  //input task
  task automatic check;

    integer i;

    begin

      for(i=0;i<64;i=i+1)
      begin

        in_rs1_data = i;
        in_rs2_data = i+1;
        in_immediate = i-1;

        in_rs1_addr = i+2;
        in_rs2_addr = i-2;

        in_rd = i+3;

        in_pc = i-3;

        in_alu_op = i[3:0];

        in_alu_src = i[0];
        in_reg_write = i[1];
        in_mem_read = i[2];
        in_mem_write = i[3];
        in_branch = i[4];
        in_jump = i[5];

        in_wb_sel = i[1:0];

        @(posedge clk);

        compare(i);

      end

    end

  endtask


  initial
  begin

    clk = 0;

  
    reset = 1;

    @(posedge clk);

    reset_test();

    reset = 0;

    check();

    
    $display("ALL ID/EX TEST CASES PASSED");
    
    #20;

    $finish;

  end

endmodule