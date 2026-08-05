`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.07.2026 21:45:30
// Design Name: 
// Module Name: control_unit
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


module control_unit(
  input wire [6:0] opcode,
  input wire [2:0] funct3,
  input wire [6:0] funct7,
  output reg [3:0] alu_op,
  output reg        alu_src,   // 0=rs2_data,1=immediate
  output reg        reg_write, // 1=write result to rd
  output reg        mem_read,  // 1=load instruction
  output reg        mem_write, // 1=store instruction
  output reg  [1:0] wb_sel,    // 00=ALU, 01=mem, 10=PC+4
  output reg        branch,    // 1=branch instruction
  output reg        jump  

);
  
  always@(*) begin
    alu_op=4'b0000;
    alu_src=0;
    reg_write = 0;
    mem_read  = 0;
    mem_write = 0;
    wb_sel    = 2'b00;
    branch    = 0;
    jump      = 0;
 
  
  
  //r-type
 // always@(*) begin
    case(opcode)
       7'b0110011: begin
         alu_src   = 0;
        reg_write = 1;
         case(funct3)
           3'b000: begin
             if (funct7==7'b0) begin
               alu_op=4'b0000;
             end
             else if (funct7==7'b0100000) begin
               alu_op=4'b0001;
             end
             else alu_op=4'b0000;
           end
           3'b001:alu_op=4'b0101;
           3'b010:alu_op=4'b0110;
           3'b011:alu_op=4'b0111;
           3'b100:alu_op=4'b0010;
           3'b101:begin
             if(funct7==7'b0) begin
               alu_op=4'b0011;
             end
             else if(funct7==7'b0100000) begin
               alu_op=4'b0100;
             end
           else alu_op=4'b0011;
           end
            3'b110:alu_op=4'b1000;
            3'b111:alu_op=4'b1001;
           default:alu_op=4'b0000;
         endcase
       end
      
        // I-type ALU (ADDI, XORI etc)
      7'b0010011: begin
        alu_src   = 1;
        reg_write = 1;
        case (funct3)
          3'b000: alu_op = 4'b0000; // ADDI
          3'b001: alu_op = 4'b0101; // SLLI
          3'b010: alu_op = 4'b0110; // SLTI
          3'b011: alu_op = 4'b0111; // SLTIU
          3'b100: alu_op = 4'b0010; // XORI
          3'b101: begin
            if      (funct7 == 7'b0000000) alu_op = 4'b0011; // SRLI
            else if (funct7 == 7'b0100000) alu_op = 4'b0100; // SRAI
            else                           alu_op = 4'b0011;
          end
          3'b110: alu_op = 4'b1000; // ORI
          3'b111: alu_op = 4'b1001; // ANDI
          default: alu_op = 4'b0000;
        endcase
      end

      // Load (LW, LH, LB)
      7'b0000011: begin
        alu_src   = 1;
        alu_op    = 4'b0000; // ADD for address calc
        reg_write = 1;
        mem_read  = 1;
        wb_sel    = 2'b01;   // write back memory data
      end

      // Store (SW, SH, SB)
      7'b0100011: begin
        alu_src   = 1;
        alu_op    = 4'b0000; // ADD for address calc
        mem_write = 1;
        wb_sel=2'b00;
      end

      // Branch (BEQ, BNE, BLT etc)
      7'b1100011: begin
        alu_src = 0;
        alu_op  = 4'b0001;  // SUB to compare
        branch  = 1;
      end

      // LUI
      7'b0110111: begin
        alu_src   = 1;
        alu_op    = 4'b1010; // pass immediate through
        reg_write = 1;
      end

      // AUIPC
      7'b0010111: begin
        alu_src   = 1;
        alu_op    = 4'b0000; // PC + imm
        reg_write = 1;
      end

      // JAL
      7'b1101111: begin
        alu_src   = 1;
        alu_op    = 4'b0000; // PC + imm
        reg_write = 1;
        jump      = 1;
        wb_sel    = 2'b10;   // write back PC+4
      end

      // JALR
      7'b1100111: begin
        alu_src   = 1;
        alu_op    = 4'b0000; // rs1 + imm
        reg_write = 1;
        jump      = 1;
        wb_sel    = 2'b10;   // write back PC+4
      end

      default: begin
        // all signals stay at safe defaults set at top
      end

    endcase
  end
 //end

endmodule               
             
            
             
        
               
