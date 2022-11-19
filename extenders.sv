// Test bench for ALU
`timescale 1ps/1ps
/**
 *
 * Sign extender module
 *
 */
module signextend #(parameter WIDTH)
						 (in, out);
	input logic [WIDTH - 1:0] in;
	output logic [63:0] out;
	
	parameter AMT_FILL = 64 - WIDTH;
	assign out = {{AMT_FILL{in[WIDTH - 1]}}, in};
	


endmodule // signextend

module signextend_testbench();
	logic [25:0] in;
	logic [63:0] out;
	
	signextend #(.WIDTH(26)) dut (.*);
	
	
	initial begin
		in = 26'b00000000000010110100001010; #100;
		in = 26'b11000000000010110100001010; #100;

	end // initial

endmodule // signextend_testbench

/**
 *
 * Zero extender module
 *
 */
module zeroextend #(parameter WIDTH) 
						(in, out);
	input logic [WIDTH - 1:0] in;
	output logic [63:0] out;
	
	parameter AMT_FILL = 64 - WIDTH;
	assign out = {{AMT_FILL{0}}, in};


endmodule // zeroextend

module zeroextend_testbench();
	logic [25:0] in;
	logic [63:0] out;
	
	zeroextend #(.WIDTH(26)) dut (.*);
	
	
	initial begin
		in = 26'b00000000000010110100001010; #100;
		in = 26'b11000000000010110100001010; #100;

	end // initial

endmodule // zeroextend_testbench