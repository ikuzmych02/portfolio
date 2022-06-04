/* Top-level module directing all behavior through the DE1_SoC, N8 controller, and the VGA display
 * for a custom implemenation of the classic arcade game "Pong" which features a one-of-a-kind
 * Player vs Computer experience
 *
 * Inputs:
 *   CLOCK_50    - 1-bit clock signal
 *   SW          - 1-bit switch inputs corresponding to their assigned number on the DE1_SoC board
 *
 * Outputs:
 *   LEDR 		- 1-bit output corresponding to the LEDRs above the switches on the DE1_SoC board
 *   VGA_R, VGA_B, VGA_G  - 7-bit RGB drivers for the VGA display
 *   VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS   - vga-driven external driver outputs
 *   HEX	      - 7-bit output to drive the corresponding HEX displays on the DE1_SoC board
 */
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW,
					 CLOCK_50, VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS, V_GPIO);
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	inout logic [26:28] V_GPIO;
	
	input CLOCK_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;

	logic reset;
	logic [9:0] x;
	logic [8:0] y;
	logic [7:0] r, g, b;
	
	/* instantiation of the provided vga display driver */
	video_driver #(.WIDTH(640), .HEIGHT(480))
		v1 (.CLOCK_50, .reset, .x, .y, .r, .g, .b,
			 .VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N,
			 .VGA_CLK, .VGA_HS, .VGA_SYNC_N, .VGA_VS);
	 
	 /* single-bit logic outputs from the N8 controller */
    wire up;
    wire down;
    wire left;
    wire right;
    wire a;
    wire b2;
	 wire select;
	 wire start;
	 
    wire latch;
    wire pulse;
    
	 /* V_GPIO assignments for the serial driver backing the N8 controller */
	 assign V_GPIO[27] = pulse;
    assign V_GPIO[26] = latch;

	 /** 
	  * Instantiation of the n8 controller to pass down its right, left, and start outputs
	  */
	 n8_driver driver(
	  .clk(CLOCK_50),
	  .data_in(V_GPIO[28]),
	  .latch(latch),
	  .pulse(pulse),
	  .up(up),
	  .down(down),
	  .left(left),
	  .right(right),
	  .select,
	  .start,
	  .a(a),
	  .b(b2)
    ); 
	
	/* logic to hold the current position of the paddle from vgaOutputs */	
	logic unsigned [9:0] x_paddle1_left, x_paddle1_right;
	logic unsigned [8:0] y_paddle1_bottom, y_paddle1_top;
	
	/* reset logic to pass down to all the modules aside from the VGA driver */
	logic rst;
	
	
	/* logic to hold "right" and "left" coming out of the N8 driver */
	logic moveLeft, moveRight;
	
	/* logic to hold the lose flag from collisions */
	logic lose;
	
	/* logic to hold the current position of the ball on the VGA screen */
	logic [9:0] xCirclePosition;
	logic [8:0] yCirclePosition;
	logic [7:0] score;
	
	/* rst flag is triggered by the start button on the N8 controller */
	assign rst = start; // assign the reset to switch 0 on the DE1_SoC board
	
	/* score tracker on the HEX0 and HEX1 leds on the DE1_SoC board */
	seg7 hex1Value(.hex(score[7:4]), .leds(HEX1));
	seg7 hex0Value(.hex(score[3:0]), .leds(HEX0));
	
	
	/* instantiations of all external modules */
	vgaOutputs colorCoding(.clk(CLOCK_50), .reset(rst), .moveLeft, .moveRight, .x, .y, .xCirclePosition, .x_paddle1_left, .x_paddle1_right, .yCirclePosition, .lose, .r, .g, .b);
	collisions ballsLogicShrek(.clk(CLOCK_50), .reset(rst), .sw(SW[9:8]), .paddleXLeft(x_paddle1_left), .score, .paddleXRight(x_paddle1_right), .x(xCirclePosition), .y(yCirclePosition), .lose); 
	
	/* module for ensuring that the fast clock will not glitch out and allow a single press to move the paddle more than we expect. One increment per button press */
	Click onepress1(.clock(CLOCK_50), .reset(rst), .in(left), .out(moveLeft));
	Click onepress2(.clock(CLOCK_50), .reset(rst), .in(right), .out(moveRight));	
	
	/* Default assignments for the DE1 board for all unused signals and outputs*/
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	assign reset = 0;
	
endmodule
