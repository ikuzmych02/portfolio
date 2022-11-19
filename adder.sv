// Test bench for ALU
`timescale 1ps/1ps

/**
 * Module built specifically only to do
 * single-bit addition
 */

module adder(a, b, cin, cout, sum, subtr);
	input logic a, b, cin, subtr;
	output logic sum, cout;
	
	logic aANDout, CiANDout, bANDout;
	logic trueB;
	
	xor #50ps bOUT(trueB, b, subtr); // XOR of B and subtract signal for full adder input
	xor #50ps sumTotal(sum, a, trueB, cin); // output for the sum


	and #50ps A(aANDout, a, cin);
	and #50ps B(bANDout, trueB, cin);
	and #50ps Cin(CiANDout, a, trueB);

	or #50ps total(cout, aANDout, bANDout, CiANDout);


endmodule // adder


/* adder testbench */
module adder_testbench();
	logic a, b, cin, subtr;
	logic sum, cout;
	
	adder dut(.*);

	//
	// Simple testbench to check subtraction
	// and addition operations in our full
	// adder/subtractor
	//
	initial begin
		a = 1; b = 1; cin = 0; subtr = 1'b0; #750;
		a = 1; b = 0; cin = 1; #750;
		a = 0; b = 0; cin = 1; #750;
		a = 0; b = 1; cin = 0; #750;
		
		a = 1; b = 1; cin = 1; subtr = 1'b0; #750;
		a = 1; b = 0; cin = 1; #750;
		a = 0; b = 0; cin = 1; #750;
		a = 0; b = 1; cin = 0; #750;
		
	end // initial

endmodule // adder_testbench




module adder_only(a, b, cin, cout, sum);
	input logic a, b, cin;
	output logic sum, cout;
	
	logic aANDout, CiANDout, bANDout;
	
	xor #50ps sumTotal(sum, a, b, cin); // output for the sum


	and #50ps A(aANDout, a, cin);
	and #50ps B(bANDout, b, cin);
	and #50ps Cin(CiANDout, a, b);

	or #50ps total(cout, aANDout, bANDout, CiANDout);


endmodule // adder






