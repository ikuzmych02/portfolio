`timescale 1ps/1ps
module instructionDecode(clk, instruction, PC, Uncondbranch, ALUSrc, LinkerReg, WriteData, WriteRegister, LTFlagEx, ZeroBranch, Branch, SetFlags, Store,
                         Reg2Loc, RegWriteCtrl, RegWriteWB, MemRead, MemWrite, MemToReg, ALUOp, IType, RType, BranchToReg,
                         ALUOpRegister, RegWriteRegister, MemReadRegister, MemToRegRegister, MemWriteRegister, LinkerRegisterData, SetFlagsRegister,
                         realBranchingAddr, RmReg, RnReg, RData1Reg, RdIdEx, LinkerRegIdEx, RData2Reg, BrTaken, 
                         ZeroBranchForwarding, ALUSrcRegisterID, StoreReg, ImmOrDest, ALUZeroFlagFromEx, Rm_curr);

    input logic clk;
    input logic LinkerReg, RegWriteWB, RegWriteCtrl, Reg2Loc, Uncondbranch, MemWrite, MemRead, MemToReg, BranchToReg;
    input logic IType, RType, ALUSrc, LTFlagEx, ZeroBranch, Branch, SetFlags, Store;
    input logic [63:0] WriteData, PC;
    input logic [31:0] instruction;
    input logic [2:0] ALUOp;
    input logic [4:0] WriteRegister;
    input logic ALUZeroFlagFromEx, ZeroBranchForwarding;


    output logic [63:0] realBranchingAddr;
    output logic [4:0] RmReg, RnReg, Rm_curr;
    output logic [63:0] RData1Reg, LinkerRegisterData, RData2Reg, ImmOrDest; // got rid of ALUBin
    output logic [4:0] RdIdEx; // WriteRegister to pass through the pipeline
    output logic LinkerRegIdEx, BrTaken; // WB signal

    output logic RegWriteRegister, MemReadRegister;  // WB
    output logic MemToRegRegister, MemWriteRegister; // MEM
    output logic [2:0] ALUOpRegister;
    output logic SetFlagsRegister;  // EX
    output logic ALUSrcRegisterID, StoreReg;

    logic invertclock, condBr, isZero, realZero;
    logic [63:0] ReadData1, ReadData2, branchPC;
    logic [63:0] BrCond19, UncondBrAddr26, adderInputBr, shifterInput;
    logic [63:0] PCPlusFourRegIn;
    logic [63:0] resultFromID, resultFromALUSrcMux;
    logic [4:0] RdId, ReadRegister2;

    not #50 invertClock(invertclock, clk);

    /* MUX to determine input to WriteData */
	mux2to1 #(.WIDTH(5)) writeDataMultiplexer(.select(LinkerReg), .in({instruction[4:0], 5'd30}), .out(RdId));
    resettableGenerator #(.WIDTH(5)) x30Rd(.clk, .reset(1'b0), .in(RdId), .out(RdIdEx), .en(1'b1));       // Write Register Rd or X30. Passed through to WB and forwarding unit
    assign Rm_curr = RdId;
    /* Full adder for PC + 4 for linker register */
    full_adder PcPlusFour(.in1(PC), .in2(64'd4), .out(PCPlusFourRegIn));
    resettableGenerator PcPlusFourReg(.clk, .reset(1'b0), .in(PCPlusFourRegIn), .out(LinkerRegisterData), .en(1'b1));
    valuePreserver LinkerRegister(.clk, .in(LinkerReg), .out(LinkerRegIdEx), .en(1'b1), .reset(1'b0));

    /* Logic to determine which branching we want to do */
    mux2to1_single_bit zeroLTComparison(.select(ZeroBranch), .in({realZero, LTFlagEx}), .out(condBr)); // SINGLE BIT MUX IS DIFFERENT ORDER FROM 64-BIT MUX
    and #50ps conditionalBranchMet(condBrMet, Branch, condBr);
	or #50ps prePCBranchDetermination(BrTaken, condBrMet, Uncondbranch);

    /* Mux to differentiate Rd and Rt / Rn */
	mux2to1 #(.WIDTH(5)) RdRnRt(.select(Reg2Loc), .in({instruction[4:0], instruction[20:16]}), .out(ReadRegister2));

    signextend #(.WIDTH(19)) ConditionalBranch19(.in(instruction[23:5]), .out(BrCond19)); // BrCond19
    signextend #(.WIDTH(26)) UnconditionalBranch26(.in(instruction[25:0]), .out(UncondBrAddr26)); // UncondBrAddr26

    mux2to1 branchingSize(.select(Uncondbranch), .in({BrCond19, UncondBrAddr26}), .out(shifterInput));
    // Multiply our branch address by 4 (PC increments by fours)
    shifter multBy2(.value(shifterInput), .direction(1'b0), .distance(6'd2), .result(adderInputBr));
    full_adder branchingAdder(.in1(PC), .in2(adderInputBr), .out(branchPC));
    mux2to1 brtoreg(.select(BranchToReg), .in({branchPC, ReadData2}), .out(realBranchingAddr)); // BR instruction mux

    instructionData InstructionData(.instruction, .I(IType), .R(RType), .result(resultFromID));
    resettableGenerator immediateOrDest(.clk, .reset(1'b0), .in(resultFromID), .out(ImmOrDest), .en(1'b1));
    //mux2to1 ReadData2InstructionData(.select(ALUSrc), .in({ReadData2, resultFromID}), .out(resultFromALUSrcMux));

    isZero checkRData(.result(ReadData2), .zero(isZero));
    mux2to1_single_bit realZeroValue(.select(ZeroBranchForwarding), .in({ALUZeroFlagFromEx, isZero}), .out(realZero));
    // Add these to registers:
    // Rm, Rn
    // ReadData1, ReadData2
    resettableGenerator #(.WIDTH(5)) Rm(.clk, .reset(1'b0), .in(ReadRegister2), .out(RmReg), .en(1'b1));    // Read Register 2
    resettableGenerator #(.WIDTH(5)) Rn(.clk, .reset(1'b0), .in(instruction[9:5]), .out(RnReg), .en(1'b1)); // Read Register 1

    resettableGenerator RData1(.clk, .reset(1'b0), .in(ReadData1), .out(RData1Reg), .en(1'b1));
    resettableGenerator RData2(.clk, .reset(1'b0), .in(ReadData2), .out(RData2Reg), .en(1'b1));
    //resettableGenerator BALUInput(.clk, .reset(1'b0), .in(resultFromALUSrcMux), .out(ALUBIn), .en(1'b1));

    /* ALL signal registers written by MUX outputs based on hazard detection unit */
    valuePreserver RegWriteReg(.clk, .in(RegWriteCtrl), .out(RegWriteRegister), .en(1'b1), .reset(1'b0)); // RegWrite (WB)
    valuePreserver MemToRegReg(.clk, .in(MemToReg), .out(MemToRegRegister), .en(1'b1), .reset(1'b0)); // MemToReg (WB)
    valuePreserver MemReadReg(.clk, .in(MemRead), .out(MemReadRegister), .en(1'b1), .reset(1'b0));    // MemRead (MEM)
    valuePreserver MemWriteReg(.clk, .in(MemWrite), .out(MemWriteRegister), .en(1'b1), .reset(1'b0));    // MemRead (MEM)
    
    valuePreserver SetFlagsReg(.clk, .in(SetFlags), .out(SetFlagsRegister), .en(1'b1), .reset(1'b0));
    resettableGenerator #(.WIDTH(3)) ALUOpReg(.clk, .reset(1'b0), .in(ALUOp), .out(ALUOpRegister), .en(1'b1)); // ALUOp (EX)

    valuePreserver ALUSrcReg(.clk, .in(ALUSrc), .out(ALUSrcRegisterID), .en(1'b1), .reset(1'b0)); // ALUSrc (to send to forwarding)

    valuePreserver StoreRegister(.clk, .in(Store), .out(StoreReg), .en(1'b1), .reset(1'b0)); // ALUSrc (to send to forwarding)

    regfile registerFile(.ReadData1, .ReadData2, .WriteData, .ReadRegister1(instruction[9:5]), 
                         .ReadRegister2, .WriteRegister, .RegWrite(RegWriteWB), .clk(invertclock));

endmodule

module instructionDecode_testbench();
    // Outputs
    logic clk;
    logic LinkerReg, RegWriteWB, Reg2Loc, Uncondbranch, MemWrite, MemRead, MemToReg;
    logic IType, RType, ALUSrc, RegWriteCtrl, LTFlagEx, ZeroBranch, Branch, SetFlags;
    logic [63:0] WriteData, PC;
    logic [31:0] instruction;
    logic [2:0] ALUOp;
    logic [4:0] WriteRegister;

    // Outputs
    logic [63:0] branchPC;
    logic [4:0] RmReg, RnReg;
    logic [63:0] RData1Reg, LinkerRegisterData, ALUBIn;
    logic [4:0] RdIdEx;
    logic isZero, LinkerRegIdEx, BrTaken;
    logic RegWriteRegister, MemReadRegister;  // WB
    logic MemToRegRegister, MemWriteRegister; // MEM
    logic [2:0] ALUOpRegister, SetFlagsRegister;  // EX
    logic ALUSrcRegisterID;

    instructionDecode dut(.*);

    initial begin
		clk = 1;
		forever #2000 clk = ~clk;
	end // initial

    initial begin
        instruction <= 32'b1001000100_000000000000_11111_00000; WriteData <= 64'd160; PC <= 64'd12; LinkerReg <= 1'b0; 
        RegWriteWB <= 1'b1; Reg2Loc <= 1'b0; Uncondbranch <= 1'b0; MemWrite <= 1'b0; MemRead <= 1'b0; MemToReg <= 1'b0;
        IType <= 1'b0; RType <= 1'b0; ALUOp <= 3'b010; WriteRegister <= 5'd4; ALUSrc <= 1'b1; RegWriteCtrl <= 1'b1; ZeroBranch <= 1'b0; Branch <= 1'b0;
                    repeat(12) @(posedge clk);  // ADDI X0, X31, #0
    $stop;
    end

endmodule

// NEED TO ADD THE ZERO BRANCH LOGIC FOR THE PC + BRANCH ADDR FULL ADDER // 
// NEED TO ADD LESS THAN BRANCHING LOGIC + LESS THAN REGISTER (IN EXECUTE?) //