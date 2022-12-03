`timescale 1ps/1ps
/**
 *
 * Module responsible for all the program counter values
 *
 */
module programCounter(clk, reset, CondAddr19, BrAddr26, UncondBr, BrTaken, BranchToReg, RegAddress, PCPlusFour, PC);
    input logic clk, reset, UncondBr, BrTaken, BranchToReg;
    input logic [25:0] BrAddr26;
    input logic [18:0] CondAddr19;
    input logic [63:0] RegAddress;
    output logic [63:0] PC;
    output logic [63:0] PCPlusFour;

    logic [63:0] signExtendedBrAddr, signExtendedCondAddr;
    logic [63:0] mux1Out, shifterOutput, topAdderOut, standardPC;
    logic [63:0] truePC;
    logic [63:0] BrAddress;

    assign PCPlusFour = standardPC;

    /* Register to store out 64-bit program counter value */
    resettableGenerator makePC(.clk, .reset, .in(truePC), .out(PC), .en(1'b1));

    //
    // Sign-extended conditional and unconditional branch addresses
    //
    signextend #(.WIDTH(19))  CondAddr(.in(CondAddr19), .out(signExtendedCondAddr));
    signextend #(.WIDTH(26))  BrAddr(.in(BrAddr26), .out(signExtendedBrAddr));
    
    //
    // UnconditionalBranch multiplexer to determinie which one of these we want to do
    //
    mux2to1 branchAddresses(.select(UncondBr), .in({signExtendedCondAddr, signExtendedBrAddr}), .out(mux1Out)); // swapped them. keep this in mind

    //
    // Multiply our branch address by 4 (PC increments by fours)
    //
    shifter shiftRightLogic(.value(mux1Out), .direction(1'b0), .distance(6'd2), .result(shifterOutput));

    //
    // Two full adders from the datapath to get our new program counter value after each cycle
    //
    full_adder topAdder(.in1(shifterOutput), .in2(PC), .out(topAdderOut));
    full_adder bottomAdder(.in1(64'd4), .in2(PC), .out(standardPC));

    //
    // Obtain our true program counter value based on BrTaken flag
    //
    mux2to1 adders(.select(BrTaken), .in({standardPC, BrAddress}), .out(truePC));

    //
    // Determine if we are doing a BR instruction (branch to register value)
    //
    mux2to1 BRMux(.select(BranchToReg), .in({topAdderOut, RegAddress}), .out(BrAddress));
endmodule

/*program counter testbench */
module programCounter_testbench();
    logic clk, reset, UncondBr, BrTaken, BranchToReg;
    logic [25:0] BrAddr26;
    logic [18:0] CondAddr19;
    logic [63:0] PC, RegAddress;
    logic [63:0] PCPlusFour;


    programCounter dut(.*);
    
    assign BrAddr26 = -26'd8;
    assign CondAddr19 = 19'd12;
    assign RegAddress = 64'd6;

    initial begin
		clk = 1;
		forever #2000 clk = ~clk;
	end // initial

    initial begin
        reset <= 1; BrTaken <= 0; UncondBr <= 0; BranchToReg <= 0; @(posedge clk);
        reset <= 0; repeat(10) @(posedge clk);
        BranchToReg <= 1; repeat(2) @(posedge clk);
        BranchToReg <= 0; UncondBr <= 1; repeat(2) @(posedge clk);
        BranchToReg <= 0; repeat(2) @(posedge clk);
        UncondBr <= 0; BrTaken <= 1; repeat(2) @(posedge clk);
        BranchToReg <= 1; repeat(2) @(posedge clk);
        BranchToReg <= 0; UncondBr <= 1; repeat(2) @(posedge clk);
        BranchToReg <= 1; repeat(2) @(posedge clk);
    $stop;
    end

endmodule