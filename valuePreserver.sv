`timescale 1ps/1ps
/**
 * Module built to preserve value of a bit
 * in a register even if enable is turned off. 
 * Benchmarked in generateRegisters
 */
module valuePreserver(clk, in, out, en, reset);
	input logic clk, en, reset;
	input logic in;
	output logic out;

	logic dff_out, mux_out;

	mux2to1_single_bit call1(.select(en), .in({in, dff_out}), .out(mux_out));
	D_FF inst(.q(dff_out), .d(mux_out), .reset, .clk);

	assign out = dff_out;

endmodule



