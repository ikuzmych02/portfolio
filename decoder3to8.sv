`timescale 1ps/1ps
/**
 * Decoder used to build bigger decoder. Benchmarked in 5 to 32 decoder
 *
 */
module decoder3to8(en, s, data);

	input logic en;
	input logic [2:0] s;
	output logic [7:0] data;
	
	and #50ps d7(data[7], s[2], s[1], s[0], en);
	and #50ps d6(data[6], s[2], s[1], ~s[0], en);
	and #50ps d5(data[5], s[2], ~s[1], s[0], en);
	and #50ps d4(data[4], s[2], ~s[1], ~s[0], en);
	and #50ps d3(data[3], ~s[2], s[1], s[0], en);
	and #50ps d2(data[2], ~s[2], s[1], ~s[0], en);
	and #50ps d1(data[1], ~s[2], ~s[1], s[0], en);
	and #50ps d0(data[0], ~s[2], ~s[1], ~s[0], en);

endmodule


