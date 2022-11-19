`timescale 1ps/1ps

/**
 *
 * Module to take care of all data that is taken from the instruction bits
 *
 */
module instructionData(instruction, I, R, result);
    input logic [31:0] instruction;
    input logic I, R;
    output logic [63:0] result;

    logic [63:0] signExtendedDAddr;
    logic [63:0] zeroExtendedShiftAmt;
    logic [63:0] zeroExtendedImm12;

    logic [63:0] mux1Out;
    //
    // Logic to set up the data that comes out of the 32-bit instructions
    //
    zeroextend #(.WIDTH(6)) shiftAmt(.in(instruction[15:10]), .out(zeroExtendedShiftAmt));
    zeroextend #(.WIDTH(12)) Imm12(.in(instruction[21:10]), .out(zeroExtendedImm12));
    signextend #(.WIDTH(9))  DAddr9(.in(instruction[20:12]), .out(signExtendedDAddr));

    // 2 64-bit 2:1 mux
    mux2to1 DAddr9AndShiftAmt(.select(R), .in({signExtendedDAddr, zeroExtendedShiftAmt}), .out(mux1Out));
    mux2to1 Imm12AndOther(.select(I), .in({mux1Out, zeroExtendedImm12}), .out(result));

endmodule

module instructionData_testbench();
    logic [31:0] instruction;
    logic I, R;
    logic [63:0] result;

    instructionData dut(.*);
    assign instruction = 32'b11010011010100010010100000000000;

    initial begin
        I = 1'b1; R = 1'b0; #1000; // ADDI
        I = 1'b1; R = 1'b1; #1000;// ADDI
        I = 1'b1; R = 1'bx; #1000;// ADDI
        I = 1'b0; R = 1'b0; #1000;// B or B.cond
        I = 1'b0; R = 1'b1; #1000;// shift

        I = 1'bx; R = 1'bx; #1000;// result does not matter
    end

endmodule