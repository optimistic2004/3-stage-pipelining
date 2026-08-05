`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.07.2026 16:00:09
// Design Name: 
// Module Name: id_decoder
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
module id_decoder(
  input  wire [31:0] instr,

  output wire [6:0]  opcode,    
  output wire [4:0]  rs1,
  output wire [4:0]  rs2,
  output wire [4:0]  rd,
  output wire [2:0]  funct3,
  output wire [6:0]  funct7,
  output wire [31:0] immediate,
  output reg  [2:0]  imm_type   
);

  // Fixed-position field extraction - all pure wires
  assign opcode = instr[6:0];
  assign rs1    = instr[19:15];
  assign rs2    = instr[24:20];
  assign rd     = instr[11:7];
  assign funct3 = instr[14:12];
  assign funct7 = instr[31:25];

  // Immediate generator instantiation
  wire [31:0] imm_out;
  immediate_generator imm_gen (
    .instruction(instr),
    .imm_type(imm_type),
    .immediate(imm_out)
  );
  assign immediate = imm_out;

  // imm_type driven by always block - reg is correct here
  always @(*) begin
    case (opcode)
      7'b0110011: imm_type = 3'b101; // R-type  - distinct, imm ignored in EX
      7'b0010011: imm_type = 3'b000; // I-type  (ALU immediate e.g. ADDI)
      7'b0000011: imm_type = 3'b000; // I-type  (load e.g. LW)
      7'b1100111: imm_type = 3'b000; // I-type  (JALR)
      7'b0100011: imm_type = 3'b001; // S-type  (store e.g. SW)
      7'b1100011: imm_type = 3'b010; // B-type  (branch e.g. BEQ)
      7'b0110111: imm_type = 3'b011; // U-type  (LUI)
      7'b0010111: imm_type = 3'b011; // U-type  (AUIPC)
      7'b1101111: imm_type = 3'b100; // J-type  (JAL)
      default:    imm_type = 3'b000;
    endcase
  end

endmodule


