`timescale 1ps/1ps
module forwardingUnit(RegWriteRegisterEX, RegWriteRegisterMEM, ALUSrcID, WriteRegEX, WriteRegMEM, RnReg, RmReg, ZeroBranch,
                      forwardCntrlA, forwardCntrlB, StoreRegID, ZeroBranchForwarding, Rm_curr, Rd_curr);
    input logic RegWriteRegisterEX, RegWriteRegisterMEM, StoreRegID, ZeroBranch;
    input logic ALUSrcID;
    input logic [4:0] WriteRegEX, WriteRegMEM, RnReg, RmReg, Rm_curr, Rd_curr;

    output logic [1:0] forwardCntrlA, forwardCntrlB;
    output logic ZeroBranchForwarding;

    always_comb begin
        forwardCntrlA = 2'b00;
        forwardCntrlB = 2'b00;
        ZeroBranchForwarding = 1'b0;
        // Case 1: EX Hazard (EX/MEM forwarding)
        if (RegWriteRegisterEX && (WriteRegEX != 5'd31) && (WriteRegEX == RnReg))
            forwardCntrlA = 2'b10;
        if ((RegWriteRegisterEX && (WriteRegEX != 5'd31) && (WriteRegEX == RmReg))) //  && ~(ALUSrcID) || (StoreRegID && (WriteRegEX == RmReg))
            forwardCntrlB = 2'b10;

        // Case 2: MEM Hazard (unrefined)
        if (RegWriteRegisterMEM && (WriteRegMEM != 5'd31) && (WriteRegMEM == RnReg))
            forwardCntrlA = 2'b01;
        if (RegWriteRegisterMEM && (WriteRegMEM != 5'd31) && (WriteRegMEM == RmReg)) //  && ~(ALUSrcID)
            forwardCntrlB = 2'b01;

        // Case 3: MEM Hazard (refined)
        if (RegWriteRegisterMEM && (WriteRegMEM != 5'd31) && ~(RegWriteRegisterEX && (WriteRegEX != 5'd31) && (WriteRegEX != RnReg)) && (WriteRegMEM == RnReg))
            forwardCntrlA = 2'b01;
        if (RegWriteRegisterMEM && (WriteRegMEM != 5'd31) && ~(RegWriteRegisterEX && (WriteRegEX != 5'd31) && (WriteRegEX != RmReg)) && (WriteRegMEM == RmReg)) //  && ~(ALUSrcID)
            forwardCntrlB = 2'b01;

        // Case 4: MEM Hazard (imma kill myself case)
        if (RegWriteRegisterEX && WriteRegMEM == WriteRegEX && WriteRegEX == RnReg)
            forwardCntrlA = 2'b10;
        if (RegWriteRegisterEX && WriteRegMEM == WriteRegEX && WriteRegEX == RmReg)
            forwardCntrlB = 2'b10;

        if ((Rm_curr == Rd_curr) && ZeroBranch)
            ZeroBranchForwarding = 1'b1;

    end
endmodule

module forwardingUnit_testbench();
    logic RegWriteRegisterEX, RegWriteRegisterMEM;
    logic ALUSrcID;
    logic [4:0] WriteRegEX, WriteRegMEM, RnReg, RmReg;

    logic [1:0] forwardCntrlA, forwardCntrlB;

    forwardingUnit dut(.*);

    initial begin
        RegWriteRegisterEX = 1'b1; RegWriteRegisterMEM <= 1'b1; ALUSrcID = 1'b0;
        WriteRegEX = 5'd1; WriteRegMEM = 5'd2; RnReg <= 5'd3; RmReg <= 5'd4; #2000; // NO FORWARDING
        assert(forwardCntrlA == 2'b00 && forwardCntrlB == 2'b00);

        RegWriteRegisterEX = 1'b1; RegWriteRegisterMEM <= 1'b1; ALUSrcID = 1'b1;      // mux input 00 is from ALU
        WriteRegEX = 5'd1; WriteRegMEM = 5'd2; RnReg <= 5'd3; RmReg <= 5'd1; #2000;   // NO FORWARDING
        assert(forwardCntrlA == 2'b00 && forwardCntrlB == 2'b00);

        RegWriteRegisterEX = 1'b1; RegWriteRegisterMEM <= 1'b1; ALUSrcID = 1'b0;
        WriteRegEX = 5'd1; WriteRegMEM = 5'd2; RnReg <= 5'd3; RmReg <= 5'd1; #2000;   // SHOULD DO EX FORWARD (10) for B
        assert(forwardCntrlA == 2'b00 && forwardCntrlB == 2'b10);

        RegWriteRegisterEX = 1'b1; RegWriteRegisterMEM <= 1'b1; ALUSrcID = 1'b0;
        WriteRegEX = 5'd1; WriteRegMEM = 5'd2; RnReg <= 5'd1; RmReg <= 5'd5; #2000;   // SHOULD DO EX FORWARD (10) for A
        assert(forwardCntrlA == 2'b10 && forwardCntrlB == 2'b00);

        RegWriteRegisterEX = 1'b1; RegWriteRegisterMEM <= 1'b1; ALUSrcID = 1'b0;
        WriteRegEX = 5'd1; WriteRegMEM = 5'd2; RnReg <= 5'd2; RmReg <= 5'd5; #2000;   // SHOULD DO MEM FORWARD (01) for A
        assert(forwardCntrlA == 2'b01 && forwardCntrlB == 2'b00) $display("Mem forward A");

        RegWriteRegisterEX = 1'b1; RegWriteRegisterMEM <= 1'b1; ALUSrcID = 1'b0;
        WriteRegEX = 5'd1; WriteRegMEM = 5'd2; RnReg <= 5'd9; RmReg <= 5'd2; #2000;   // SHOULD DO MEM FORWARD (01) for B
        assert(forwardCntrlA == 2'b00 && forwardCntrlB == 2'b01) $display("Mem forward B");

        RegWriteRegisterEX = 1'b1; RegWriteRegisterMEM <= 1'b1; ALUSrcID = 1'b0;
        WriteRegEX = 5'd1; WriteRegMEM = 5'd1; RnReg <= 5'd9; RmReg <= 5'd1; #2000;   // SHOULD DO MEM FORWARD (01) for B
        assert(forwardCntrlA == 2'b00 && forwardCntrlB == 2'b10);

        RegWriteRegisterEX = 1'b1; RegWriteRegisterMEM <= 1'b1; ALUSrcID = 1'b0;
        WriteRegEX = 5'd1; WriteRegMEM = 5'd1; RnReg <= 5'd1; RmReg <= 5'd3; #2000;   // SHOULD DO MEM FORWARD (01) for A
        assert(forwardCntrlA == 2'b10 && forwardCntrlB == 2'b00);

    end
endmodule
