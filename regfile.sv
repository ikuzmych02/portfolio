`timescale 1ps/1ps

/**
 * top-level module built based on
 * register top-level diagram. Includes everything we need to successfully
 * write, read, and process registers.
 * Testing done w/ regstim.sv
 */
module regfile(ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, WriteRegister, RegWrite, clk);
	input logic clk, RegWrite;
	input logic [63:0] WriteData;
	input logic [4:0] ReadRegister1, ReadRegister2, WriteRegister;

	output logic [63:0] ReadData1, ReadData2;

	parameter DATA_WIDTH = 64;
	parameter TOT_ADDRESSES = 32; 

	logic [DATA_WIDTH - 1:0] register [0:TOT_ADDRESSES - 1];
	
	logic [31:0] selectReg;
	
	decoder5to32 decoder(.en(RegWrite), .s(WriteRegister), .data(selectReg));
	
	// X31 = all zero
	assign register[31] = 64'd0;
	
	genvar i;
	generate
		for (i = 0; i < 31; i++) begin: registers
			generateRegisters makeRegs(.en(selectReg[i]), .clk, .in(WriteData), .out(register[i]));
		end

	endgenerate
	
	mux32to1 readReg1(.ReadReg(ReadRegister1), .in(register), .out(ReadData1));
	mux32to1 readReg2(.ReadReg(ReadRegister2), .in(register), .out(ReadData2));

endmodule

