`timescale 1ns / 1ps

module tb_alu_8bit;

    // Inputs
    reg [7:0] A;
    reg [7:0] B;
    reg [3:0] Opcode;

    // Outputs
    wire [7:0] ALU_Out;
    wire CarryOut;
    wire Zero;
    wire Negative;

    // Instantiate the Unit Under Test (UUT)
    alu_8bit uut (
        .A(A),
        .B(B),
        .Opcode(Opcode),
        .ALU_Out(ALU_Out),
        .CarryOut(CarryOut),
        .Zero(Zero),
        .Negative(Negative)
    );

    initial begin
        // Initialize Inputs
        A = 8'd10;
        B = 8'd5;
        Opcode = 4'b0000;

        // Wait 100 ns for global reset to settle
        #100;

        // Test Case 1: Addition (10 + 5 = 15)
        Opcode = 4'b0000; #20;

        // Test Case 2: Subtraction (10 - 5 = 5)
        Opcode = 4'b0001; #20;

        // Test Case 3: Overflow Addition (255 + 1) -> Generates CarryOut
        A = 8'hFF; B = 8'h01; Opcode = 4'b0000; #20;

        // Test Case 4: Zero Flag Verification (10 - 10 = 0)
        A = 8'd10; B = 8'd10; Opcode = 4'b0001; #20;

        // Test Case 5: Bitwise AND (8'b1010 & 8'b1100 = 8'b1000)
        A = 8'b0000_1010; B = 8'b0000_1100; Opcode = 4'b0110; #20;

        // Test Case 6: Right Shift A (8'b0000_1010 >> 1 = 8'b0000_0101)
        Opcode = 4'b1101; #20;

        $finish; // End simulation
    end

endmodule
