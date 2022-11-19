`timescale 1ps/1ps

/**
 * module to generate a single register w/ input 
 * data
 */

module generateRegisters(clk, in, out, en);

	input logic clk, en;
	input logic [63:0] in;

	output logic [63:0] out;

	logic [63:0] validData;
	

	genvar i;
	generate
		for (i = 0; i < 64; i++) begin: reg_bits
			// and #50ps checkForValidData(validData[i], in[i], en);
			valuePreserver reg_bit(.clk, .in(in[i]), .out(out[i]), .en, .reset(1'b0));
		end
	endgenerate

endmodule

module resettableGenerator(clk, reset, in, out, en);

	input logic clk, en, reset;
	input logic [63:0] in;

	output logic [63:0] out;

	logic [63:0] validData;
	

	genvar i;
	generate
		for (i = 0; i < 64; i++) begin: reg_bits
			// and #50ps checkForValidData(validData[i], in[i], en);
			valuePreserver reg_bit(.clk, .in(in[i]), .out(out[i]), .en, .reset);
		end
	endgenerate

endmodule


module generateRegisters_testbench();

	logic clk, en;
	logic [63:0] in, out;

	generateRegisters dut(.*);
	
	initial begin
		clk = 1;
		forever #300 clk = ~clk;
	end // initial


	initial begin
		in <= 64'd9854768; en <= 1; @(posedge clk);
		repeat(3) @(posedge clk);
		in <= 64'd550; repeat(3) @(posedge clk);
		in <= 64'd420; repeat(3) @(posedge clk);
		in <= 64'd69; repeat(3) @(posedge clk);
		in <= 64'd215687; repeat(3) @(posedge clk);
		en <= 0;
		in <= 64'd550; repeat(3) @(posedge clk);
		in <= 64'd420; repeat(3) @(posedge clk);
		in <= 64'd69; repeat(3) @(posedge clk);
		in <= 64'd215687; repeat(3) @(posedge clk);
		
	$stop;
	end
	

endmodule


