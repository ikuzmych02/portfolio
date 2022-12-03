`timescale 1ps/1ps
/**
 * File containing all multiplexers we used to build
 * the 32 to 1 multiplexer that accepts
 * 64-bit integers as inputs
 *
 */


module mux2to1 #(parameter WIDTH = 64) (select, in, out);
	input logic select;
	input logic [WIDTH - 1:0] in [0:1];
	
	output logic [WIDTH - 1:0] out;
	
	logic [WIDTH - 1:0] and1, and2;
	
	genvar i;
	generate
		for (i = 0; i < WIDTH; i++) begin: doing
			and #50ps bit0(and1[i], ~select, in[0][i]);
			and #50ps bit1(and2[i], select, in[1][i]);
			or #50ps outBit(out[i], and1[i], and2[i]);
		end
	endgenerate

endmodule


module mux2to1_single_bit(select, in, out);
	input logic select;
	input logic [1:0] in;
	
	output logic out;
	
	logic and1, and2;
	
	and #50ps bit0(and1, ~select, in[0]);
	and #50ps bit1(and2, select, in[1]);
	or #50ps outBit(out, and1, and2);

endmodule

module mux2to1_single_bit_testbench();
	logic select;
	logic [1:0] in;
	
	logic out;
	
	
	mux2to1_single_bit dut(.*);

	assign in = 2'b10;
	
	
	initial begin 
		integer i;
		for (i = 0; i < 2; i++) begin
			select = i; #300;
		end
	end
	
endmodule

module mux2to1_testbench();
	logic select;
	logic [63:0] in [0:1];
	
	logic [63:0] out;
	
	
	mux2to1 dut(.*);

	assign in[0] = 64'd5000;
	assign in[1] = 64'd123569;
	
	
	initial begin 
		integer i;
		for (i = 0; i < 2; i++) begin
			select = i; #300;
		end
	end
	
endmodule


module mux4to1(select, in, out);
	
	input logic [1:0] select;
	input logic [63:0] in [0:3];
	
	output logic [63:0] out;
	
	logic [63:0] and1, and2, and3, and4;

	genvar i;
	generate
		for (i = 0; i < 64; i++) begin: doing
			and #50ps lowRegister(and1[i], ~select[1], ~select[0], in[0][i]);
			and #50ps lowRegister1(and2[i], ~select[1], select[0], in[1][i]);
			and #50ps highRegister1(and3[i], select[1], ~select[0], in[2][i]);
			and #50ps highRegister(and4[i], select[1], select[0], in[3][i]);	
			or #50ps outRegister(out[i], and1[i], and2[i], and3[i], and4[i]);
		end
	endgenerate

endmodule

module mux4to1_testbench();
	logic [1:0] select;
	logic [63:0] in [0:3];
	
	logic [63:0] out;
	
	
	mux4to1 dut(.*);

	assign in[0] = 64'd5000;
	assign in[1] = 64'd123569;
	assign in[2] = 64'd8745985632;
	assign in[3] = 64'd0;
	
	
	initial begin 
		integer i;
		for (i = 0; i < 4; i++) begin
			select = i; #3000;
		
		end
	end
	
endmodule


/**
 *
 * 64-bit 8to1 multiplexer
 *
 */
module mux8to1(select, in, out);
	
	input logic [2:0] select;
	input logic [63:0] in [0:7];

	output logic [63:0] out;

	logic [63:0] mux1Out, mux2Out;


	mux4to1 first(.select(select[1:0]), .in(in[0:3]), .out(mux1Out));
	mux4to1 second(.select(select[1:0]), .in(in[4:7]), .out(mux2Out));
	mux2to1 result(.select(select[2]), .in({mux1Out, mux2Out}), .out);

endmodule


module mux16to1(select, in, out);
	input logic [3:0] select;
	input logic [63:0] in [0:15];
	
	output logic [63:0] out;	

	logic [63:0] mux0, mux1, mux2, mux3;
	
	mux4to1 mux0out(.select(select[1:0]), .in(in[0:3]), .out(mux0));
	mux4to1 mux1out(.select(select[1:0]), .in(in[4:7]), .out(mux1));
	mux4to1 mux2out(.select(select[1:0]), .in(in[8:11]), .out(mux2));
	mux4to1 mux3out(.select(select[1:0]), .in(in[12:15]), .out(mux3));
	
	mux4to1 outputBits(.select(select[3:2]), .in({mux0, mux1, mux2, mux3}), .out);
	
	
endmodule


module mux16to1_testbench();

	logic [3:0] select;
	logic [63:0] in [0:15];
	logic [63:0] out;

	mux16to1 dut(.*);
	
	assign in[0] = 64'd5000;
	assign in[1] = 64'd123569;
	assign in[2] = 64'd8745985632;
	assign in[3] = 64'd0;
	
	assign in[4] = 64'd59877;
	assign in[5] = 64'd11;
	assign in[6] = 64'd587;
	assign in[7] = 64'd14;
	
	assign in[8] = 64'd2;
	assign in[9] = 64'd6000000;
	assign in[10] = 64'd98563;
	assign in[11] = 64'd4;


	initial begin 
		integer i;
		for (i = 0; i < 13; i++) begin
			select = i; #300;
		end
	end


endmodule

module mux32to1(ReadReg, in, out);
	input logic [4:0] ReadReg;
	input logic [63:0] in [0:31];
	
	output logic [63:0] out;
	
	logic [63:0] mux0, mux1;
	
	mux16to1 mux0out(.select(ReadReg[3:0]), .in(in[0:15]), .out(mux0));
	mux16to1 mux1out(.select(ReadReg[3:0]), .in(in[16:31]), .out(mux1));
	
	mux2to1 mux2out(.select(ReadReg[4]), .in({mux0, mux1}), .out);

endmodule


module mux32to1_testbench();

	logic [4:0] ReadReg;
	logic [63:0] in [0:31];
	logic [63:0] out;

	mux32to1 dut(.*);

	assign in[0] = 64'd5000;
	assign in[1] = 64'd123569;
	assign in[2] = 64'd8745985632;
	assign in[3] = 64'd0;
	
	assign in[4] = 64'd59877;
	assign in[5] = 64'd11;
	assign in[6] = 64'd587;
	assign in[7] = 64'd14;

	assign in[8] = 64'd2;
	assign in[9] = 64'd6000000;
	assign in[10] = 64'd98563;
	assign in[11] = 64'd4;


	initial begin 
		integer i;
		for (i = 0; i < 13; i++) begin
			ReadReg = i; #300;
		end
	end

endmodule


