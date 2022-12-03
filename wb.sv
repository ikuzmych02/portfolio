`timescale 1ps/1ps
module writeBack(LinkerRegMEM, MemToRegMEM, readDataMem, LinkerRegisterDataMEM, ALUResultMem, FinalWriteData);
    input logic LinkerRegMEM, MemToRegMEM; // RegWrite to be pulled out of memstage registers
    input logic [63:0] readDataMem, LinkerRegisterDataMEM, ALUResultMem;

    output logic [63:0] FinalWriteData;

    logic [63:0] finalMuxIn;

    mux2to1 memtoregistermux(.select(MemToRegMEM), .in({finalMuxIn, readDataMem}), .out(FinalWriteData));                 // MemToReg mux
    mux2to1 ALUandLinkerRegisterMux(.select(LinkerRegMEM), .in({ALUResultMem, LinkerRegisterDataMEM}), .out(finalMuxIn)); // LinkerReg mux

endmodule

module writeBack_testbench();
    logic LinkerRegMEM, MemToRegMEM; // RegWrite to be pulled out of memstage registers
    logic [63:0] readDataMem, LinkerRegisterDataMEM, ALUResultMem;

    logic [63:0] FinalWriteData;

    writeBack dut(.*);

    initial begin
        LinkerRegMEM = 1'b1; MemToRegMEM = 1'b0; readDataMem = 64'd12; LinkerRegisterDataMEM = 64'd99; ALUResultMem = 64'd155; #2000;
    end

endmodule
