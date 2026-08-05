3-Stage RISC-V Pipelined Processor

A 3-stage pipelined RISC-V processor core, with the design implemented in Verilog and testbenches written in SystemVerilog.

Pipeline Stages
IF – Instruction Fetch
ID – Instruction Decode
EX – Execute
Design (Verilog)
Program Counter (PC)
Instruction Memory
Register File
Immediate Generator
ALU
Control Unit
Data Memory
Pipeline Registers (IF/ID, ID/EX)
Verification (SystemVerilog)

Each core module is verified with a dedicated testbench (see tb/), covering:

PC increment and branch behavior
Register file read/write
Immediate generation for supported instruction formats
ALU operation correctness
Control unit decode logic
Full pipeline datapath execution (tst_pipeline.sv)

Simulation waveforms for each verified module are included in waveforms/.

Tools
Simulator: Xilinx Vivado
How to Run
Open the project in Vivado (or add src/ and tb/ as design/simulation sources in a new project).
Set the relevant testbench in tb/ (e.g., tst_pipeline.sv) as the simulation top module.
Run behavioral simulation to view waveforms.
