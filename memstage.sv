`timescale 1ps/1ps
module memoryStage(clk, ALUResultEx, RdData2ForMem, LinkerRegisterDataEX,
                   LinkerRegEX, MemToRegEX, RegWriteRegisterEX, MemWriteRegisterEX, MemReadRegisterEX, WriteRegEX, // MEM and WB signals from EX stage
                   readDataMem, ALUResultMem, WriteRegMEM, LinkerRegisterDataMEM,
                   RegWriteRegisterMEM, MemToRegMEM, LinkerRegMEM);

    input logic clk;
    input logic [63:0] ALUResultEx, RdData2ForMem, LinkerRegisterDataEX; // ALU Result is the address in data memory, RdData2 = Read Data 2. Write data for data memory
    input logic LinkerRegEX, MemToRegEX, RegWriteRegisterEX, MemWriteRegisterEX, MemReadRegisterEX; // MEM registers from the WB stage
    input logic [4:0] WriteRegEX;

    output logic [63:0] readDataMem, ALUResultMem, LinkerRegisterDataMEM;
    output logic [4:0] WriteRegMEM;
    output logic RegWriteRegisterMEM, MemToRegMEM;
    output logic LinkerRegMEM;

    logic [63:0] read_data;

    datamem dataMemory(.address(ALUResultEx), .write_enable(MemWriteRegisterEX), .read_enable(MemReadRegisterEX),
							.write_data(RdData2ForMem), .clk, .xfer_size(4'b1000), .read_data);

    resettableGenerator memReadDataRegister(.clk, .reset(1'b0), .in(read_data), .out(readDataMem), .en(1'b1));             // Data memory output register
    resettableGenerator ALUResultRegisterFromEXStage(.clk, .reset(1'b0), .in(ALUResultEx), .out(ALUResultMem), .en(1'b1)); // ALU result register
    resettableGenerator linkerRegFromEX(.clk, .reset(1'b0), .in(LinkerRegisterDataEX), .out(LinkerRegisterDataMEM), .en(1'b1));     // Linker Register (PC + 4)

    valuePreserver linkerRegCntrlSignalFromEx(.clk, .in(LinkerRegEX), .out(LinkerRegMEM), .en(1'b1), .reset(1'b0));                 // LinkerReg cntrl signal
    valuePreserver MemToRegCntrlSignalFromEx(.clk, .in(MemToRegEX), .out(MemToRegMEM), .en(1'b1), .reset(1'b0));                   // MemToReg cntrl signal
    valuePreserver RegWriteCntrlSignalFromEx(.clk, .in(RegWriteRegisterEX), .out(RegWriteRegisterMEM), .en(1'b1), .reset(1'b0));   // RegWrite cntrl signal


    resettableGenerator #(.WIDTH(5)) WriteRegisterFromEX(.clk, .reset(1'b0), .in(WriteRegEX), .out(WriteRegMEM), .en(1'b1)); // Write Register (5 bits)

endmodule


module memoryStage_testbench();
    logic clk;
    logic [63:0] ALUResultEx, RdData2ForMem, LinkerRegisterDataEX; // ALU Result is the address in data memory, RdData2 = Read Data 2. Write data for data memory
    logic LinkerRegEX, MemToRegEX, RegWriteRegisterEX, MemWriteRegisterEX, MemReadRegisterEX; // MEM registers from the WB stage
    logic [4:0] WriteRegEX;

    logic [63:0] readDataMem, ALUResultMem, WriteRegMEM, LinkerRegisterDataMEM;
    logic RegWriteRegisterMEM, MemToRegMEM;
    logic LinkerRegMEM;

    memoryStage dut(.*);

    initial begin
		clk = 1;
		forever #2000 clk = ~clk;
	end // initial

    initial begin
        ALUResultEx <= 64'd10; RdData2ForMem <= 64'd11; LinkerRegisterDataEX <= 64'd20;
        LinkerRegEX <= 1'b0; MemToRegEX <= 1'b0; RegWriteRegisterEX <= 1'b1; MemWriteRegisterEX <= 1'b1; MemReadRegisterEX <= 1'b0;
        WriteRegEX <= 5'd1; repeat(2) @(posedge clk);
    $stop;
    end
 
endmodule


