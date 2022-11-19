// Test bench for ALU
`timescale 1ps/1ps

/**
 * 
 * One bit ALU that is to be called 64 times in top-level, 64-bit ALU
 * 
 */
module alu_one_bit(carryinAdd, carryinSub, a, b, coutAdd, coutSub, bitOR, bitXOR, bitAND, resultAdd, resultSub);
	input logic carryinAdd, carryinSub, a, b;

	output logic coutAdd, coutSub;
	output logic bitOR, bitXOR, bitAND;
	output logic resultAdd, resultSub;
	
	
	// calculate all the bitwise operations
	xor #50ps doXOR(bitXOR, a, b); // bitwise XOR
	and #50ps doAND(bitAND, a, b); // bitwise AND
	or #50ps doOR(bitOR, a, b);    // bitwise OR
	
	// calculate the sum
	adder addition(.a, .b, .cin(carryinAdd), .cout(coutAdd), .sum(resultAdd), .subtr(1'b0));

	// calculate the difference
	adder subtraction(.a, .b, .cin(carryinSub), .cout(coutSub), .sum(resultSub), .subtr(1'b1));

endmodule

/* alu one bit testbench */
module alu_one_bit_testbench();
	logic carryinAdd, carryinSub, a, b;
	logic coutAdd, coutSub;
	logic bitOR, bitXOR, bitAND;
	logic resultAdd, resultSub;
	
	alu_one_bit dut(.*);

	//
	// Simple testbench to ensure that all of our calculated
	// outputs are accurate
	//
	initial begin
	
		carryinAdd = 0; carryinSub = 1; a = 1; b = 1; #2000;

	end


endmodule


