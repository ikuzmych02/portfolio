# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./extenders.sv"
vlog "./full_adder.sv"
vlog "./adder.sv"
vlog "./alu.sv"
vlog "./regfile.sv"
vlog "./valuePreserver.sv"
vlog "./mux.sv"
vlog "./isZero.sv"
vlog "./generateRegisters.sv"
vlog "./instructmem.sv"
vlog "./datamem.sv"
vlog "./math.sv"
vlog "./alu_one_bit.sv"
vlog "./decoder5to32.sv"
vlog "./decoder3to8.sv"
vlog "./decoder2to4.sv"
vlog "./D_FF.sv"
vlog "./control.sv"
vlog "./instructionData.sv"
vlog "./programCounter.sv"
vlog "./lab4.sv"
vlog "./if_id.sv"
vlog "./id.sv"
vlog "./ex.sv"
vlog "./memstage.sv"
vlog "./wb.sv"
vlog "./forwarding_unit.sv"
vlog "./pipelinedCpu.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work pipelined_testbench

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do pipelined_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
