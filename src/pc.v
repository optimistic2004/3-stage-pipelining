`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.06.2026 14:11:24
// Design Name: 
// Module Name: pc
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

module pc(
  input wire [31:0] pc_next ,
  input clk,
  input reset,
  output reg [31:0] pc
);
  
  always@(posedge clk)
    begin
      if(reset)
        pc<=32'b0;
      else 
        pc<=pc_next;
    end
  
endmodule
