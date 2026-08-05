`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.08.2026 15:22:20
// Design Name: 
// Module Name: top_pipeline
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


module pipeline(
  input wire clk,
  input wire reset
);

  // ── IF stage wires ──────────────────────────
  wire [31:0] pc_current;
wire [31:0] pc_future;
wire [31:0] instruction;

  // ── IF/ID wires ─────────────────────────────
  wire [31:0] id_in;
  wire [31:0] id_pc;

  // ── ID decoder wires ────────────────────────
  wire [6:0]  opcode;
  wire [4:0]  rs1;
  wire [4:0]  rs2;
  wire [4:0]  rd;
  wire [2:0]  funct3;
  wire [6:0]  funct7;
  wire [31:0] immediate;
  wire [2:0]  imm_type;

  // ── register file wires ─────────────────────
  wire [31:0] rs1_data;
  wire [31:0] rs2_data;

  // ── control unit wires ──────────────────────
  wire [3:0]  alu_op;
  wire        alu_src;
  wire        reg_write;
  wire        mem_read;
  wire        mem_write;
  wire [1:0]  wb_sel;
  wire        branch;
  wire        jump;

  // ── ID/EX output wires ──────────────────────
  wire [31:0] ex_rs1_data;
  wire [31:0] ex_rs2_data;
  wire [31:0] ex_immediate;
  wire [4:0]  ex_rs1_addr;
  wire [4:0]  ex_rs2_addr;
  wire [4:0]  ex_rd;
  wire [31:0] ex_pc;
  wire [3:0]  ex_alu_op;
  wire        ex_alu_src;
  wire        ex_reg_write;
  wire        ex_mem_read;
  wire        ex_mem_write;
  wire [1:0]  ex_wb_sel;
  wire        ex_branch;
  wire        ex_jump;

  // ── ALU output wires ────────────────────────
  wire [31:0] ex_result;
  wire        ex_zero;
  wire        ex_negative;
  wire        ex_overflow;

  // ── IF stage ────────────────────────────────
 
if_stage ifs(
    .clk(clk),
    .reset(reset),
    .pc_current(pc_current),
    .pc_future(pc_future),
    .instruction(instruction)
);

  // ── IF/ID register ──────────────────────────
  if_id ifid(
    .clk    (clk),
    .reset  (reset),
    .if_in  (instruction),  // from if_stage
    .if_pc  (pc_current),       // from if_stage
    .id_in  (id_in),
    .id_pc  (id_pc)
  );

  // ── ID decoder ──────────────────────────────
  id_decoder deco(
    .instr    (id_in),      // instruction from if_id
    .opcode   (opcode),
    .rs1      (rs1),
    .rs2      (rs2),
    .rd       (rd),
    .funct3   (funct3),
    .funct7   (funct7),
    .immediate(immediate),
    .imm_type (imm_type)
  );

  
  register_file regfile(
    .clk      (clk),
    .reset    (reset),
    .rs1_addr (rs1),        
    .rs2_addr (rs2),       
    .rs1_data (rs1_data),
    .rs2_data (rs2_data),
    .wr_addr  (ex_rd),      
    .wr_data  (ex_result),  
    .wr_enable(ex_reg_write)
  );

  // ── control unit ────────────────────────────
  control_unit ctrl(
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

  // ── ID/EX register ──────────────────────────
  id_ex idex(
    .clk          (clk),
    .reset        (reset),
    .in_rs1_data  (rs1_data),
    .in_rs2_data  (rs2_data),
    .in_immediate (immediate),
    .in_rs1_addr  (rs1),
    .in_rs2_addr  (rs2),
    .in_rd        (rd),
    .in_pc        (id_pc),
    .in_alu_op    (alu_op),
    .in_alu_src   (alu_src),
    .in_reg_write (reg_write),
    .in_mem_read  (mem_read),
    .in_mem_write (mem_write),
    .in_wb_sel    (wb_sel),
    .in_branch    (branch),
    .in_jump      (jump),
    .out_rs1_data (ex_rs1_data),
    .out_rs2_data (ex_rs2_data),
    .out_immediate(ex_immediate),
    .out_rs1_addr (ex_rs1_addr),
    .out_rs2_addr (ex_rs2_addr),
    .out_rd       (ex_rd),
    .out_pc       (ex_pc),
    .out_alu_op   (ex_alu_op),
    .out_alu_src  (ex_alu_src),
    .out_reg_write(ex_reg_write),
    .out_mem_read (ex_mem_read),
    .out_mem_write(ex_mem_write),
    .out_wb_sel   (ex_wb_sel),
    .out_branch   (ex_branch),
    .out_jump     (ex_jump)
  );

  // ── ALU ─────────────────────────────────────
  alu alu_ex(
    .rs1_data (ex_rs1_data),
    .rs2_data (ex_rs2_data),
    .immediate(ex_immediate),
    .alu_src  (ex_alu_src),
    .alu_op   (ex_alu_op),
    .result   (ex_result),
    .zero     (ex_zero),
    .negative (ex_negative),
    .overflow (ex_overflow)
  );

endmodule