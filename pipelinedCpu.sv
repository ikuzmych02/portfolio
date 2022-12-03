`timescale 1ps/1ps
module pipelinedCPU(clk, reset);
    input logic clk, reset;

    // instruction fetch
    logic [31:0] ifInstruction;
    logic [63:0] ifPC;
    logic [63:0] idBranchPC;
    logic BrTaken;
    logic Reg2Loc, Uncondbranch, Branch, MemRead, MemToReg, MemWrite, 
          ALUSrc, RegWrite, IType, RType, SetFlags, ZeroBranch, BranchToReg, PcToReg, LinkerReg, Store;
    logic [2:0] ALUOp;

    // Instruction decode
    logic [2:0] ALUOpRegisterID;
    logic RegWriteID, MemReadID, MemToRegID, MemWriteID, SetFlagsID, LinkerRegID, ALUSrcID, StoreRegID;
    logic [63:0] LinkerRegDataID, ReadData1ID, ReadData2ID, AluBInID, ImmOrDestID;
    logic [4:0] RmRegID, RnRegID, RdRegID;

    // Instruction execute
    logic [63:0] LinkerRegDataEX, RdData2ForMemEX, ALUResultEX;
    logic MemToRegEX, LinkerRegEX, RegWriteEX, MemWriteEX, MemReadEX, LTFlagEX;
    logic [4:0] RdRegEX;
    logic ALUZeroFlag;

    // Instruction ex/mem stage
    logic [63:0] readDataMem;
    logic [63:0] ALUResultMEM, LinkerRegDataMEM;
    logic [4:0] RdRegMEM;
    logic RegWriteMEM, MemToRegMEM, LinkerRegMEM;

    // mem/wb stage
    logic [63:0] finalWriteData;

    // Forwarding unit
    logic [1:0] forwardControl1, forwardControl2;
    logic ZeroBranchForwarding;
    logic [4:0] Rm_curr;

    control mainController(.opcode(ifInstruction[31:21]), .Reg2Loc, .Uncondbranch, .Branch, .MemRead, .MemToReg, .ALUOp, .MemWrite, .ALUSrc, 
                           .RegWrite, .IType, .RType, .SetFlags, .ZeroBranch, .BranchToReg, .PcToReg, .LinkerReg, .Store); // finished hook-up

    instructionFetch ifToId(.clk, .reset, .BrTaken, .branchPC(idBranchPC), .instructionStageOut(ifInstruction), .pcStageOut(ifPC)); // finished hook-up

    instructionDecode idStage(.clk, .instruction(ifInstruction), .PC(ifPC), .Uncondbranch, .ALUSrc, .LinkerReg, .Store,
                              .WriteData(finalWriteData), .WriteRegister(RdRegMEM), .LTFlagEx(LTFlagEX), .ZeroBranch, .Branch, .SetFlags,
                              .Reg2Loc, .RegWriteCtrl(RegWrite), .RegWriteWB(RegWriteMEM), .MemRead, .MemWrite, .MemToReg, .ALUOp, .IType, .RType, .BranchToReg,
                              .ALUOpRegister(ALUOpRegisterID), .RegWriteRegister(RegWriteID), .MemReadRegister(MemReadID), .MemToRegRegister(MemToRegID), 
                              .MemWriteRegister(MemWriteID), .LinkerRegisterData(LinkerRegDataID), .SetFlagsRegister(SetFlagsID),
                              .realBranchingAddr(idBranchPC), .RmReg(RmRegID), .RnReg(RnRegID), .RData1Reg(ReadData1ID), 
                              .RdIdEx(RdRegID), .LinkerRegIdEx(LinkerRegID), .RData2Reg(ReadData2ID), 
                              .BrTaken, .ALUSrcRegisterID(ALUSrcID), .StoreReg(StoreRegID), .ImmOrDest(ImmOrDestID), 
                              .ALUZeroFlagFromEx(ALUZeroFlag), .ZeroBranchForwarding, .Rm_curr);

    execute executeStage(.clk, .ReadData1(ReadData1ID), .ReadData2(ReadData2ID), .WriteRegID(RdRegID), .ALUOp(ALUOpRegisterID), .SetFlagFromID(SetFlagsID), 
                         .DataMemWB(ALUResultEX), .WriteBackWB(finalWriteData), .ForwCntrl1(forwardControl1), .ForwCntrl2(forwardControl2), // FORWARDING UNIT INPUTS (from fw unit)
                         .LinkerRegisterDataID(LinkerRegDataID), .RegWriteRegisterID(RegWriteID), .MemToRegRegisterID(MemToRegID), .LinkerRegIdEx(LinkerRegID),
                         .MemWriteRegisterID(MemWriteID), .MemReadRegisterID(MemReadID),                      // MEM FLAG REGISTER INPUTS FROM INSTRUCTION DECODE
                         .ALUSrcID(ALUSrcID), .ImmOrDestID(ImmOrDestID),
                         .LinkerRegisterDataEX(LinkerRegDataEX), .MemToRegRegisterEX(MemToRegEX), .LinkerRegEX(LinkerRegEX), .RegWriteRegisterEX(RegWriteEX),
                         .MemWriteRegisterEX(MemWriteEX), .MemReadRegisterEX(MemReadEX),                      // MEM FLAG REGISTERS FOR NEXT STAGE
                         .RdData2ForMem(RdData2ForMemEX), .ALUResultEx(ALUResultEX), .LTFlagRegister(LTFlagEX), .WriteRegEX(RdRegEX), .ALUZeroFlag);

    memoryStage memStage(.clk, .ALUResultEx(ALUResultEX), .RdData2ForMem(RdData2ForMemEX), .LinkerRegisterDataEX(LinkerRegDataEX),
                         .LinkerRegEX(LinkerRegEX), .MemToRegEX(MemToRegEX), .RegWriteRegisterEX(RegWriteEX), 
                         .MemWriteRegisterEX(MemWriteEX), .MemReadRegisterEX(MemReadEX), .WriteRegEX(RdRegEX),
                         .readDataMem(readDataMem), .ALUResultMem(ALUResultMEM), .WriteRegMEM(RdRegMEM), .LinkerRegisterDataMEM(LinkerRegDataMEM),
                         .RegWriteRegisterMEM(RegWriteMEM), .MemToRegMEM(MemToRegMEM), .LinkerRegMEM(LinkerRegMEM));

    writeBack wbStage(.LinkerRegMEM(LinkerRegMEM), .MemToRegMEM(MemToRegMEM), 
                      .readDataMem(readDataMem), .LinkerRegisterDataMEM(LinkerRegDataMEM), 
                      .ALUResultMem(ALUResultMEM), .FinalWriteData(finalWriteData));


    forwardingUnit fwLogic(.RegWriteRegisterEX(RegWriteEX), .RegWriteRegisterMEM(RegWriteMEM), .StoreRegID(StoreRegID), .ZeroBranch,
                           .ALUSrcID(ALUSrcID), .WriteRegEX(RdRegEX), .WriteRegMEM(RdRegMEM), 
                           .RnReg(RnRegID), .RmReg(RmRegID), .Rm_curr, .Rd_curr(RdRegID),
                           .forwardCntrlA(forwardControl1), .forwardCntrlB(forwardControl2), .ZeroBranchForwarding);
endmodule

module pipelined_testbench();
    logic clk, reset;

    pipelinedCPU dut(.*);
    
    initial begin
		clk = 1;
		forever #10000 clk = ~clk;
	end // initial

    initial begin
        reset <= 1; @(posedge clk);
        reset <= 0; repeat(500) @(posedge clk);
    $stop;
    end


endmodule
