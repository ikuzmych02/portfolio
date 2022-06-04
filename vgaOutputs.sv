/* This module is responsible for the generation and behavior of: 1. user paddle. 2. villain paddle. and the generation of
 * the circle based on a specified equation and the current x and y scanned pixels by the VGA
 *
 * Inputs:
 *   clk    - 1-bit clock input hooked up to CLOCK_50 in the top-level module
 *   reset  - 1-bit input that resets the module and starts over the drawing process, hooked up to "Start" on the N8 controller
 *   moveLeft  - 1-bit "move left" signal. Hooked up to left key in the N8 controller
 *	  moveRight - 1-bit "move right" signal. Hooked up to right key in the N8 controller
 *   lose      - 1-bit signal indicating the player lost the game. Connected to the lose output from collisions module in top-level
 *   x, y      - Values which indicate current VGA position being scanned by the driver
 *   xCirclePosition, yCirclePosition - 10 and 9 bit inputs, respectively, which indicate the current position of the ball
 *
 * Outputs:
 *   r, g, b 		- 8-bit outputs that dictate the coloring of the VGA at any given instance depending on what values it is scanning. Connected to corresponding inputs in top-level module
 *   x_paddle1_left, x_paddle1_right  - 10-bit unsigned inputs corresponding to the current position of the paddle
 *
 */
 
module vgaOutputs(clk, reset, moveLeft, moveRight, lose, x, y, x_paddle1_left, x_paddle1_right, xCirclePosition, yCirclePosition, r, g, b);
	input logic clk, reset, moveLeft, moveRight, lose;
	input logic [9:0] x;
	input logic [8:0] y;
	input logic [9:0] xCirclePosition;
	input logic [8:0] yCirclePosition;
	
	output logic [7:0] r, g, b;
	output logic unsigned [9:0] x_paddle1_left, x_paddle1_right;

	/* y positions of the user paddle. remains constant throughout */
	logic unsigned [8:0] y_paddle1_bottom, y_paddle1_top;	
	
	
	/** 
	 * always_ff block to dictate behavior of the VGA screen based on various inputs
	 */
	always_ff @(posedge clk) begin
		r <= 8'd0;
		g <= 8'd0;
		b <= 8'd0;		
		
		/* Upon reset, set default values for everything */
		if (reset) begin
			y_paddle1_bottom <= 9'd479;
			y_paddle1_top <= 9'd470;
			x_paddle1_right <= 10'd274;
			x_paddle1_left <= 10'd190;
		end // if (reset)
		
		/* Logic to control paddle positions based on user input */
		if (moveLeft && (x_paddle1_left > 0)) begin 
			x_paddle1_left <= x_paddle1_left - 10;
			x_paddle1_right <= x_paddle1_right - 10;
		end // if (moveLeft && (x_paddle1_left > 0)) 
		
		else if (moveRight && (x_paddle1_right < 639)) begin 
			x_paddle1_left <= x_paddle1_left + 10;
			x_paddle1_right <= x_paddle1_right + 10;
		end // else if (moveRight && (x_paddle1_right < 639))
		
		/* If the current position being scanned coincides with the expected position of the paddle, change the current pixels color to white */
		if ((x >= x_paddle1_left) && (x <= x_paddle1_right) && (y >= y_paddle1_top) && (y <= y_paddle1_bottom)) begin // the good guy
			r <= 8'd255;
			g <= 8'd255;
			b <= 8'd255;
		end // if ((x >= x_paddle1_left) && (x <= x_paddle1_right) && (y >= y_paddle1_top) && (y <= y_paddle1_bottom))

		/* Draw the circle if it's coordinates are in the pixels being scanned */
		if ((((x - xCirclePosition)**2) + ((y - yCirclePosition)**2)) <= (10**2)) begin
			r <= 8'd255;
			g <= 8'd255;
			b <= 8'd255;
		end // if ((((x - xCirclePosition)**2) + ((y - yCirclePosition)**2)) <= (10**2))
		
		/* If the position of the circle goes to the left edge, maintain the color of the "computer" paddle */
		if (xCirclePosition <= 42) begin
			if ((y >= 9'd0) && (y <= 9'd10) && (x >= 0) && (x <= 84)) begin
				r <= 8'd255;
				g <= 8'd0;
				b <= 8'd0;				
			end // if ((y >= 9'd0) && (y <= 9'd10) && (x >= 0) && (x <= 84))
		end // if (xCirclePosition <= 42)
		
		else if ((y >= 9'd0) && (y <= 9'd10) && (x >= (xCirclePosition - 10'd42)) && (x <= xCirclePosition + 10'd42)) begin // computer-controlled paddle
			r <= 8'd255;
			g <= 8'd0;
			b <= 8'd0;
		end // else if ((y >= 9'd0) && (y <= 9'd10) && (x >= (xCirclePosition - 10'd42)) && (x <= xCirclePosition + 10'd42))
		
		if (lose) begin
			r <= 8'd0;
			g <= 8'd0;
			b <= 8'd0;
		end // if (lose)
	end // always_ff
	
endmodule // vgaOutputs

/* vgaOutputs testbench */
module vgaOutputs_testbench();
	logic clk, reset, moveLeft, moveRight, lose;
	logic [9:0] x;
	logic [8:0] y;
	logic [9:0] xCirclePosition;
	logic [8:0] yCirclePosition;	
	logic [7:0] r, g, b;
	logic unsigned [9:0] x_paddle1_left, x_paddle1_right;
	vgaOutputs dut(.*);

	initial begin 
		clk <= 0;
		forever #50 clk <= ~clk;
	end // initial
	
	initial begin
		reset = 1; xCirclePosition <= 100; yCirclePosition <= 100; x <= 150; y <= 150; @(posedge clk);
		reset <= 0; @(posedge clk);
		
		/* Show functionality of the user paddle moving */
		moveLeft <= 1; repeat (5) @(posedge clk);
		moveLeft <= 0; moveRight <= 1; repeat(5) @(posedge clk);
		
		
		/* white rgb values for player paddle */
		x <= 200; y <= 475; repeat(2) @(posedge clk); 
		
		/* red rgb values for player paddle */
		x <= xCirclePosition - 10'd35; y <= 5; repeat(2) @(posedge clk);
	$stop;
	end // initial
	
endmodule // vgaOutputs_testbench
