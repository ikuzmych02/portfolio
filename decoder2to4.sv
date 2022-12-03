`timescale 1ps/1ps
/**
 * Decoder used to build bigger decoder
 */
module decoder2to4(en, select, data);

	input logic en;
	input logic [1:0] select;
	output logic [3:0] data;
	
	and #50ps d3(data[3], select[1], select[0], en);
	and #50ps d2(data[2], select[1], ~select[0], en);
	and #50ps d1(data[1], ~select[1], select[0], en);
	and #50ps d0(data[0], ~select[1], ~select[0], en);	

endmodule


`timescale 1ns/10ps
module decoder2to4_testbench();

	logic en;
	logic [1:0] select;
	logic [3:0] data;

	decoder2to4 dut(.*);
	
	initial begin
		en = 1; #20;
		select = 2'd0; #20;
		select = 2'd1; #20;
		select = 2'd2; #20;
		select = 2'd3; #20;
	end

endmodule
