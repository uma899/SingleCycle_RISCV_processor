module control_unit (
    input  [6:0] opcode,

    // output reg reg_dst,        // 1 for R-type (rd), 0 for I-type (rt)
    output reg jump,
    output reg branch,
    output reg mem_read_en,
    output reg mem_to_reg,     // 1 for Load, 0 for ALU result
    output reg [1:0] alu_op,   // Using 2 bits for higher-level ALU operation type
    // 00: R-type, 01: load, 01: store, 10: branch
    output reg mem_write_en,
    output reg alu_src,        // 1 for immediate, 0 for register read data2
    output reg reg_write_en
);

    // All outputs must have a default value to prevent latches
    // Initialize to 0 (de-asserted) or a safe default
    always @(*) begin
        // Default values for all control signals
        // reg_dst        = 1'b0;
        jump           = 1'b0;
        branch         = 1'b0;
        mem_read_en    = 1'b0;
        mem_to_reg     = 1'b0;
        alu_op         = 2'b00; // Default ALU operation (e.g., for R-type base)
        mem_write_en   = 1'b0;
        alu_src        = 1'b0;
        reg_write_en   = 1'b0;

        case (opcode)
            // R-TYPE (ADD, SUB, AND, OR, XOR, SLL, SRL, SLT etc. - all have opcode 7'b011001)
            7'b0110011: begin // R-type instructions (e.g., add, sub, and, or, xor, sll, srl, slt)
                // reg_dst        = 1'b1;     // Destination is rd (Instruction[15:11])
                alu_src        = 1'b0;     // Second ALU operand comes from Read_Data2
                reg_write_en   = 1'b1;     // Write result back to register file
                alu_op         = 2'b00;    // Signal to ALU_Control that it's an R-type operation
                                            // The ALU_Control will then use 'funct'
                mem_read_en    = 0'b0;                                            

                $display("R type - from CU");
            end

            // I-TYPE 
            //(Arithmetic/Logical Immediate - ADDI, XORI, ORI, ANDI, SLLI, SRLI, SRAI, SLTI, SLTUI)
            7'b0010011: begin
                // reg_dst        = 1'b0;     // Destination is rt (Instruction[20:16])
                alu_src        = 1'b1;     // Second ALU operand comes from sign-extended immediate
                reg_write_en   = 1'b1;     // Write result back to register file
                alu_op         = 2'b01;    // Signal for I-type ALU operation (e.g., ADD for ADDI)
                                           // ALU_Control will use funct3 for actual operation
            end

            // I-TYPE
            // LOAD TYPE (LW, LH, LB, LHU, LBU - all have opcode 7'b000001)
            7'b0000011: begin
                // reg_dst        = 1'b0;     // Destination is rt (Instruction[20:16])
                alu_src        = 1'b1;     // ALU calculates address: base_reg + sign_extended_immediate
                mem_read_en    = 1'b1;     // Enable Data Memory read
                mem_to_reg     = 1'b1;     // Write data from memory to register
                reg_write_en   = 1'b1;     // Enable Register File write
                alu_op         = 2'b01;    // ALU performs ADD for address calculation

                $display("L type - from CU");
            end

            // S-TYPE (Store Instructions - SW, SH, SB - all have opcode 7'b010001)
            7'b0100011: begin
                alu_src        = 1'b1;     // ALU calculates address: base_reg + sign_extended_immediate
                mem_write_en   = 1'b1;     // Enable Data Memory write
                reg_write_en   = 1'b0;     // No register write for store instructions
                alu_op         = 2'b01;    // ALU performs ADD for address calculation

                $display("S type - from CU");
            end

            // B-TYPE (Branch Instructions - BEQ, BNE, BLT, BGE etc. - all have opcode 7'b110001)
            7'b1100011: begin
                // reg_dst        = 1'b1;
                branch         = 1'b1;     // Enable branch logic (conditional on Zero flag)
               // alu_src        = 1'b0;     // ALU performs subtraction (Rs1 - Rs2) to set Zero flag for BEQ/BNE
                reg_write_en   = 1'b0;     // No register write for branch instructions
                alu_op         = 2'b10;    // Signal for Branch ALU operation (e.g., SUB for equality check)

                $display("B type - from CU");
            end

            // J-TYPE (JAL - Jump And Link - opcode 7'b110111)
            7'b1101111: begin
                jump           = 1'b1;     // Enable jump logic
                // reg_dst        = 1'b1;     // Write PC+4 to rd (R31 for MIPS, or specific rd for RISC-V JAL)
                reg_write_en   = 1'b1;     // Write PC+4 to link register (e.g., x1 for RISC-V)
                alu_op         = 2'b00;    // No ALU operation needed, but set a default
                                            // Or use a specific code if ALU needs to pass PC+4
                $display("J type - from CU");
            end

            // JALR (Jump And Link Register - opcode 7'b110011 -- similar to I-type ALU)
            // If you implement JALR, its opcode is the same as I-type LOAD (0000011) but with funct3.
            // In RISC-V, JALR uses opcode 7'b110011.
            // If you have JALR, its RegWrite is 1, RegDst is 0 (rt), ALUSrc is 1 (immediate),
            // and ALUOp will be ADD (for address calculation, or just pass PC+4 for RegFile).
            // Example if you choose to support JALR:
            /*
            7'b110011: begin // JALR
                jump           = 1'b1;     // Enable jump logic
                reg_dst        = 1'b0;     // Write PC+4 to rt
                alu_src        = 1'b1;     // ALU for address calculation: base + imm
                reg_write_en   = 1'b1;     // Write PC+4 to link register
                alu_op         = 2'b01;    // ALU operation for address (e.g., ADD for base + offset)
            end
            */

            default: begin
                // All signals remain at their default (de-asserted) values.
                // This is crucial to prevent inference of latches.
                // For unknown/unsupported opcodes, no operation should occur.
                $display("Unknown Opcode - Control Unit");
            end
        endcase
    end

    // ALU_Control logic (can be a separate module or integrated here)
    // This part determines the specific ALU operation based on alu_op from above
    // and funct field for R-type, or funct3 for I/S/B types.
    // For simplicity, let's keep it here for now, defining your ALU's 3-bit control.
    // NOTE: This now drives alu_op in a separate always block (which is allowed if alu_op is a wire)
    // BUT since alu_op is a 'reg' AND driven in the main block, this creates a conflict.
    // The solution is to have ALU_Control be a separate module, or merge this logic.

    // Let's assume you will have a separate ALU_Control module,
    // and this module's 'alu_op' output is a higher-level code.
    // So, I'll remove the second always block from this module.
    // Your ALU's 'alu_control_in' will be derived from THIS 'alu_op' and 'funct' elsewhere.

endmodule