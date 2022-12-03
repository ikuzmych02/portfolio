/**
 *
 * IF/ID register
 *
 */
`timescale 1ps/1ps
module instructionFetch(clk, reset, BrTaken, branchPC, instructionStageOut, pcStageOut);
    input logic clk, reset;
    input logic BrTaken;

    input logic [63:0] branchPC;

    output logic [63:0] pcStageOut;
    output logic [31:0] instructionStageOut;

    logic [63:0] currPC, muxInPC, PC;
    logic [31:0] currentInstruction;

    mux2to1 choosePC(.select(BrTaken), .in({muxInPC, branchPC}), .out(PC));
    resettableGenerator programCounter(.clk, .reset, .in(PC), .out(currPC), .en(1'b1));
    instructmem instructionMemory(.address(currPC), .instruction(currentInstruction), .clk);

    full_adder pc(.in1(currPC), .in2(64'd4), .out(muxInPC));

    resettableGenerator programCountRegister(.clk, .reset, .in(currPC), .out(pcStageOut), .en(1'b1));
    resettableGenerator #(.WIDTH(32)) currentInstructionRegister(.clk, .reset, .in(currentInstruction), .out(instructionStageOut), .en(1'b1));

endmodule

/**/
module instructionFetch_testbench();
    logic clk, reset;
    logic BrTaken;
    logic [63:0] branchPC;
    logic [63:0] pcStageOut;
    logic [31:0] instructionStageOut;

    instructionFetch dut(.*);

    initial begin
		clk = 1;
		forever #2000 clk = ~clk;
	end // initial

    assign branchPC = 64'd24;

    initial begin
        reset <= 1; BrTaken <= 0; @(posedge clk);
        reset <= 0;    repeat(10) @(posedge clk);
        BrTaken <= 1;  repeat(4)  @(posedge clk);
    $stop;    
    end


endmodule
