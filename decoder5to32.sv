`timescale 1ps/1ps

/**
 * 5 to 32 decoder to choose a register to 
 * write to based on selected register
 *
 */
module decoder5to32(en, s, data);

	input logic en;
	input logic [4:0] s;
	output logic [31:0] data;

	logic [3:0] output2to4;

	decoder2to4 enables(.en, .select(s[4:3]), .data(output2to4));

	decoder3to8 D0D7(.en(output2to4[0]), .s(s[2:0]), .data(data[7:0]));
	decoder3to8 D8D15(.en(output2to4[1]), .s(s[2:0]), .data(data[15:8]));
	decoder3to8 D16D23(.en(output2to4[2]), .s(s[2:0]), .data(data[23:16]));
	decoder3to8 D24D31(.en(output2to4[3]), .s(s[2:0]), .data(data[31:24]));

endmodule


`timescale 1ns/10ps
module decoder5to32_testbench();
	
	logic en;
	logic [4:0] s;
	logic [31:0] data;

	decoder5to32 dut(.*);
	
	integer i;
	initial begin
		en = 1; #100;
		for (i = 0; i < 32; i++) begin
			s = i; #100;
		end
	end


endmodule


