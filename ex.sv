`timescale 1ps/1ps
module execute(clk, ReadData1, ReadData2, WriteRegID, ALUOp, SetFlagFromID, DataMemWB, WriteBackWB, ForwCntrl1, ForwCntrl2, // EXECUTION NECESSARY INPUTS
               LinkerRegisterDataID, RegWriteRegisterID, MemToRegRegisterID, LinkerRegIdEx,         // WB FLAG REGISTERS
               MemWriteRegisterID, MemReadRegisterID,                                               // MEM FLAG REGISTERS
               ALUSrcID, ImmOrDestID,
               LinkerRegisterDataEX, MemToRegRegisterEX, LinkerRegEX, RegWriteRegisterEX,           // WB FLAG REGISTERS FOR NEXT STAGE
               MemWriteRegisterEX, MemReadRegisterEX,                                               // MEM FLAG REGISTERS FOR NEXT STAGE
               RdData2ForMem, ALUResultEx, LTFlagRegister, WriteRegEX, ALUZeroFlag); // OUTPUTS

    input logic clk;
    input logic SetFlagFromID;
    input logic [63:0] ReadData1, ReadData2, DataMemWB, WriteBackWB; 
    input logic [1:0] ForwCntrl1, ForwCntrl2;
    input logic [2:0] ALUOp;
    input logic [4:0] WriteRegID;
    input logic ALUSrcID;
    input logic [63:0] ImmOrDestID;

    // MEM and WB register inputs
    input logic [63:0] LinkerRegisterDataID; // PC + 4
    input logic MemToRegRegisterID, LinkerRegIdEx, RegWriteRegisterID; // MemToReg, LinkerReg, RegWrite
    input logic MemWriteRegisterID, MemReadRegisterID; // MemWrite, MemRead

    output logic [63:0] ALUResultEx, RdData2ForMem; // ALU output, ReadData2 from RegFile
    output logic [4:0] WriteRegEX;
    output logic LTFlagRegister;

    // MEM and WB register output
    output logic [63:0] LinkerRegisterDataEX; // PC + 4
    output logic MemToRegRegisterEX, LinkerRegEX, RegWriteRegisterEX; // MemToReg, LinkerReg, RegWrite
    output logic MemWriteRegisterEX, MemReadRegisterEX; // MemWrite, MemRead
    output logic ALUZeroFlag;

    logic [63:0] ALUinA, ALUinB, RdAndImmMux;
    logic [63:0] result;
    logic negative, zero, overflow, carry_out;

    mux4to1 AluA(.select(ForwCntrl1), .in({ReadData1, WriteBackWB, DataMemWB, 64'd0}), .out(ALUinA));
    mux4to1 AluB(.select(ForwCntrl2), .in({ReadData2, WriteBackWB, DataMemWB, 64'd0}), .out(RdAndImmMux));
    mux2to1 RdDataAndImm(.select(ALUSrcID), .in({RdAndImmMux, ImmOrDestID}), .out(ALUinB));


    alu ExecutionALU(.A(ALUinA), .B(ALUinB), .cntrl(ALUOp), .result, .negative, .zero, .overflow, .carry_out);
    assign ALUZeroFlag = zero;

    /* logic to determine the LT flag */
    xor #50ps LessThan(xorLT, negative, overflow);
    //logic invertedclock;
    //not #50 invClock(invertedclock, clk);
    assign LTFlagRegister = xorLT;
    //valuePreserver LessThanFlagRegister(.clk(invertedclock), .in(xorLT), .out(LTFlagRegister), .en(SetFlagFromID), .reset(1'b0)); //  LT Flag register

    resettableGenerator ALUResultRegister(.clk, .reset(1'b0), .in(result), .out(ALUResultEx), .en(1'b1));                // ALU output. Goes into stage register
    resettableGenerator DataMemData(.clk, .reset(1'b0), .in(RdAndImmMux), .out(RdData2ForMem), .en(1'b1));                 // ReadData2 from Register file, goes into Data Memory data port
    resettableGenerator #(.WIDTH(5)) WriteRegisterReg(.clk, .reset(1'b0), .in(WriteRegID), .out(WriteRegEX), .en(1'b1)); // for writeback


    resettableGenerator LinkerRegPC(.clk, .reset(1'b0), .in(LinkerRegisterDataID), .out(LinkerRegisterDataEX), .en(1'b1)); // PC + 4 register
    valuePreserver MemToRegEX(.clk, .in(MemToRegRegisterID), .out(MemToRegRegisterEX), .en(1'b1), .reset(1'b0));           // MemToReg
    valuePreserver LinkerRegCntrlSignal(.clk, .in(LinkerRegIdEx), .out(LinkerRegEX), .en(1'b1), .reset(1'b0));             // LinkerReg
    valuePreserver RegWriteCntrlSignal(.clk, .in(RegWriteRegisterID), .out(RegWriteRegisterEX), .en(1'b1), .reset(1'b0));  // RegWrite
    valuePreserver MemWriteCntrlSignal(.clk, .in(MemWriteRegisterID), .out(MemWriteRegisterEX), .en(1'b1), .reset(1'b0));  // MemWrite
    valuePreserver MemReadCntrlSignal(.clk, .in(MemReadRegisterID), .out(MemReadRegisterEX), .en(1'b1), .reset(1'b0));     // MemRead

endmodule

/* execute testbench */
module execute_testbench();
    logic clk;
    logic SetFlagFromID;
    logic [63:0] ReadData1, ReadData2, ALUB, DataMemWB, WriteBackWB; 
    logic [1:0] ForwCntrl1, ForwCntrl2;
    logic [2:0] ALUOp;
    logic [4:0] WriteRegID;

    // MEM and WB register inputs
    logic [63:0] LinkerRegisterDataID; // PC + 4
    logic MemToRegRegisterID, LinkerRegIdEx, RegWriteRegisterID; // MemToReg, LinkerReg, RegWrite
    logic MemWriteRegisterID, MemReadRegisterID; // MemWrite, MemRead

    logic [63:0] ALUResultEx, RdData2ForMem; // ALU output, ReadData2 from RegFile
    logic [4:0] WriteRegEX;
    logic LTFlagRegister;

    // MEM and WB register output
    logic [63:0] LinkerRegisterDataEX; // PC + 4
    logic MemToRegRegisterEX, LinkerRegEX, RegWriteRegisterEX; // MemToReg, LinkerReg, RegWrite
    logic MemWriteRegisterEX, MemReadRegisterEX; // MemWrite, MemRead

    execute dut(.*);

    initial begin
		clk = 1;
		forever #2000 clk = ~clk;
	end // initial

    initial begin
        SetFlagFromID <= 1'b1; ReadData1 <= 64'd12; ALUB <= 64'd4; DataMemWB <= 64'd45; WriteBackWB <= 64'd99;
        ForwCntrl1 <= 2'b00; ForwCntrl2 <= 2'b00; ALUOp <= 3'b010; WriteRegID <= 5'd12;
        LinkerRegisterDataID <= 64'd12; MemToRegRegisterID <= 1'b1; LinkerRegIdEx <= 1'b1; RegWriteRegisterID <= 1'b1;
        MemWriteRegisterID <= 1'b0; MemReadRegisterID <= 1'b0; repeat(2) @(posedge clk);
    $stop;
    end

endmodule
