`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.07.2026 23:41:00
// Design Name: 
// Module Name: instr_mem
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


module instr_mem(

    input  wire [31:0] address,
    output wire [31:0] instruction
);

    // 256 instructions (32-bit each)
    reg [31:0] mem [0:255];

    initial begin
        // Option 1: Load from file
        $readmemh("instr.mem", mem);
//        $display("mem[0] = %h", mem[0]);
//    $display("mem[1] = %h", mem[1]);
//    $display("mem[2] = %h", mem[2]);

       
    // Combinational read
    end
    assign instruction = mem[address[9:2]];

endmodule