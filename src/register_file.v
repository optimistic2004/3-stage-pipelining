`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.07.2026 21:58:59
// Design Name: 
// Module Name: register_file
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
module register_file(
  input wire clk,
  input wire reset,
  input wire [4:0] rs1_addr,
  input wire [4:0] rs2_addr,
  output wire [31:0] rs1_data,
  output wire [31:0] rs2_data,
  input wire [4:0] wr_addr,
  input wire [31:0] wr_data,
  input wire wr_enable
);
  
  reg [31:0] reg_file [0:31];  
  integer i; 
 
  // Write operation (synchronous)
  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      for (i = 0; i < 32; i = i + 1)
        reg_file[i] <= 32'b0;
    end else begin
      if (wr_enable && wr_addr != 5'b0)
        reg_file[wr_addr] <= wr_data;
    end
  end
  
  // Read operation (combinational)

    assign rs1_data = (rs1_addr == 5'b0) ? 32'b0 : reg_file[rs1_addr];
    assign rs2_data = (rs2_addr == 5'b0) ? 32'b0 : reg_file[rs2_addr];  


endmodule