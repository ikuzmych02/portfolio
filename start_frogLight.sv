/*
	Illya Kuzmych. Lab 8. 
	Frogger. Startlight and the normal light modules

*/

/* module that directs and checks nearby lights to determine when to turn on 
 * the "startlight" ( bottom, middle light )
 * state goes to "on" upon reset
 */
module start_frogLight(clk, reset, NU, NR, NL, ND, U, D, R, L, lightOn, kill);
	input logic clk, reset;
	input logic NU, NR, NL, ND;
	input logic U, D, R, L;
	input logic kill;
	output logic lightOn;

	
	enum { off, on } ps, ns;
	
	
	always_comb begin 
		case(ps)
			
			on: begin lightOn = 1;
				 if (~(U | R | L | D) | (U & R & L & D)) ns = on;
				 else ns = off;
				 end 
			off: begin lightOn = 0;
				 if ((NU & D & ~(R | L | U)) | (NL & R & ~(D | L | U)) | (NR & L & ~(D | R | U))
				      | (ND & U & ~(D | R | L))) ns = on;
				 else ns = off;
				 end
		endcase
	end
	
	always_ff @(posedge clk) begin
		if (reset | kill) 
			ps <= on;
		else 
			ps <= ns;
	end
endmodule


/* normal frog light behaves in identical manner to start light,
 * except upon reset, the current state of any normal led goes to off
 */
module normal_frogLight(clk, reset, NU, NR, NL, ND, U, D, R, L, lightOn, kill);
	input logic clk, reset;
	input logic NU, ND, NR, NL;
	input logic U, D, R, L;
	input logic kill;
	output logic lightOn;
	
	enum { off, on} ps, ns;
	
	
	always_comb begin 
		case(ps)
			
			on: begin lightOn = 1;
				 if (~(U | D | R | L) | (U & R & D & L)) ns = on;
				 else ns = off;
				 end 
			off: begin lightOn = 0;
				 if ((NU & D & ~(R | L | U)) | (NL & R & ~(D | L | U)) 
				 | (NR & L & ~(D | R | U)) | (ND & U & ~(D | R | L))) ns = on;
				 else ns = off;
				 end
		endcase
	end
	
	always_ff @(posedge clk) begin
		if (reset | kill) 
			ps <= off;
		else 
			ps <= ns;
	end
endmodule


/* module to simulate the frog LEDS*/
module frogLight_testbench();   //testbench for both normalLight and centerLight modules
	logic clk, reset;
	logic U, D, L, R, NR, NL, ND, NU;
	logic kill;
	logic lightOn;

	//start_frogLight dut (.*);
	normal_frogLight dut (.*);    //same testbenches for startLight & normLight, 
	//Set up a simulated clk                                         only difference being the dut 
	parameter clk_PERIOD=100;                                      
	initial begin
		clk <= 0;
		forever #(clk_PERIOD/2) clk <= ~clk;
	end

// Set up the inputs to the design. Each line is a clk cycle

	initial begin 
			L <= 0; R <= 0; D <= 0; U <= 0; 	@(posedge clk);
		 reset <= 1;         @(posedge clk); // Always reset FSMs at start
       reset <= 0;			@(posedge clk);
									@(posedge clk);
									@(posedge clk);
									@(posedge clk);
									@(posedge clk);
			 L <= 0; R <= 1; D <= 0; U <= 0;  @(posedge clk); //test case 1: check if after R is pressed, NR and L go back to center
									@(posedge clk);
									@(posedge clk);
			R <= 0;				@(posedge clk);
	NR <= 1; L <= 1; 			@(posedge clk);
									@(posedge clk);
		 NR <= 0; 				@(posedge clk);
		 L <= 0;			      @(posedge clk);
		 L <= 1; R <= 0; 		@(posedge clk); //test case 2: check if after L is pressed, NL and R go back to center
									@(posedge clk);
								   @(posedge clk);
									@(posedge clk);
		                     @(posedge clk);		
		 L <= 0;					@(posedge clk);
		 NL <= 1; R <= 1;    @(posedge clk); 
									@(posedge clk);
NL <= 0; L <= 0; R <= 0;   @(posedge clk);
								   @(posedge clk);
								   @(posedge clk);
								   @(posedge clk);
									@(posedge clk);
								   @(posedge clk);
		$stop; // End the simulation.
	end
endmodule



