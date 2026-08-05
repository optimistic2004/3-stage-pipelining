`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.07.2026 22:13:56
// Design Name: 
// Module Name: regs_test
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


module regs_test;
 logic clk;
  logic reset;
  logic [4:0] rs1_addr;
  logic [4:0] rs2_addr;
  logic [31:0] rs2_data;
  logic [31:0] rs1_data;
  logic [4:0] wr_addr;
  logic [31:0] wr_data;
  logic wr_enable;
  
  register_file uut (
    .clk(clk),
    .reset(reset),
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data),
    .wr_addr(wr_addr),
    .wr_data(wr_data),
    .wr_enable(wr_enable)
  );
  
  always #3 clk = ~clk;
  
  initial begin
    // Initialize
    clk = 0;
    reset = 1;
    wr_enable = 0;
    rs1_addr = 0;
    rs2_addr = 0;
  end
  task automatic write_reg;
input [4:0] addr;
input [31:0] data;
begin
wr_addr = addr;
wr_data = data;
wr_enable = 1;
@(posedge clk);
wr_enable = 0;
end
endtask



initial begin
@(posedge clk) reset=0;
write_reg(5'd10,32'd5);
write_reg(5'd5 ,32'd8);

rs1_addr = 10;
rs2_addr = 5;

#1;

assert(rs1_data == 32'd5);
assert(rs2_data == 32'd8);

write_reg(5'd2,32'd10);
write_reg(5'd20,32'd19);
rs1_addr=2;
rs2_addr=20;
#1
assert(rs1_data==32'd10);
assert(rs2_data==32'd19);

write_reg(5'd20,32'd85);
rs2_addr=20;
#1
assert(rs2_data==32'd85);

write_reg(5'b0,32'd1);
rs1_addr=0;
assert(rs1_data==32'd1) $fatal("zero register cannot be modified");



$finish;
end

endmodule
