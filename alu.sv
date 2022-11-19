// Test bench for ALU
`timescale 1ps/1ps

/**
 *
 * Top-level ALU module based on and built based on the diagram
 * provided in the lab specifications.
 * This module takes in a 3-bit control input, as well as two
 * 64-bit numbers: A, B. 
 * The ALU does all calculations (PASS B, ADD, SUB, AND, OR, XOR)
 * and delivers output based on control signal and an 8to1 multiplexer,
 * with hard-coded zeroes for outputs we disregard
 *
 */
module alu(A, B, cntrl, result, negative, zero, overflow, carry_out);
	input logic	[63:0] A, B;
	input logic	[2:0]	cntrl;
	output logic [63:0] result;
	output logic negative, zero, overflow, carry_out;	

	logic [63:0] outputXOR, outputOR, outputAND;
	logic [63:0] outputAdd, outputSub;
	
	logic [63:0] coutAddTop, coutSubTop;
	logic overflowSub, overflowAdd;
	
	logic [63:0] shiftOutRight;
	shifter shiftRightLogic(.value(A), .direction(1'b1), .distance(B[5:0]), .result(shiftOutRight));
	
	//
	// Hard-code the least significant bits of the output, as this will determine the
	// carry-ins for the next, more significant bits
	//
	alu_one_bit results(.carryinAdd(1'b0), .carryinSub(1'b1), .a(A[0]), .b(B[0]), .coutAdd(coutAddTop[0]), .coutSub(coutSubTop[0]), 
							  .bitOR(outputOR[0]), .bitXOR(outputXOR[0]), 
							  .bitAND(outputAND[0]), .resultAdd(outputAdd[0]), .resultSub(outputSub[0]));
	
	//
	// Generate outputs for all the calculations
	//
	genvar i;
	generate
		for (i = 1; i < 64; i++) begin: doing
			alu_one_bit results(.carryinAdd(coutAddTop[i-1]), .carryinSub(coutSubTop[i-1]), .a(A[i]), .b(B[i]), 
									  .coutAdd(coutAddTop[i]), .coutSub(coutSubTop[i]), .bitOR(outputOR[i]), .bitXOR(outputXOR[i]), 
									  .bitAND(outputAND[i]), .resultAdd(outputAdd[i]), .resultSub(outputSub[i]));
		end
	endgenerate // generate
	
	//
	// Module that checks if the result is equal to 0
	//
	isZero checkZero(.result, .zero);
	
	//
	// XOR the final carryout bit and carryin bits to check if overfow occured
	//
	xor #50ps additionO(overflowAdd, coutAddTop[63], coutAddTop[62]);
	xor #50ps subtractionO(overflowSub, coutSubTop[63], coutSubTop[62]);
	
	//
	// MUX to determine which overflow we want to output, based on
	// if cntrl calls for addition or subtraction
	//
	mux2to1_single_bit assignOverflow(.select(cntrl[0]), .in({overflowSub, overflowAdd}), .out(overflow));
	mux2to1_single_bit assignCarry(.select(cntrl[0]), .in({coutSubTop[63], coutAddTop[63]}), .out(carry_out));
	
	//
	// negative is assigned by most-significant sign bit
	//
	assign negative = result[63];
	
	//
	// Final output assignments
	//
	mux8to1 outputs(.select(cntrl), .in({B, shiftOutRight, outputAdd, outputSub, outputAND, outputOR, outputXOR, 64'd0}), .out(result));
	 
	
endmodule

