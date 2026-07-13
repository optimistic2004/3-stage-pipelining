`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.07.2026 15:34:33
// Design Name: 
// Module Name: if_stage
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
module if_stage(
    input  wire        clk,
    input  wire        reset,

    output wire [31:0] pc_current,
    output wire [31:0] pc_future,
    output wire [31:0] instruction
);

    // Current PC from the PC register
    pc pc_reg(
        .clk(clk),
        .reset(reset),
        .pc_next(pc_future),
        .pc(pc_current)
    );

    // Next PC
    assign pc_future = pc_current + 32'd4;

    // Fetch instruction
    instr_mem imem(
        .address(pc_current),
        .instruction(instruction)
    );

endmodule



  
  

