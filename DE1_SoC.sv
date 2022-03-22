// Top-level module that defines the I/Os for the DE-1 SoC board
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR, GPIO_1, CLOCK_50);
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	 output logic [9:0]  LEDR;
    input  logic [3:0]  KEY;
    input  logic [9:0]  SW;
    output logic [35:0] GPIO_1;
    input logic CLOCK_50;
	 
    logic [3:0] key;
	 logic key0temp, key0new;
	 logic key1temp, key1new;
	 logic key2temp, key2new;
	 logic key3temp, key3new;
	 logic [31:0] clk;
	 logic SYSTEM_CLOCK;
	 logic [15:0][15:0]RedPixels; // 16 x 16 array representing red LEDs
    logic [15:0][15:0]GrnPixels; // 16 x 16 array representing green LEDs
	 logic reset;
	 
	 logic overlap;
	 logic U, D, R, L;
	 
	 assign R = key[0];
	 assign D = key[1];
	 assign U = key[2];
	 assign L = key[3];
	 assign reset = SW[9];
	 
	 	 
	/* Standard LED Driver instantiation - set once and 'forget it'. 
	    See LEDDriver.sv for more info. Do not modify unless you know what you are doing! */
	 LEDDriver Driver (.CLK(SYSTEM_CLOCK), .reset, .EnableCount(1'b1), .RedPixels, .GrnPixels, .GPIO_1);
	 


	 /* Set up system base clock to 1526 Hz (50 MHz / 2**(14+1))
	    ===========================================================*/
	 
	 
	 // Turn off HEX displays
    assign HEX0 = '1;
    assign HEX1 = '1;
    assign HEX2 = '1;
    assign HEX3 = '1;
    assign HEX4 = '1;
    assign HEX5 = '1;
	 
	 clock_divider divider (.clock(CLOCK_50), .divided_clocks(clk));
	 
	 /* clk[14] to be used for the DE1_SoC FPGA board */
	 assign SYSTEM_CLOCK = clk[14]; // 1526 Hz clock signal	 
	 
	 /* CLOCK_50 to be used for simulation */
	 //assign SYSTEM_CLOCK = CLOCK_50;



	 
	 /* Simple statement to check if GrnLED is ever touching RedLED to 
	  * kill the frog and reset the game
	  */
	 assign overlap = |(RedPixels & GrnPixels); // to be used to show when the pixels overlap
	 
	 
	 /* 2DFFs per user input to prevent metastability */
	 always_ff @(posedge SYSTEM_CLOCK) begin 
		key0temp <= KEY[0];
		key0new <= key0temp;
	 end
	 
	 always_ff @(posedge SYSTEM_CLOCK) begin 
		key1temp <= KEY[1];
		key1new <= key1temp;
	 end
	 
	 always_ff @(posedge SYSTEM_CLOCK) begin 
		key2temp <= KEY[2];
		key2new <= key2temp;
	 end
	 
	 always_ff @(posedge SYSTEM_CLOCK) begin 
		key3temp <= KEY[3];
		key3new <= key3temp;
	 end	 
	 
	 /* 4 initiations of the oneClick module
	  * responsible for taking in only a single input per click
	  * instead of rate of true signal per clock cycle
	  */
	  
	 oneClick o0(.clock(SYSTEM_CLOCK), .reset, .in(key0new), .out(key[0]));
	 oneClick o1(.clock(SYSTEM_CLOCK), .reset, .in(key1new), .out(key[1]));
	 oneClick o2(.clock(SYSTEM_CLOCK), .reset, .in(key2new), .out(key[2]));
	 oneClick o3(.clock(SYSTEM_CLOCK), .reset, .in(key3new), .out(key[3]));
	 
	 
	 
	 
	 
	/* generate 15x15 section on the board excluding the border LEDS */ 
	genvar i, j;
	generate
        for(i = 1; i < 15; i++) begin : rows  
            for(j = 1; j < 15; j++) begin: columns
               normal_frogLight f200 (.clk(SYSTEM_CLOCK), .reset, .R, .L, .U, .kill(overlap),
									       .D, .NR(GrnPixels[i][j-1]), .NL(GrnPixels[i][j+1]), .NU(GrnPixels[i-1][j]),
		                            .ND(GrnPixels[i+1][j]), .lightOn(GrnPixels[i][j]));
       end
     end
   endgenerate
	
	
   // lose_frogger crash(.car(RedPixels[15:0][15:0]), .frog(GrnPixels[15:0][15:0]), .lose(frogDead));
	 
	 
	 /* Instantiations of all locations for the frog on the board 
	  * Generate statement to fill in the 15x15 inside block, and separate statements for each
	  * other edge LED
	  */
	 start_frogLight f15_7(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[15][7]), .NU(GrnPixels[14][7]), 
					   .NR(GrnPixels[15][6]), .NL(GrnPixels[15][8]), .ND(GrnPixels[0][7]),
					   .U, .D, .R, .L, .kill(overlap));
	 
	 
    // entire bottom row: excluding the startlight
 
	 normal_frogLight f15_0(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[15][0]), .NU(GrnPixels[14][0]), 
					   .NR(GrnPixels[15][15]), .NL(GrnPixels[15][1]), .ND(GrnPixels[0][0]), 
					   .U, .D, .R, .L, .kill(overlap));
						
	 normal_frogLight f15_1(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[15][1]), .NU(GrnPixels[14][1]), 
					   .NR(GrnPixels[15][0]), .NL(GrnPixels[15][2]), .ND(GrnPixels[0][1]), 
					   .U, .D, .R, .L, .kill(overlap));
						
	 normal_frogLight f15_2(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[15][2]), .NU(GrnPixels[14][2]), 
					   .NR(GrnPixels[15][1]), .NL(GrnPixels[15][3]), .ND(GrnPixels[0][2]), 
					   .U, .D, .R, .L, .kill(overlap));
	 
	 normal_frogLight f15_3(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[15][3]), .NU(GrnPixels[14][3]), 
					   .NR(GrnPixels[15][2]), .NL(GrnPixels[15][4]), .ND(GrnPixels[0][3]), 
					   .U, .D, .R, .L, .kill(overlap));
						
	 normal_frogLight f15_4(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[15][4]), .NU(GrnPixels[14][4]), 
					   .NR(GrnPixels[15][3]), .NL(GrnPixels[15][5]), .ND(GrnPixels[0][4]), 
					   .U, .D, .R, .L, .kill(overlap));
						
	 normal_frogLight f15_5(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[15][5]), .NU(GrnPixels[14][5]), 
					   .NR(GrnPixels[15][4]), .NL(GrnPixels[15][6]), .ND(GrnPixels[0][5]), 
					   .U, .D, .R, .L, .kill(overlap));
	 
	 
	 normal_frogLight f15_6(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[15][6]), .NU(GrnPixels[14][6]), 
					   .NR(GrnPixels[15][5]), .NL(GrnPixels[15][7]), .ND(GrnPixels[0][6]), 
					   .U, .D, .R, .L, .kill(overlap));
						
	 normal_frogLight f15_8(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[15][8]), .NU(GrnPixels[14][8]), 
					   .NR(GrnPixels[15][7]), .NL(GrnPixels[15][9]), .ND(GrnPixels[0][8]), 
					   .U, .D, .R, .L, .kill(overlap));

	 normal_frogLight f15_9(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[15][9]), .NU(GrnPixels[14][9]), 
					   .NR(GrnPixels[15][8]), .NL(GrnPixels[15][10]), .ND(GrnPixels[0][9]), 
					   .U, .D, .R, .L, .kill(overlap));
						
	 normal_frogLight f15_10(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[15][10]), .NU(GrnPixels[14][10]), 
					   .NR(GrnPixels[15][9]), .NL(GrnPixels[15][11]), .ND(GrnPixels[0][10]), 
					   .U, .D, .R, .L, .kill(overlap));

	 
	 
	 normal_frogLight f15_11(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[15][11]), .NU(GrnPixels[14][11]), 
					   .NR(GrnPixels[15][10]), .NL(GrnPixels[15][12]), .ND(GrnPixels[0][11]), 
					   .U, .D, .R, .L, .kill(overlap));
						
	 normal_frogLight f15_12(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[15][12]), .NU(GrnPixels[14][12]), 
					   .NR(GrnPixels[15][11]), .NL(GrnPixels[15][13]), .ND(GrnPixels[0][12]), 
					   .U, .D, .R, .L, .kill(overlap));
						
	 normal_frogLight f15_13(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[15][13]), .NU(GrnPixels[14][13]), 
					   .NR(GrnPixels[15][12]), .NL(GrnPixels[15][14]), .ND(GrnPixels[0][13]), 
					   .U, .D, .R, .L, .kill(overlap));
						
	 normal_frogLight f15_14(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[15][14]), .NU(GrnPixels[14][14]), 
					   .NR(GrnPixels[15][13]), .NL(GrnPixels[15][15]), .ND(GrnPixels[0][14]), 
					   .U, .D, .R, .L, .kill(overlap));
						
	 normal_frogLight f15_15(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[15][15]), .NU(GrnPixels[14][15]), 
					   .NR(GrnPixels[15][14]), .NL(GrnPixels[15][0]), .ND(GrnPixels[0][15]), 
					   .U, .D, .R, .L, .kill(overlap));
						
	
	
	
	//left column 
	
	normal_frogLight f14_15(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[14][15]), .NU(GrnPixels[13][15]), 
					   .NR(GrnPixels[14][14]), .NL(GrnPixels[14][0]), .ND(GrnPixels[15][15]), 
					   .U, .D, .R, .L, .kill(overlap)); // done
						
	normal_frogLight f13_15(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[13][15]), .NU(GrnPixels[12][15]), 
					   .NR(GrnPixels[13][14]), .NL(GrnPixels[13][0]), .ND(GrnPixels[14][15]), 
					   .U, .D, .R, .L, .kill(overlap)); // done
						
	normal_frogLight f12_15(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[12][15]), .NU(GrnPixels[11][15]), 
					   .NR(GrnPixels[12][14]), .NL(GrnPixels[12][0]), .ND(GrnPixels[13][15]), 
					   .U, .D, .R, .L, .kill(overlap)); // done
						
						
	normal_frogLight f11_15(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[11][15]), .NU(GrnPixels[10][15]), 
					   .NR(GrnPixels[11][14]), .NL(GrnPixels[11][0]), .ND(GrnPixels[12][15]), 
					   .U, .D, .R, .L, .kill(overlap)); // done
						
	normal_frogLight f10_15(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[10][15]), .NU(GrnPixels[9][15]), 
					   .NR(GrnPixels[10][14]), .NL(GrnPixels[10][0]), .ND(GrnPixels[11][15]), 
					   .U, .D, .R, .L, .kill(overlap)); // done 
						
	normal_frogLight f9_15(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[9][15]), .NU(GrnPixels[8][15]), 
					   .NR(GrnPixels[9][14]), .NL(GrnPixels[9][0]), .ND(GrnPixels[10][15]), 
					   .U, .D, .R, .L, .kill(overlap)); // done
						
	normal_frogLight f8_15(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[8][15]), .NU(GrnPixels[7][15]), 
					   .NR(GrnPixels[8][14]), .NL(GrnPixels[8][0]), .ND(GrnPixels[9][15]), 
					   .U, .D, .R, .L, .kill(overlap)); // done
						
	normal_frogLight f7_15(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[7][15]), .NU(GrnPixels[6][15]), 
					   .NR(GrnPixels[7][14]), .NL(GrnPixels[7][0]), .ND(GrnPixels[8][15]), 
					   .U, .D, .R, .L, .kill(overlap)); // done 
						
	normal_frogLight f6_15(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[6][15]), .NU(GrnPixels[5][15]), 
					   .NR(GrnPixels[6][14]), .NL(GrnPixels[6][0]), .ND(GrnPixels[7][15]), 
					   .U, .D, .R, .L, .kill(overlap)); // done
						
	normal_frogLight f5_15(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[5][15]), .NU(GrnPixels[4][15]), 
					   .NR(GrnPixels[5][14]), .NL(GrnPixels[5][0]), .ND(GrnPixels[6][15]), 
					   .U, .D, .R, .L, .kill(overlap)); // done
						
	normal_frogLight f4_15(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[4][15]), .NU(GrnPixels[3][15]), 
					   .NR(GrnPixels[4][14]), .NL(GrnPixels[4][0]), .ND(GrnPixels[5][15]), 
					   .U, .D, .R, .L, .kill(overlap)); // done
						
	normal_frogLight f3_15(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[3][15]), .NU(GrnPixels[2][15]), 
					   .NR(GrnPixels[3][14]), .NL(GrnPixels[3][0]), .ND(GrnPixels[4][15]), 
					   .U, .D, .R, .L, .kill(overlap)); // done
						
	normal_frogLight f2_15(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[2][15]), .NU(GrnPixels[1][15]), 
					   .NR(GrnPixels[2][14]), .NL(GrnPixels[2][0]), .ND(GrnPixels[3][15]), 
					   .U, .D, .R, .L, .kill(overlap)); // done
						
	normal_frogLight f1_15(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[1][15]), .NU(GrnPixels[0][15]), 
					   .NR(GrnPixels[1][14]), .NL(GrnPixels[1][0]), .ND(GrnPixels[2][15]), 
					   .U, .D, .R, .L, .kill(overlap)); // done
						
	normal_frogLight f0_15(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[0][15]), .NU(GrnPixels[15][15]), 
					   .NR(GrnPixels[0][14]), .NL(GrnPixels[0][0]), .ND(GrnPixels[1][15]), 
					   .U, .D, .R, .L, .kill(overlap)); // done
	
	
	
	
	//top row 
	
	normal_frogLight f0_14(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[0][14]), .NU(GrnPixels[15][14]), 
					   .NR(GrnPixels[0][13]), .NL(GrnPixels[0][15]), .ND(GrnPixels[1][14]), 
					   .U, .D, .R, .L, .kill(overlap)); // done
						
	normal_frogLight f0_13(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[0][13]), .NU(GrnPixels[15][13]), 
					   .NR(GrnPixels[0][12]), .NL(GrnPixels[0][14]), .ND(GrnPixels[1][13]), 
					   .U, .D, .R, .L, .kill(overlap)); // done
						
	normal_frogLight f0_12(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[0][12]), .NU(GrnPixels[15][12]), 
					   .NR(GrnPixels[0][11]), .NL(GrnPixels[0][13]), .ND(GrnPixels[1][12]), 
					   .U, .D, .R, .L, .kill(overlap)); // done
						
	normal_frogLight f0_11(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[0][11]), .NU(GrnPixels[15][11]), 
					   .NR(GrnPixels[0][10]), .NL(GrnPixels[0][12]), .ND(GrnPixels[1][11]), 
					   .U, .D, .R, .L, .kill(overlap)); // done
						
	normal_frogLight f0_10(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[0][10]), .NU(GrnPixels[15][10]), 
					   .NR(GrnPixels[0][9]), .NL(GrnPixels[0][11]), .ND(GrnPixels[1][10]), 
					   .U, .D, .R, .L, .kill(overlap)); // done
	
	normal_frogLight f0_9(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[0][9]), .NU(GrnPixels[15][9]), 
					   .NR(GrnPixels[0][8]), .NL(GrnPixels[0][10]), .ND(GrnPixels[1][9]), 
					   .U, .D, .R, .L, .kill(overlap)); // done 
						
	normal_frogLight f0_8(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[0][8]), .NU(GrnPixels[15][8]), 
					   .NR(GrnPixels[0][7]), .NL(GrnPixels[0][9]), .ND(GrnPixels[1][8]), 
					   .U, .D, .R, .L, .kill(overlap)); // done
						
	normal_frogLight f0_7(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[0][7]), .NU(GrnPixels[15][7]), 
					   .NR(GrnPixels[0][6]), .NL(GrnPixels[0][8]), .ND(GrnPixels[1][7]), 
					   .U, .D, .R, .L, .kill(overlap)); // done
	
	normal_frogLight f0_6(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[0][6]), .NU(GrnPixels[15][6]), 
					   .NR(GrnPixels[0][5]), .NL(GrnPixels[0][7]), .ND(GrnPixels[1][6]), 
					   .U, .D, .R, .L, .kill(overlap)); // done
						
	normal_frogLight f0_5(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[0][5]), .NU(GrnPixels[15][5]), 
					   .NR(GrnPixels[0][4]), .NL(GrnPixels[0][6]), .ND(GrnPixels[1][5]), 
					   .U, .D, .R, .L, .kill(overlap)); // done 
						
	normal_frogLight f0_4(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[0][4]), .NU(GrnPixels[15][4]), 
					   .NR(GrnPixels[0][3]), .NL(GrnPixels[0][5]), .ND(GrnPixels[1][4]), 
					   .U, .D, .R, .L, .kill(overlap)); // done
						
	normal_frogLight f0_3(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[0][3]), .NU(GrnPixels[15][3]), 
					   .NR(GrnPixels[0][2]), .NL(GrnPixels[0][4]), .ND(GrnPixels[1][3]), 
					   .U, .D, .R, .L, .kill(overlap)); // done
						
	normal_frogLight f0_2(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[0][2]), .NU(GrnPixels[15][2]), 
					   .NR(GrnPixels[0][1]), .NL(GrnPixels[0][3]), .ND(GrnPixels[1][2]), 
					   .U, .D, .R, .L, .kill(overlap)); // done
						
	normal_frogLight f0_1(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[0][1]), .NU(GrnPixels[15][1]), 
					   .NR(GrnPixels[0][0]), .NL(GrnPixels[0][2]), .ND(GrnPixels[1][1]), 
					   .U, .D, .R, .L, .kill(overlap)); // done
						
	normal_frogLight f0_0(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[0][0]), .NU(GrnPixels[15][0]), 
					   .NR(GrnPixels[0][15]), .NL(GrnPixels[0][1]), .ND(GrnPixels[1][0]), 
					   .U, .D, .R, .L, .kill(overlap)); // done 
	
	
	
	
	
	//right column
	
	normal_frogLight f14_0(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[14][0]), .NU(GrnPixels[13][0]), 
					   .NR(GrnPixels[14][15]), .NL(GrnPixels[14][1]), .ND(GrnPixels[15][0]), 
					   .U, .D, .R, .L, .kill(overlap)); // done
						
	normal_frogLight f13_0(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[13][0]), .NU(GrnPixels[12][0]), 
					   .NR(GrnPixels[13][15]), .NL(GrnPixels[13][1]), .ND(GrnPixels[14][0]), 
					   .U, .D, .R, .L, .kill(overlap)); // done
						
	normal_frogLight f12_0(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[12][0]), .NU(GrnPixels[11][0]), 
					   .NR(GrnPixels[12][15]), .NL(GrnPixels[12][1]), .ND(GrnPixels[13][0]), 
					   .U, .D, .R, .L, .kill(overlap));
						
	normal_frogLight f11_0(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[11][0]), .NU(GrnPixels[10][0]), 
					   .NR(GrnPixels[11][15]), .NL(GrnPixels[11][1]), .ND(GrnPixels[12][0]), 
					   .U, .D, .R, .L, .kill(overlap));
						
	normal_frogLight f10_0(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[10][0]), .NU(GrnPixels[9][0]), 
					   .NR(GrnPixels[10][15]), .NL(GrnPixels[10][1]), .ND(GrnPixels[11][0]), 
					   .U, .D, .R, .L, .kill(overlap));
						
	normal_frogLight f9_0(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[9][0]), .NU(GrnPixels[8][0]), 
					   .NR(GrnPixels[9][15]), .NL(GrnPixels[9][1]), .ND(GrnPixels[10][0]), 
					   .U, .D, .R, .L, .kill(overlap));
						
	normal_frogLight f8_0(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[8][0]), .NU(GrnPixels[7][0]), 
					   .NR(GrnPixels[8][15]), .NL(GrnPixels[8][1]), .ND(GrnPixels[9][0]), 
					   .U, .D, .R, .L, .kill(overlap));
						
	normal_frogLight f7_0(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[7][0]), .NU(GrnPixels[6][0]), 
					   .NR(GrnPixels[7][15]), .NL(GrnPixels[7][1]), .ND(GrnPixels[8][0]), 
					   .U, .D, .R, .L, .kill(overlap));
						
	normal_frogLight f6_0(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[6][0]), .NU(GrnPixels[5][0]), 
					   .NR(GrnPixels[6][15]), .NL(GrnPixels[6][1]), .ND(GrnPixels[7][0]), 
					   .U, .D, .R, .L, .kill(overlap));
						
	normal_frogLight f5_0(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[5][0]), .NU(GrnPixels[4][0]), 
					   .NR(GrnPixels[5][15]), .NL(GrnPixels[5][1]), .ND(GrnPixels[6][0]), 
					   .U, .D, .R, .L, .kill(overlap));
						
	normal_frogLight f4_0(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[4][0]), .NU(GrnPixels[3][0]), 
					   .NR(GrnPixels[4][15]), .NL(GrnPixels[4][1]), .ND(GrnPixels[5][0]), 
					   .U, .D, .R, .L, .kill(overlap));
						
	normal_frogLight f3_0(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[3][0]), .NU(GrnPixels[2][0]), 
					   .NR(GrnPixels[3][15]), .NL(GrnPixels[3][1]), .ND(GrnPixels[4][0]), 
					   .U, .D, .R, .L, .kill(overlap));
						
	normal_frogLight f2_0(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[2][0]), .NU(GrnPixels[1][0]), 
					   .NR(GrnPixels[2][15]), .NL(GrnPixels[2][1]), .ND(GrnPixels[3][0]), 
					   .U, .D, .R, .L, .kill(overlap));
						
	normal_frogLight f1_0(.clk(SYSTEM_CLOCK), .reset, .lightOn(GrnPixels[1][0]), .NU(GrnPixels[0][0]), 
					   .NR(GrnPixels[1][15]), .NL(GrnPixels[1][1]), .ND(GrnPixels[2][0]), 
					   .U, .D, .R, .L, .kill(overlap));
	
	
	/* Logic defined to behave as outputs for the
    * LFSR10, LFSR7 modules 
	 */
	logic [9:0] lfsr10;
	logic [6:0] lfsr7;
	logic click_comp;
	
	LFSR_10 random(.clock(SYSTEM_CLOCK), .reset, .lfsr(lfsr10[9:0]));
	
	comparator compareTwo(.sw(SW[8:0]), .random(lfsr10[9:0]), .true(click_comp));
	
	
	LFSR_7 help(.clock(SYSTEM_CLOCK), .reset, .lfsr(lfsr7[6:0]));
	
	/* Instances of car shifter module, with ignored rows behaving as safe 
	 * zones for the frog LED
	 */
	car_move movecar14(.clk(SYSTEM_CLOCK), .reset, .press(click_comp), .load(lfsr7[5]), .q(RedPixels[14]));
	car_move movecar13(.clk(SYSTEM_CLOCK), .reset, .press(click_comp), .load(lfsr7[1]), .q(RedPixels[13]));
	car_move movecar12(.clk(SYSTEM_CLOCK), .reset, .press(click_comp), .load(lfsr7[2]), .q(RedPixels[12]));
	car_move movecar10(.clk(SYSTEM_CLOCK), .reset, .press(click_comp), .load(lfsr7[4]), .q(RedPixels[10]));
	car_move movecar8(.clk(SYSTEM_CLOCK), .reset, .press(click_comp), .load(lfsr7[5]), .q(RedPixels[08]));					
	car_move movecar6(.clk(SYSTEM_CLOCK), .reset, .press(click_comp), .load(lfsr7[3]), .q(RedPixels[06]));
	car_move movecar5(.clk(SYSTEM_CLOCK), .reset, .press(click_comp), .load(lfsr7[1]), .q(RedPixels[05]));
	
	car_move movecar4(.clk(SYSTEM_CLOCK), .reset, .press(click_comp), .load(lfsr7[2]), .q(RedPixels[04]));
	car_move movecar3(.clk(SYSTEM_CLOCK), .reset, .press(click_comp), .load(lfsr7[5]), .q(RedPixels[03]));
	 
	car_move movecar2(.clk(SYSTEM_CLOCK), .reset, .press(click_comp), .load(lfsr7[3]), .q(RedPixels[02]));
	car_move movecar1(.clk(SYSTEM_CLOCK), .reset, .press(click_comp), .load(lfsr7[4]), .q(RedPixels[01]));
	 
	 

