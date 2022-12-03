`timescale 1ps/1ps
/**
 *
 * Module that determines control outputs for the entire CPU for each separate instruction
 *
 */

module control(opcode, Reg2Loc, Uncondbranch, Branch, MemRead, MemToReg, ALUOp, MemWrite, ALUSrc, RegWrite, IType, RType, 
               SetFlags, ZeroBranch, BranchToReg, PcToReg, LinkerReg, Store);
    input logic [10:0] opcode;
    output logic Reg2Loc, Uncondbranch, Branch, MemRead, IType, RType; // IType is true if we use the 12-bit immediate, 0 if we use DT_address
    output logic MemToReg, MemWrite, ALUSrc, RegWrite, SetFlags, ZeroBranch, BranchToReg, PcToReg, LinkerReg, Store;
    output logic [2:0] ALUOp;

    always_comb begin
        casez(opcode)
            11'b1001000100?: begin // ADDI
                                    Reg2Loc = 1'b0; // don't care
                                    Uncondbranch = 1'b0;
                                    Branch = 1'b0;
                                    MemRead = 1'b0;
                                    MemToReg = 1'b0;
                                    ALUOp = 3'b010; // ADD
                                    MemWrite = 1'b0;
                                    ALUSrc = 1'b1; // output from MUX which takes zero-eXtended IType number
                                    RegWrite = 1'b1;
                                    IType = 1'b1;
                                    RType = 1'bX;
                                    SetFlags = 1'b0;
                                    ZeroBranch = 1'b1;
                                    BranchToReg = 1'bx;
                                    PcToReg = 1'b0;
                                    LinkerReg = 1'b0;
                                    Store = 1'b0;
                             end // begin 
            11'b10101011000: begin // ADDS
                                    Reg2Loc = 1'b1;
                                    Uncondbranch = 1'b0;
                                    Branch = 1'b0;
                                    MemRead = 1'b0;
                                    MemToReg = 1'b0;
                                    ALUOp = 3'b010; // ADD
                                    MemWrite = 1'b0;
                                    ALUSrc = 1'b0; // output from regfile
                                    RegWrite = 1'b1;
                                    IType = 1'bX;
                                    RType = 1'bX;
                                    SetFlags = 1'b1;
                                    ZeroBranch = 1'bx;
                                    BranchToReg = 1'bx;
                                    PcToReg = 1'b0;
                                    LinkerReg = 1'b0;
                                    Store = 1'b0;
                             end // begin 
            11'b100101?????: begin // BL
                                    Reg2Loc = 1'bX; // don't care
                                    Uncondbranch = 1'b1;
                                    Branch = 1'b1;
                                    MemRead = 1'b0;
                                    MemToReg = 1'b0;
                                    ALUOp = 3'bXXX; // DO NOT CARE
                                    MemWrite = 1'b0;
                                    ALUSrc = 1'bX;
                                    RegWrite = 1'b1;
                                    IType = 1'bX;
                                    RType = 1'bX;
                                    SetFlags = 1'b0;
                                    ZeroBranch = 1'bx;
                                    BranchToReg = 1'b0;
                                    PcToReg = 1'b1;
                                    LinkerReg = 1'b1;
                                    Store = 1'b0;
                             end // begin 
            11'b11010110000: begin // BR
                                    Reg2Loc = 1'b0;
                                    Uncondbranch = 1'b1;
                                    Branch = 1'b1;
                                    MemRead = 1'b0;
                                    MemToReg = 1'b0;
                                    ALUOp = 3'b000; // PASS B
                                    MemWrite = 1'b0;
                                    ALUSrc = 1'b0;
                                    RegWrite = 1'b0;
                                    IType = 1'bX;
                                    RType = 1'bX;
                                    SetFlags = 1'b0;
                                    ZeroBranch = 1'b0;
                                    BranchToReg = 1'b1;
                                    PcToReg = 1'bx;
                                    LinkerReg = 1'bx;
                                    Store = 1'b0;
                             end // begin 
            11'b10001010000: begin // AND
                                    Reg2Loc = 1'b1; // don't care
                                    Uncondbranch = 1'b0;
                                    Branch = 1'b0;
                                    MemRead = 1'b0;
                                    MemToReg = 1'b0;
                                    ALUOp = 3'b100; // AND
                                    MemWrite = 1'b0;
                                    ALUSrc = 1'b0;
                                    RegWrite = 1'b1;
                                    IType = 1'bX;
                                    RType = 1'bX;
                                    SetFlags = 1'b0;
                                    ZeroBranch = 1'bx;
                                    BranchToReg = 1'bx;
                                    PcToReg = 1'b0;
                                    LinkerReg = 1'b0;
                                    Store = 1'b0;
                             end // begin 
            11'b000101?????: begin // Unconditional branch
                                    Reg2Loc = 1'bX; // don't care
                                    Uncondbranch = 1'b1;
                                    Branch = 1'b1;
                                    MemRead = 1'b0;
                                    MemToReg = 1'bX;
                                    ALUOp = 3'bXXX; // DO NOT CARE
                                    MemWrite = 1'b0;
                                    ALUSrc = 1'bX;
                                    RegWrite = 1'b0;
                                    IType = 1'bX;
                                    RType = 1'bX;
                                    SetFlags = 1'b0;
                                    ZeroBranch = 1'bx;
                                    BranchToReg = 1'b0;
                                    PcToReg = 1'bx;
                                    LinkerReg = 1'bx;
                                    Store = 1'b0;
                             end // begin 
            11'b01010100???: begin // Conditional branch for B.cond
                                    Reg2Loc = 1'b0;
                                    Uncondbranch = 1'b0;
                                    Branch = 1'b1;
                                    MemRead = 1'b0;
                                    MemToReg = 1'bX;
                                    ALUOp = 3'b000; // pass B
                                    MemWrite = 1'b0;
                                    ALUSrc = 1'b0;
                                    RegWrite = 1'b0;
                                    IType = 1'bX;
                                    RType = 1'bX;
                                    SetFlags = 1'b0;
                                    ZeroBranch = 1'b0;
                                    BranchToReg = 1'b0;
                                    PcToReg = 1'b0;
                                    LinkerReg = 1'b0;
                                    Store = 1'b0;
                             end // begin
            11'b10110100???: begin // Conditional branch for CBZ
                                    Reg2Loc = 1'b0;
                                    Uncondbranch = 1'b0;
                                    Branch = 1'b1;
                                    MemRead = 1'b0;
                                    MemToReg = 1'bX;
                                    ALUOp = 3'b000; // pass B
                                    MemWrite = 1'b0;
                                    ALUSrc = 1'b0;
                                    RegWrite = 1'b0;
                                    IType = 1'bX;
                                    RType = 1'bX;
                                    SetFlags = 1'b0;
                                    ZeroBranch = 1'b1;
                                    BranchToReg = 1'b0;
                                    PcToReg = 1'bx;
                                    LinkerReg = 1'b0;
                                    Store = 1'b0;
                             end // begin 
            11'b11001010000: begin // XOR
                                    Reg2Loc = 1'b1;
                                    Uncondbranch = 1'b0;
                                    Branch = 1'b0;
                                    MemRead = 1'b0;
                                    MemToReg = 1'b0;
                                    ALUOp = 3'b110; // XOR
                                    MemWrite = 1'b0;
                                    ALUSrc = 1'b0;
                                    RegWrite = 1'b0;
                                    IType = 1'bX;
                                    RType = 1'bX;
                                    SetFlags = 1'b0;
                                    ZeroBranch = 1'bx;
                                    BranchToReg = 1'bx;
                                    PcToReg = 1'b0;
                                    LinkerReg = 1'b0;
                                    Store = 1'b0;
                             end // begin 
            11'b11111000010: begin // LDUR                       Review this one, tricky
                                    Reg2Loc = 1'b0;
                                    Uncondbranch = 1'b0;
                                    Branch = 1'b0;
                                    MemRead = 1'b1;
                                    MemToReg = 1'b1;
                                    ALUOp = 3'b010; // ADD. Unsure why...
                                    MemWrite = 1'b0;
                                    ALUSrc = 1'b1;
                                    RegWrite = 1'b1;
                                    IType = 1'b0;
                                    RType = 1'b0;
                                    SetFlags = 1'b0;
                                    ZeroBranch = 1'bx;
                                    BranchToReg = 1'bx;
                                    PcToReg = 1'bx;
                                    LinkerReg = 1'b0;
                                    Store = 1'b0;
                             end // begin 
            11'b11010011010: begin // LSR
                                    Reg2Loc = 1'bX;
                                    Uncondbranch = 1'b0;
                                    Branch = 1'b0;
                                    MemRead = 1'b0;
                                    MemToReg = 1'b0;
                                    ALUOp = 3'b001; // New ALU operation for shifting
                                    MemWrite = 1'b0;
                                    ALUSrc = 1'b1;
                                    RegWrite = 1'b1;
                                    IType = 1'b0;
                                    RType = 1'b1;
                                    SetFlags = 1'b0;
                                    ZeroBranch = 1'bx;
                                    BranchToReg = 1'bx;
                                    PcToReg = 1'b0;
                                    LinkerReg = 1'b0;
                                    Store = 1'b0;
                             end // begin 
            11'b11111000000: begin // STUR
                                    Reg2Loc = 1'b0;
                                    Uncondbranch = 1'b0;
                                    Branch = 1'b0;
                                    MemRead = 1'b0;
                                    MemToReg = 1'b0;
                                    ALUOp = 3'b010; // ADD (for the offset)
                                    MemWrite = 1'b1;
                                    ALUSrc = 1'b1; // output from instruction (offset)
                                    RegWrite = 1'b0;
                                    IType = 1'b0; // need to read offset from instruction
                                    RType = 1'b0;
                                    SetFlags = 1'b0;
                                    ZeroBranch = 1'bx;
                                    BranchToReg = 1'bx;
                                    PcToReg = 1'bx;
                                    LinkerReg = 1'b0;
                                    Store = 1'b1;
                             end // begin 
            11'b11101011000: begin // SUBS
                                    Reg2Loc = 1'b1;
                                    Uncondbranch = 1'b0;
                                    Branch = 1'b0;
                                    MemRead = 1'b0;
                                    MemToReg = 1'b0;
                                    ALUOp = 3'b011; // Subtraction
                                    MemWrite = 1'b0;
                                    ALUSrc = 1'b0;
                                    RegWrite = 1'b1;
                                    IType = 1'bX;
                                    RType = 1'bX;
                                    SetFlags = 1'b1;
                                    ZeroBranch = 1'bx;
                                    BranchToReg = 1'bx;
                                    PcToReg = 1'b0;
                                    LinkerReg = 1'b0;
                                    Store = 1'b0;
                             end // begin
                    default: begin // EVERYTHING IS 0. DEFAULT CASE
                                    Reg2Loc = 1'b0;
                                    Uncondbranch = 1'b0;
                                    Branch = 1'b0;
                                    MemRead = 1'b0;
                                    MemToReg = 1'b0;
                                    ALUOp = 3'b000;
                                    MemWrite = 1'b0;
                                    ALUSrc = 1'b0;
                                    RegWrite = 1'b0;
                                    IType = 1'b0;
                                    RType = 1'b0;
                                    SetFlags = 1'b0;
                                    ZeroBranch = 1'b0;
                                    BranchToReg = 1'b0;
                                    PcToReg = 1'b0;
                                    LinkerReg = 1'b0;
                                    Store = 1'b0;
                             end // begin        
        endcase // case
    end // always_comb

endmodule // control


/* control testbench */
module control_testbench();
    logic [10:0] opcode;
    logic Reg2Loc, Uncondbranch, Branch, MemRead, IType, RType;
    logic MemToReg, MemWrite, ALUSrc, RegWrite, SetFlags, ZeroBranch;
    logic [2:0] ALUOp;

    control dut(.*);

    initial begin
        opcode = 11'b10010001000; #100; // ADDI
        opcode = 11'b10101011000; #100; // ADDS
        opcode = 11'b10001010000; #100; // AND
        opcode = 11'b00010100000; #100; // Uncond branch (pos)
        opcode = 11'b00010111111; #100; // Uncond branch (neg)
        opcode = 11'b01010100000; #100; // cond branch (pos)
        opcode = 11'b01010100111; #100; // cond branch (neg)
        opcode = 11'b11001010000; #100; // XOR
        opcode = 11'b11111000010; #100; // LDUR
        opcode = 11'b11010011010; #100; // LSR
        opcode = 11'b11111000000; #100; // STUR
        opcode = 11'b11101011000; #100; // SUBS
    end

endmodule // control testbench


