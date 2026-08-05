`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.07.2026 20:28:22
// Design Name: 
// Module Name: tst_instr
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


module tst_instr;
logic [31:0] address;
logic [31:0] instruction;

instr_mem dut (.address(address),
               .instruction(instruction));
                
 
       
       task check;
      
       integer i;
       
       begin
      
       for (i=0;i<64;i=i+4) begin
      address = i;
      
       #1 ;
       $display("time=%0t,Address=%h,instruction=%h",$time,address,instruction);
      
       end
       end
       endtask
        


       initial begin
       address=0;
       #1;
       check();
      $finish;  
       end
endmodule
