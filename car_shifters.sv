// This module will generate "cars" as Red LEDS to
// behave as an obstacle to the "frog" (Grn Led) 

module car_move #(parameter N = 16) 
	(input logic clk, reset, press, load, 
	 output logic [N-1:0] q);

    always_ff @(posedge clk) begin
        if (reset) begin
            q[N-1:0] <= 16'b0000000000000000;
        end 
        else if (press & load) begin
        q[N-1:0] <= 16'b0000000000000001;
        q[N-1:1] <= q[N-2:0];
        end
        else if (press & ~load) begin
            q[N-1:0] <= (q[N-1:0] << 1);
        end
    end
endmodule

// testbench to simulate the functional the "car_move" module
module car_move_testbench();
	parameter N = 16;
	
	logic clk, reset;
	logic press, load;
	logic [N-1:0] q;
	
	car_move dut(.*);
	
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	
	initial begin 
		load <= 1; repeat(7) @(posedge clk);
		load <= 0; repeat(7) @(posedge clk);
		load <= 1; repeat(7) @(posedge clk);
		load <= 0; repeat(7) @(posedge clk);
		
	$stop;
	end
	initial begin 
		press <= 1; repeat(1) @(posedge clk);
		press <= 0; repeat(6) @(posedge clk);
		press <= 1; repeat(1) @(posedge clk);
		press <= 0; repeat(6) @(posedge clk);
		press <= 1; repeat(1) @(posedge clk);
		press <= 0; repeat(6) @(posedge clk);
		press <= 1; repeat(1) @(posedge clk);
		press <= 0; repeat(6) @(posedge clk);
		
	$stop;
	end
	

endmodule


// LFSR created to change the difficulty of the game
module LFSR_10(clock, reset, lfsr);
	output logic [9:0] lfsr;
	input logic clock, reset;
	
	
	always_ff  @(posedge clock) begin
		if (reset) begin
			lfsr[9:0] <= '0;  //every bit -> 0
		end
		else begin
			lfsr[8:0] <= lfsr[9:1]; //always shift one right
			lfsr[9] <= lfsr[0] ~^ lfsr[3];    //XNOR of Q7 and Q10 
		end
	end
//	assign out = lfsr;
endmodule

// test for the above LFSR_10 module
module LFSR_10_testbench();
	logic clock, reset;
	logic lfsr;
	
	LFSR_10 dut(.*);
	parameter CLOCK_PERIOD=100;
	initial begin
		clock <= 0;
		forever #(CLOCK_PERIOD/2) clock <= ~clock; // Forever toggle the clock
	end
	
	initial begin 
		reset <= 1; repeat(1) @(posedge clock);
		reset <= 0; repeat(0) @(posedge clock);
		repeat(25) @(posedge clock);
	$stop;
	end
	
endmodule


// module used as a random bit generator to load in cars
module LFSR_7(clock, reset, lfsr);
	output logic [6:0] lfsr;
	input logic clock, reset;
	
	
	always_ff  @(posedge clock) begin
		if (reset) begin
			lfsr[6:0] <= '0;  //every bit -> 0
		end
		else begin
			lfsr[5:0] <= lfsr[6:1]; //always shift one right
			lfsr[6] <= lfsr[0] ~^ lfsr[1];    //XNOR of Q7 and Q10 
		end
	end
//	assign out = lfsr;
endmodule

// testbench to simulate above LFSR_7 module
module LFSR_7_testbench();
	logic clock, reset;
	logic lfsr;
	
	LFSR_7 dut(.*);
	parameter CLOCK_PERIOD=100;
	initial begin
		clock <= 0;
		forever #(CLOCK_PERIOD/2) clock <= ~clock; // Forever toggle the clock
	end
	
	initial begin 
		reset <= 1; repeat(1) @(posedge clock);
		reset <= 0; repeat(0) @(posedge clock);
		repeat(25) @(posedge clock);
	$stop;
	end
	
endmodule



// module to compare the set bit value of switches
// to the LFSR random number
// generator

module comparator(sw, random, true);
	input logic [8:0] sw;
	input logic [9:0] random;
	output logic true; 
	
	always_comb begin 
		if (sw > random) begin
			true = 1;
		end else begin 
			true = 0;
		end
	end
endmodule

// testbench to simulate above module
module comparator_testbench();
	logic [8:0] sw;
	logic [9:0] random;
	logic true; 
	
	comparator dut(.*);
	
	initial begin 
		sw = 9'b011001100; #5;
		sw = 9'b001111111; #5;
		sw = 9'b011001100; #5;
		sw = 9'b011001100; #5;
	
	end
	initial begin 
		random = 10'b0110111000; #5;
		random = 10'b0111111100; #5;
		random = 10'b0110000000; #5;
		random = 10'b0110001011; #5;
	end
	
	
endmodule

