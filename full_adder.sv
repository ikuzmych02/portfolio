// Test bench for ALU
`timescale 1ps/1ps

module full_adder(in1, in2, out);
	input logic [63:0] in1, in2;
	output logic [63:0] out;
	
	
	logic [63:0] carryLogic;
	
	adder_only result0(.a(in1[0]), .b(in2[0]), .cin(1'b0), .cout(carryLogic[0]), .sum(out[0]));
	
	//
	// Generate outputs for all the calculations
	//
	genvar i;
	generate
		for (i = 1; i < 64; i++) begin: doing
			adder_only result(.a(in1[i]), .b(in2[i]), .cin(carryLogic[i-1]), .cout(carryLogic[i]), .sum(out[i]));
		end
	endgenerate // generate

endmodule


module full_adder_testbench();
	logic [63:0] in1, in2;
	logic [63:0] out;
	
	full_adder dut(.*);


	initial begin
		in1 = 64'd1; in2 = 64'd12; #500;
		in1 = 64'd1000; in2 = 64'd4; #500;
		in1 = 64'd1004; in2 = 64'd4; #500;
		in1 = 64'd1008; in2 = 64'd100; #500;

	end // initial


endmodule // full adder testbench