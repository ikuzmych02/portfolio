# ARM Pipelined CPU

In this branch, I have my entire codebase written in SystemVerilog
to implement an ARM 5-Stage Pipelined processor.
I have also included .arm files which I used to confirm my implementation was functional, as well
as my runlab.do and pipelined_wave.do simulation files which can be run with ModelSim

All of the stages are broken up into source files like this:

## if_id.sv
This SV file contains the code necessary to create the Instruction Fetch stage of my ARM pipelined CPU

## id.sv
This SV file contains the code necessary to create the Instruction Decode stage of my ARM pipelined CPU.
This stage contains all of the logic for branching, the register file, and takes in the control signals
from the instruction that is being sent in by the register from Instruction Fetch stage. It also writes
the Write-Back, Memory, and execute control signals to registers

## ex.sv
This SV file contains the code necessary to create the Execute stage of my ARM pipelined CPU.
This stage contains the ALU, as well as the multiplexers in front of the A and B inputs to the ALU,
with the control signals for the MUXes being sent in by the forwarding unit, and the ALU operation code
being read from the register which contains it from the Instruction Decode stage. It also writes
the Write-Back and Memory control signals from the Instruction Decode stage to registers.

## memstage.sv
This SV file contains the code necessary to create the Memory stage of my ARM pipelined CPU.
The MemWrite, MemRead control signals are read from the registers being sent out from the Execute stage.
The output of the ALU is wired to the address input of data memory block, and ReadData2 from the register file
is wired to the data input of the data memory block.
This stage contains the Data Memory block, and sents the output of the ALU register from the Execute
stage into the forwarding unit. It also writes the Write-back signals from the Execute stage to registers.

## wb.sv
This is the final stage in my ARM pipelined CPU. It is responsible for the WriteBack operations,
including sending the WriteData to the forwarding unit. The WriteRegister is directly
wired to the register file in id.sv


