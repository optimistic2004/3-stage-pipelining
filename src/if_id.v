`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.07.2026 21:12:17
// Design Name: 
// Module Name: if_id
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
module if_id(
  input [31:0] if_in,
  input [31:0] if_pc,
  input clk,
  input reset,
  output reg [31:0] id_in,
  output reg [31:0] id_pc);
   
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      id_in<=32'b0;
      id_pc<= 32'b0;
    end else begin
      id_in<=if_in;
      id_pc<=if_pc;
    end
  end
endmodule
      