endmodule


/* Simulation to test top level module (DE1_SoC) */
module DE1_SoC_testbench();

	 logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	 logic [9:0]  LEDR;
    logic [3:0]  KEY;
    logic [9:0]  SW;
    logic [35:0] GPIO_1;	
    logic CLOCK_50;
	 
	 DE1_SoC dut(.*);

	 parameter CLOCK_PERIOD=100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50;
	end
	
	initial begin 
		SW[9] <= 1; repeat(1) @(posedge CLOCK_50);
		SW[9] <= 0; repeat(1) @(posedge CLOCK_50);
		
		KEY[3] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[3] <= 0; repeat(1) @(posedge CLOCK_50);
		
		KEY[2] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(1) @(posedge CLOCK_50);
		
		KEY[1] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[1] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[0] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[0] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[3] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[3] <= 0; repeat(1) @(posedge CLOCK_50);
		
		KEY[3] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[3] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[1] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[1] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[0] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[0] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[1] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[1] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[3] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[3] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[1] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[1] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[0] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[0] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[1] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[1] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[3] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[3] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[1] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[1] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[0] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[0] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[1] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[1] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[3] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[3] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[1] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[1] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[0] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[0] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[1] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[1] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 1; repeat(1) @(posedge CLOCK_50);
		KEY[2] <= 0; repeat(1) @(posedge CLOCK_50);
		repeat(1000) @(posedge CLOCK_50);
		
	$stop;
	end
	
	initial begin 
		 SW[8:0] = 9'b111111111; repeat(1100) @(posedge CLOCK_50);
	$stop;
	end
endmodule	
	
	
	
	 