module alu_8bit (
    input  [7:0] A,          // 8-bit Input Operand A
    input  [7:0] B,          // 8-bit Input Operand B
    input  [3:0] Opcode,     // 4-bit Operation Select
    output reg [7:0] ALU_Out,// 8-bit Output Result
    output reg CarryOut,     // Carry out flag (for addition/subtraction)
    output Zero,             // Zero flag
    output Negative          // Negative flag
);

    // Internal 9-bit register to capture the carry bit during arithmetic
    reg [8:0] tmp;

    always @(*) begin
        // Default values to prevent unintended latches
        ALU_Out  = 8'b0;
        CarryOut = 1'b0;
        tmp      = 9'b0;

        case (Opcode)
            // --- Arithmetic Operations ---
            4'b0000: begin // Addition
                tmp = A + B;
                ALU_Out  = tmp[7:0];
                CarryOut = tmp[8];
            end
            4'b0001: begin // Subtraction
                tmp = A - B;
                ALU_Out  = tmp[7:0];
                CarryOut = tmp[8]; // Acts as borrow out
            end
            4'b0010: ALU_Out = A * B;      // Multiplication (lower 8-bits)
            4'b0011: ALU_Out = (B != 0) ? (A / B) : 8'hFF; // Division with divide-by-zero protection
            4'b0100: ALU_Out = A + 1'b1;   // Increment A
            4'b0101: ALU_Out = A - 1'b1;   // Decrement A

            // --- Logical Operations ---
            4'b0110: ALU_Out = A & B;      // Bitwise AND
            4'b0111: ALU_Out = A | B;      // Bitwise OR
            4'b1000: ALU_Out = A ^ B;      // Bitwise XOR
            4'b1001: ALU_Out = ~(A & B);   // Bitwise NAND
            4'b1010: ALU_Out = ~(A | B);   // Bitwise NOR
            4'b1011: ALU_Out = ~A;         // Bitwise NOT

            // --- Shift/Rotate Operations ---
            4'b1100: ALU_Out = A << 1;     // Logical Shift Left
            4'b1101: ALU_Out = A >> 1;     // Logical Shift Right
            4'b1110: ALU_Out = {A[6:0], A[7]}; // Rotate Left
            4'b1111: ALU_Out = {A[0], A[7:1]}; // Rotate Right

            default: begin
                ALU_Out  = 8'b0;
                CarryOut = 1'b0;
            end
        endcase
    end

    // Flag generation (Combinational continuous assignments)
    assign Zero     = (ALU_Out == 8'b0); // High if output is exactly zero
    assign Negative = ALU_Out[7];        // High if Most Significant Bit (MSB) is 1

endmodule
