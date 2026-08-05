`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.07.2026 21:16:29
// Design Name: 
// Module Name: tb_if_id
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


module tb_if_id;
logic [31:0] if_in;
logic [31:0] if_pc;
logic reset ;
logic [31:0] id_in;
logic [31:0] id_pc;
logic clk;
  if_id uut(
    .clk(clk),
    .reset(reset),
    .if_in(if_in),
    .if_pc(if_pc),
    .id_in(id_in),
    .id_pc(id_pc));
  
   
  always #3 clk=~clk;
  
  
  initial begin
    clk=1'b0;
    reset=1'b1;
    #5 reset=1'b0;
    end
   
   
   initial begin
  @(posedge clk);
 if_pc = 32'd0;
if_in = 32'hA0010000;
@(posedge clk);

if_pc = 32'd4;
if_in = 32'hA0020000;
@(posedge clk);

if_pc = 32'd8;
if_in = 32'hA0030000;
@(posedge clk);

if_pc=32'd12;
if_in=32'hA0040000;
    #25 $finish;
  end
  always @(posedge clk) begin
    $display ("time=%t,id_in= %h,id_pc=%h,if_in=%h,if_pc=%h",$time,id_in,id_pc,if_in,if_pc);
  end
endmodule
  
  
  
  
  