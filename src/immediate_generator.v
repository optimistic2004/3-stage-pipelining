`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.07.2026 16:03:52
// Design Name: 
// Module Name: immediate_generator
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
module immediate_generator (
  input  wire [31:0] instruction,
  input  wire [2:0]  imm_type,   
  output reg  [31:0] immediate
);
  always @(*) begin
    case (imm_type)
      3'b000: // I-type
        immediate = {{20{instruction[31]}}, instruction[31:20]};
      3'b001: // S-type
        immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
      3'b010: // B-type
        immediate = {{19{instruction[31]}}, instruction[7], instruction[30:25],
                     instruction[11:8], 1'b0};
      3'b011: // U-type
        immediate = {instruction[31:12], 12'b0};
      3'b100: // J-type (JAL)
        immediate = {{11{instruction[31]}}, instruction[19:12], instruction[20],
                     instruction[30:21], 1'b0};
      3'b101: // R-type - no immediate, output zero
        immediate = 32'b0;
      default:
        immediate = 32'b0;
    endcase
  end
endmodule