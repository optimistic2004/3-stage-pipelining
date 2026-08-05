`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.07.2026 15:38:37
// Design Name: 
// Module Name: tb_if
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
module tb_if;
logic     clk;
logic       reset;
logic [31:0]  pc_current;
 logic [31:0]pc_future;
    logic [31:0] instruction;
  
  always #5 clk=~clk;
  
  if_stage uut(
    .clk(clk),
    .reset(reset),
    .pc_current(pc_current),           
    .pc_future(pc_future),
    .instruction(instruction)
  );
  
  initial begin 
    clk=0;
    reset=1;
   #15 reset =0;
   $monitor("values of present=%h, future=%h, instr=%h",pc_current,pc_future,instruction);
    #85 $finish;
  end
     
  endmodule
  
    
