`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.08.2026 14:57:27
// Design Name: 
// Module Name: id_ex
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
module id_ex (
  input  wire        clk,
  input  wire        reset,

  // ── data inputs from ID stage ──────────────
  input  wire [31:0] in_rs1_data,   
  input  wire [31:0] in_rs2_data,
  input  wire [31:0] in_immediate,  
  input  wire [4:0]  in_rs1_addr,   
  input  wire [4:0]  in_rs2_addr,
  input  wire [4:0]  in_rd,         
  input  wire [31:0] in_pc,        
  // ── control inputs from control unit ───────
  input  wire [3:0]  in_alu_op,
  input  wire        in_alu_src,
  input  wire        in_reg_write,
  input  wire        in_mem_read,
  input  wire        in_mem_write,
  input  wire [1:0]  in_wb_sel,
  input  wire        in_branch,
  input  wire        in_jump,

  // ── data outputs to EX stage ───────────────
  output reg  [31:0] out_rs1_data,
  output reg  [31:0] out_rs2_data,
  output reg  [31:0] out_immediate,
  output reg  [4:0]  out_rs1_addr,
  output reg  [4:0]  out_rs2_addr,
  output reg  [4:0]  out_rd,
  output reg  [31:0] out_pc,

  // ── control outputs to EX stage ────────────
  output reg  [3:0]  out_alu_op,
  output reg         out_alu_src,
  output reg         out_reg_write,
  output reg         out_mem_read,
  output reg         out_mem_write,
  output reg  [1:0]  out_wb_sel,
  output reg         out_branch,
  output reg         out_jump
);

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      // clear everything on reset
      out_rs1_data  <= 32'b0;
      out_rs2_data  <= 32'b0;
      out_immediate <= 32'b0;
      out_rs1_addr  <= 5'b0;
      out_rs2_addr  <= 5'b0;
      out_rd        <= 5'b0;
      out_pc        <= 32'b0;
      out_alu_op    <= 4'b0;
      out_alu_src   <= 0;
      out_reg_write <= 0;
      out_mem_read  <= 0;
      out_mem_write <= 0;
      out_wb_sel    <= 2'b0;
      out_branch    <= 0;
      out_jump      <= 0;
    end else begin
      // latch everything on clock edge
      out_rs1_data  <= in_rs1_data;
      out_rs2_data  <= in_rs2_data;
      out_immediate <= in_immediate;
      out_rs1_addr  <= in_rs1_addr;
      out_rs2_addr  <= in_rs2_addr;
      out_rd        <= in_rd;
      out_pc        <= in_pc;
      out_alu_op    <= in_alu_op;
      out_alu_src   <= in_alu_src;
      out_reg_write <= in_reg_write;
      out_mem_read  <= in_mem_read;
      out_mem_write <= in_mem_write;
      out_wb_sel    <= in_wb_sel;
      out_branch    <= in_branch;
      out_jump      <= in_jump;
    end
  end

endmodule