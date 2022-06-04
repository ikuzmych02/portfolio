/* This module is entirely responsible for the behavior of the game upon reaching any collision, including:
 * 1. hitting left or right wall. 2. hitting AI paddle. 3. hitting the user's paddle
 *
 * Inputs:
 *   clk    - 1-bit clock input hooked up to CLOCK_50 in the top-level module
 *   reset  - 1-bit input that resets the module and starts over the drawing process, hooked up to "Start" on the N8 controller
 *   paddleXLeft  - 10-bit input to pass down the current location of the user's paddles left position
 *	  paddleXRight - 10-bit input to pass down the current location of the user's paddles right position
 *
 * Outputs:
 *   x 		- 11-bit output that comes out of line_drawer, which then is sent to the VGA driver to direct the x-coordinates of the circle
 *   y 		- 11-bit output that comes out of line_drawer, which then is sent to the VGA driver to direct the y-coordinates of the circle
 *   score  - 8-bit input that outputs how many times the user successfully hit the ball in a single round
 *   lose   - 1-bit signal to indicate that the player has "lost" the game, and that the game should now to be manually reset in order to play again
 *
 */
module collisions(clk, reset, paddleXLeft, paddleXRight, sw, score, x, y, lose); 
	input logic clk, reset;
	output logic [10:0] x;
	output logic [10:0] y;
	input logic [9:0] paddleXLeft, paddleXRight; // gets you the center of the circle
	input logic [1:0] sw;
	output logic lose;
	output logic [7:0] score;

	/** 
	 * Logic to hold the values that the line_drawer module should draw the circle from 
	 *  The values update upon collision or loss
	 */
	logic signed [10:0] x0, y0; // new variables to pass into line_drawer
	
	/* 1-bit logic to hold clock value to implicitly cast down to the ROM holding slope values */
	logic clock;
	
	/* logic for accessing the proper values in the ROM */
	logic [9:0] ROMSlope;
	logic [4:0] rdAddress;
	logic [9:0] paddlePositionChecker;
	
	
	/* logic to direct and coordinate line_drawer and the update of registers */
	logic start, done;
	
	/** 
	 * logic to update upon collisions to update the x0 and y0 values in line_drawer, as well as the slope 
	 *  so that the x1 and y1 values can be generated accurately in line_drawer. Upon any change to these registers,
	 *  the ps changes to "updateReg1" so that the hardware can have enough clock cycles to update its information accurately
	 */
	logic signed [3:0] currentSlope;
	logic [9:0] circleX;
	logic [8:0] circleY;
	
	/* logic that flags high each time there is any sort of collision */
	logic collisionTrue;
	
	/** 
	 *  logic to hold the value coming out of x and y registers in line_drawer
	 *	 used to update the x and y outputs coming out of collisions to the VGA display 
	 *  in the top-level module
	 */
	logic signed [10:0] xLineDrawer, yLineDrawer;
	
	/* logic to allow the machine to check for collisions */
	logic check;
	
	/* outputs from line_drawer */
	assign x = xLineDrawer;
	assign y = yLineDrawer;

	/* the current position of the circle */
	assign circleX = x;
	assign circleY = y;
	
	/* implicitly cast down clk input to collisions to the ROM */
	assign clock = clk;
	
	/* logic to generate which ROM address to read based on the position of the ball corresponding to the paddle */
	assign paddlePositionChecker = (circleX - paddleXLeft) / 12;
	assign rdAddress = paddlePositionChecker;	
	
	
	
	/* Enumerations for the controller block */
	enum { draw, updateReg1, updateReg2 } ps, ns;

	/**
	 * always_comb controller block to coordinate behavior of when we allow the VGA display to draw,
	 * or when we want it to pause and update the registers in line_drawer. 
	 * Upon any expected behavior, such as a ball finishing its path, a collision, or a reset, 
	 * we give line_drawer enough clock cycles to update its registers by creating two buffer states:
	 * updateReg1 and updateReg2, and disabling start in line_drawer whenever any of these two states
	 * are active 
	 */
	always_comb begin
		case(ps)
			
			draw: begin start = 1;
					if (done || collisionTrue || reset) begin ns = updateReg1; start = 0; end // if (done || collisionTrue || reset) 
					else ns = draw;
					end // draw
	
			updateReg1: begin start = 0; ns = updateReg2;
							end // updateReg1
			updateReg2: begin start = 0;
							ns = draw;
						   end // updateReg2
		endcase // case(ps)
	end // always_comb

	/**
	 * always_ff block to coordinate behavior of state machine
	 */
	always_ff @(posedge clk) begin
		if (reset)
			ps <= updateReg1;
		else
			ps <= ns;
	end // always_ff

	/**
	 * always_ff to coordinate the datapath and entire flow of our collisions algorithm.
	 * collisionTrue is set to 0 by default, and only gets updated if a collision is to happen.
	 * Upon reset, there are certain default values set for the line_drawer module, such as x0, y0, and the slope.
	 * The check signal is also by default low, and the total score for the player is also reset.
	 * All of the logic is explained in comments within the block
	 */
	always_ff @(posedge clk) begin
		collisionTrue <= 0;
		
		/* Set default values for everything upon reset */
		if (reset) begin
			currentSlope <= -1;
			lose <= 0;
			x0 <= 20;
			y0 <= 20;
			check <= 0;
			score <= 0;
		end // if (reset)
		
		/** 
		 * If the ball is every nearing one of the border walls, and the "check" signal is flagged high, then
		 * update the new x0 and y0 values for the line_drawer, and reverse the slope.
		 */
		if ((((circleX == 629) || (circleX == 10) || (circleY == 20))) && check) begin
			currentSlope <= currentSlope * -1;
			x0 <= circleX;
			y0 <= circleY;
			check <= 0;
			collisionTrue <= 1;
		end // if ((((circleX == 629) || (circleX == 10) || (circleY == 20))) && check)
		
		/**
		 * If the ball is in the middle of the screen away from any borders than keep the check signal active
		 */
		if ((circleX > 10) && (circleX < 629) && (circleY < 458) && (circleY > 20)) begin
			check <= 1;
		end // if ((circleX > 10) && (circleX < 629) && (circleY < 458) && (circleY > 20))
		
		/* The check for if the y-position of the ball is equal to 459 is for if the ball is nearing the ground.
		 * The lose signal is flagged high by default, and check is deactivated
		 */
		if ((circleY == 459) && check) begin
			check <= 0;
			lose <= 1;
			
			/** 
			 * If the calculated position of the paddle is in range of the ball, then turn off lose and flag collisionTrue high
			 * Because we know that the ball is going to hit the paddle, the machine then checks the position and reads the corresponding address
			 * in the ROM which dictates what the new direction of the ball should be based on where it hit the paddle.
			 * If it is on the left side of the paddle, then the slope is always negative. If it is in the middle, the slope is flipped.
			 * Lastly, if the ball hits the right side of the paddle, it is always positive. The currentSlope registers reads out the value from
			 * the ROM and updates the slope in line_drawer which then generates new x1 and y1 values internally if x0 and y0 were also changed.
			 */
			if (((paddlePositionChecker >= 0) && (paddlePositionChecker <= 6))) begin
				lose <= 0;
				collisionTrue <= 1;
				score <= score + 1;
				x0 <= circleX;
				y0 <= circleY;
				if (paddlePositionChecker < 3) begin
					currentSlope <= ROMSlope * -1;
				end // if (paddlePositionChecker < 3)
				
				else if (paddlePositionChecker == 3) begin
					currentSlope <= currentSlope * -(ROMSlope);
				end // else if (paddlePositionChecker == 3) 
				
				else begin
					currentSlope <= ROMSlope;
				end // else
			end // if (((paddlePositionChecker >= 0) && (paddlePositionChecker <= 6)))
		end // if (circleY == 459) && check)
	end // always_ff
	
	
	/* instantiations required for functionality of the collisions module */
	paddlePositionsROM ranges(.address(rdAddress), .clock, .q(ROMSlope));
	line_drawer drawCircle(.clk, .reset, .start, .slope(currentSlope), .sw, .x0, .y0, .x(xLineDrawer), .y(yLineDrawer), .done);

endmodule // collisions

/* collisions testbench */
`timescale 1 ps / 1 ps
module collisions_testbench();
	logic clk, reset;
	logic [10:0] x; 
	logic [10:0] y;
	logic [9:0] paddleXLeft, paddleXRight; // gets you the center of the circle
	logic lose;
	logic [7:0] score;
	logic [1:0] sw;
	
	collisions dut(.*);
	
	/* simulated clock */
	initial begin
		clk <= 0;
		forever #10 clk <= ~clk;
	end // initial
	
	/* testbench to show collision with the paddle and the ball */
	initial begin
		reset <= 1; paddleXLeft <= 400; paddleXRight <= 484; @(posedge clk);
		reset <= 0; repeat(4000) @(posedge clk);
	$stop;
	end // initial
	

endmodule // collisions_testbench



