`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.06.2026 14:20:39
// Design Name: 
// Module Name: pc_test
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
module pc_test;
  reg [31:0] pc_next;
  reg clk;
  reg reset;
  wire [31:0] pc;
 

  pc uut (
    .clk(clk),
    .reset(reset),
    .pc_next(pc_next),
    .pc(pc));
  
  initial begin
    reset=1'b1;
    clk=1'b0;
    pc_next=32'b0;
  end
  
  always #3 clk=~clk;
  
  initial begin 
  #4 reset=0;
   @(posedge clk)
    pc_next= 32'd4;
    assert (pc==32'd4) $fatal("assertion failed");
    $display("time=%t,clk=%b,reset=%b,pc_next=%b,pc=%b",$time,clk,reset,pc_next,pc);
     @(posedge clk)
    pc_next= 32'd8;
     assert (pc==32'd8) $fatal("assertion failed");
      $display("time=%t,clk=%b,reset=%b,pc_next=%b,pc=%b",$time,clk,reset,pc_next,pc);
       @(posedge clk)
    pc_next= 32'd12;
     assert (pc==32'd12) $fatal("assertion failed");
      $display("time=%t,clk=%b,reset=%b,pc_next=%b,pc=%b",$time,clk,reset,pc_next,pc);
       @(posedge clk)
    pc_next= 32'd16;
     assert (pc==32'd16) $fatal("assertion failed");
      $display("time=%t,clk=%b,reset=%b,pc_next=%b,pc=%b",$time,clk,reset,pc_next,pc);
        @(posedge clk)
    pc_next= 32'd20;  
     assert (pc==32'd20) $fatal("assertion failed");
      $display("time=%t,clk=%b,reset=%b,pc_next=%b,pc=%b",$time,clk,reset,pc_next,pc);
     @(posedge clk) 
    pc_next= 32'd24;
     assert (pc==32'd24) $fatal("assertion failed");
      $display("time=%t,clk=%b,reset=%b,pc_next=%b,pc=%b",$time,clk,reset,pc_next,pc);
      @(posedge clk) ;
    pc_next= 32'd28;  
     assert (pc==32'd28) $fatal("assertion failed");
      $display("time=%t,clk=%b,reset=%b,pc_next=%b,pc=%b",$time,clk,reset,pc_next,pc);
    @(posedge clk) ;
     $finish;
     
    
  end
  
  
endmodule
