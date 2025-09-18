/*
SLT (Set Less Than - for comparisons, sets output to 1 if A < B, else 0)
ADD (Addition)
SUB (Subtraction)
AND (Bitwise AND)
OR (Bitwise OR)
XOR (Bitwise XOR)
SLL (Logical Shift Left)
SRL (Logical Shift Right)

Equal
*/

module ALU ( // Changed moduleName to ALU
    input [31:0] operand1_in, operand2_in,
    input [3:0] alu_control_in,
    output [31:0] alu_result,
    output zero
);
    reg [31:0] alu_result_int;

    always @(*) begin // Combinational logic, sensitive to all inputs
        case (alu_control_in)
            4'b0000: begin // SLT
                alu_result_int = (operand1_in < operand2_in) ? 32'd1 : 32'd0;

                //$display("comparision worked");
            end
            4'b0001: begin // ADD
                alu_result_int = operand1_in + operand2_in;
                $display("ADD worked, result: %d", alu_result_int);
            end
            4'b0010: begin // SUB
                alu_result_int = operand1_in - operand2_in;
                //$display("SUB worked");
            end
            4'b0011: begin // AND
                alu_result_int = operand1_in & operand2_in;
                //$display("AND worked");
            end
            4'b0100: begin // OR
                alu_result_int = operand1_in | operand2_in;
                //$display("OR worked");
            end
            4'b0101: begin // XOR
                alu_result_int = operand1_in ^ operand2_in;
                //$display("XOR worked");
            end
            4'b0110: begin // SLL (Shift Left Logical)
                // For shifts in MIPS, the shift amount comes from operand2_in[4:0] (shamt)
                // or the rt register for variable shifts.
                // Assuming operand2_in provides the shift amount (shamt).
                // MIPS SLL/SRL use shamt (bits 10:6 of instruction), not a fixed '1'.
                // If you intend a fixed shift, then '1' is fine.
                // Assuming operand2_in's lower 5 bits are the shift amount.
                alu_result_int = operand1_in << operand2_in[4:0];

                //$display("Shift worked");
            end
            4'b0111: begin // SRL (Shift Right Logical)
                // Assuming operand2_in's lower 5 bits are the shift amount.
                alu_result_int = operand1_in >> operand2_in[4:0];

                //$display("Shift worked");
            end


            4'b1000: begin // EQUAL
                alu_result_int = (operand1_in == operand2_in) ? 32'd0 : 32'd1;
                $display("Equal worked: %d, compared %d %d", alu_result_int, operand1_in, operand2_in);
            end


            default: begin
                // Default case for unknown ALU control values.
                // Important for synthesis to avoid latches.
                // 'x' or '0' are common defaults. '0' is safer for simpler designs.
                alu_result_int = 32'hxxxxxxxx; // Undefined for unhandled cases

                $display("default worked - ALU");
            end
        endcase
    end

    assign alu_result = alu_result_int;
    
    assign zero = (alu_result_int == 32'b0) ? 1'b1 : 1'b0;

endmodule