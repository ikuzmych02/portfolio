
//module for one movement per one click, prevent holding
module oneClick(clock, reset, in, out);  
	input logic clock, reset, in;
	output logic out;
	
	enum { off, on, hold } ps, ns;

	always_comb begin 
		case(ps)
		
		off: begin out = 0;
			  if (~in) ns = off;
			  else ns = on;
			  end
		on: 	begin out = 1;
				if (in) ns = hold;
				else ns = off;
				end
		hold: begin out = 0;
			   if (in) ns = hold;
			   else ns = off;
				end
	   
		endcase
	end
	
	always_ff  @(posedge clock) begin
		if (reset) 
			ps <= off;
		else 
			ps <= ns;
	end
endmodule

//testbench to test if oneclick per move works
module oneClick_testbench();  
logic clock, reset, in, out;

	oneClick dut (.clock, .reset, .in, .out);
	//Set up a simulated clock
	parameter CLOCK_PERIOD=100;
	initial begin
		clock <= 0;
		forever #(CLOCK_PERIOD/2) clock <= ~clock;
	end

// Set up the inputs to the design. Each line is a clock cycle

	initial begin 
		in <= 0;					@(posedge clock);
		reset <= 1;          @(posedge clock); // Always reset FSMs at start
									@(posedge clock);
									@(posedge clock);
									@(posedge clock);
									@(posedge clock);
		reset <= 0;				@(posedge clock);
									@(posedge clock);
									@(posedge clock);
									@(posedge clock);
		in <= 1;					@(posedge clock); //test case 1: hold in
									@(posedge clock);
									@(posedge clock);
									@(posedge clock);
									@(posedge clock);
		in	<= 0;					@(posedge clock);
									@(posedge clock);
								   @(posedge clock);
									@(posedge clock);
		                     @(posedge clock);		
		in <= 1;				   @(posedge clock); 
									@(posedge clock); 
									@(posedge clock);
									@(posedge clock);
								   @(posedge clock);
								   @(posedge clock);
		in <= 0;					@(posedge clock);
									@(posedge clock);
								   @(posedge clock);
								   @(posedge clock);
		$stop; // End the simulation.
	end
endmodule