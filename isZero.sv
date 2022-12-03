// Test bench for ALU
`timescale 1ps/1ps
/** 
 *
 * Module to check if the 64-bit number is zero
 *
 */
module isZero(result, zero);
	input logic [63:0] result;
	output logic zero;
	logic  [15:0] norOut;
	logic [3:0] andOut;
	
	//
	// Generate 16 NOR outputs to then and altogether to 
	// check if our result is 0
	//
	genvar i;
	generate
		for (i = 0; i < 16; i++) begin: doing
				nor #50ps A(norOut[i], result[i*4],result[i*4+1],result[i*4+2], result[i*4+3]);
		end
	endgenerate // generate

	and #50ps and1(andOut[0], norOut[0], norOut[1],norOut[2],norOut[3]);
	and #50ps and2(andOut[1], norOut[4], norOut[5],norOut[6],norOut[7]);
	and #50ps and3(andOut[2], norOut[8], norOut[9],norOut[10],norOut[11]);
	and #50ps and4(andOut[3], norOut[12], norOut[13],norOut[14],norOut[15]);
	
	and #50ps and5(zero, andOut[0], andOut[1], andOut[2], andOut[3]);
	
endmodule // izZero

/* isZero testbench */
module isZero_testbench();
	logic zero;
	logic [63:0] result;

	isZero dut(.*);

	initial begin 

		result = 64'd0; #3000;
		
		result = 64'd1; #3000;
		
		result = 64'd4390270857; #3000;
		
		result = 64'd0; #3000;

	end // initial

endmodule // isZero_testbench