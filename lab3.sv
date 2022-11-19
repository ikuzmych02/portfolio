`timescale 1ps/1ps
/**
 *
 * Single cycle CPU module. Only inputs are a clk and a reset
 * All outputs are determined internally, as there is no necessity
 * for an external output of any kind.
 * Entire datapath flow is built and generated in this module
 *
 */
module lab3(clk, reset); 
	input logic clk, reset;

	logic [31:0] currInstruction;
	logic [63:0] PC;
	logic Reg2Loc, Uncondbranch, Branch, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite, IType, RType, SetFlags, ZeroBranch, BranchToReg, PcToReg, LinkerReg;
	logic [2:0] ALUOp;
	logic logicLT, xorLT, condBr, condBrMet, BrTaken; //logicZero
	logic negative, zero, overflow, carry_out;

	logic [63:0] ReadData1, ReadData2, WriteData;
	logic [4:0] ReadRegister2;

	logic [63:0] instructionDataOutput, ALUBInput;

	logic [63:0] ALUResult, MemoryReadData, PCPlusFour, PCALUMuxOut;

	logic [4:0] WriteRegister;

	/* MUX to determine input to WriteData */
	mux2to1 #(.WIDTH(5)) writeDataMultiplexer(.select(LinkerReg), .in({currInstruction[4:0], 5'd30}), .out(WriteRegister));

	/* MUX to determine output between ALU and program counter */
	mux2to1 PcToRegisterMultiplexer(.select(PcToReg), .in({ALUResult, PCPlusFour}), .out(PCALUMuxOut));

	/* Create instance of our instruction memory */
	instructmem  instructionMemory(.address(PC), .instruction(currInstruction), .clk);
	programCounter progCount(.clk, .reset, .CondAddr19(currInstruction[23:5]), .BrAddr26(currInstruction[25:0]), 
							 .UncondBr(Uncondbranch), .BrTaken, .BranchToReg, .RegAddress(ALUResult), .PCPlusFour, .PC);

	/* Instance of the main control block */
	control mainController(.opcode(currInstruction[31:21]), .Reg2Loc, .Uncondbranch, .Branch, .MemRead, .MemToReg, 
							.ALUOp, .MemWrite, .ALUSrc, .RegWrite, .IType, .RType, .SetFlags, .ZeroBranch, .BranchToReg, .PcToReg, .LinkerReg);

	/* Large blocks in the data path. The register file, the ALU, and the data memory are all instantiated below */
	regfile MainRegFile(.ReadData1, .ReadData2, .WriteData, .ReadRegister1(currInstruction[9:5]), .ReadRegister2, .WriteRegister, .RegWrite, .clk);
	alu MainALUblock(.A(ReadData1), .B(ALUBInput), .cntrl(ALUOp), .result(ALUResult), .negative, .zero, .overflow, .carry_out); // output of result goes into mux with data memory output
	datamem DataMemoryBlock(.address(ALUResult), .write_enable(MemWrite), .read_enable(MemRead), 
							.write_data(ReadData2), .clk, .xfer_size(4'b1000), .read_data(MemoryReadData));

	/* Mux to determine output of last operations in the datapath */
	mux2to1 ALUDMOutput(.select(MemToReg), .in({PCALUMuxOut, MemoryReadData}), .out(WriteData));

	/* Mux to differentiate Rd and Rt / Rn */
	mux2to1 #(.WIDTH(5)) RdRnRt(.select(Reg2Loc), .in({currInstruction[4:0], currInstruction[20:16]}), .out(ReadRegister2));

	/* Mux to determine B input to ALU */
	instructionData instInformation(.instruction(currInstruction), .I(IType), .R(RType), .result(instructionDataOutput));
	mux2to1 ALUBIn(.select(ALUSrc), .in({ReadData2, instructionDataOutput}), .out(ALUBInput));


	/* Responsible for setting LT / Zero flags for conditional branching */
	xor #50ps LessThan(xorLT, negative, overflow);
	//valuePreserver forZero(.clk, .in(zero), .out(logicZero), .en(SetFlags), .reset);
	valuePreserver LT(.clk, .in(xorLT), .out(logicLT), .en(SetFlags), .reset);

	/* logic to determine branching patterns/reasons */
	mux2to1_single_bit zeroLTCompare(.select(ZeroBranch), .in({zero, logicLT}), .out(condBr));
	and #50ps conditionalBranchMet(condBrMet, Branch, condBr);
	or #50ps prePCBranchDetermination(BrTaken, condBrMet, Uncondbranch);

endmodule
 

/* top-level testbench of everything */
module main_testbench();
	logic clk, reset;

	lab3 dut(.*);

	initial begin
		clk = 1;
		forever #5000 clk = ~clk;
	end // initial

	initial begin
		reset <= 1; @(posedge clk);
		reset <= 0; repeat(35) @(posedge clk);
	$stop;
	end

endmodule

