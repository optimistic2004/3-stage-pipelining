`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.08.2026 20:07:32
// Design Name: 
// Module Name: alu_ex
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
module alu(
   input  wire [31:0] rs1_data,   
   input  wire [31:0] rs2_data,
   input  wire [31:0] immediate,
   input  wire        alu_src,
  input  wire [3:0] alu_op,
  /// output
  output reg [31:0] result,
  output wire zero,
  output wire negative,
  output wire overflow);
  
  wire [31:0] second_operand;
  
  assign second_operand=(alu_src)?immediate:rs2_data;
  
  always@(*) begin 
    case(alu_op)
      4'b0000:result=rs1_data+second_operand;//add
      4'b0001:result=rs1_data-second_operand;//sub
      4'b0010:result=rs1_data^second_operand;//xor
      4'b0011:result=rs1_data>>second_operand[4:0];//srl
      4'b0100:result=$signed(rs1_data)>>>second_operand[4:0];//srl
      4'b0101:result=rs1_data<<second_operand[4:0];//sll
      4'b0110:result=($signed(rs1_data)<$signed(second_operand))?32'd1:32'd0;//slt
      4'b0111:result=(rs1_data <second_operand)?32'd1:32'd0;//sltu
      4'b1000: result = rs1_data | second_operand;                // OR
      4'b1001: result = rs1_data & second_operand;                // AND
      4'b1010: result = second_operand;                           // LUI passthrough
      default: result = 32'b0;
    endcase
  end
  
  assign zero=(result==32'b0);
  assign negative =result[31];
  assign overflow =
  // ── ADD overflow ──────────────────────────
  ((alu_op == 4'b0000) &&
   ((~rs1_data[31] & ~second_operand[31] &  result[31]) |
    ( rs1_data[31] &  second_operand[31] & ~result[31])))
  |
  // ── SUB overflow ──────────────────────────
  ((alu_op == 4'b0001) &&
   ((~rs1_data[31] &  second_operand[31] &  result[31]) |
    ( rs1_data[31] & ~second_operand[31] & ~result[31])));
endmodule

      
      
      
      
  