/* module alu_control_unit (
    input [1:0] alu_op,   // High-level ALU operation from main Control Unit
    input [2:0] funct3,   // funct3 field from instruction (bits 14:12)
    input [6:0] funct7,   // funct7 field from instruction (bits 31:25)
    output reg [2:0] alu_select // Final 3-bit control for the ALU module
);

localparam ALU_SLT   = 3'b000;
localparam ALU_ADD   = 3'b001;
localparam ALU_SUB   = 3'b010;
localparam ALU_AND   = 3'b011;
localparam ALU_OR    = 3'b100;
localparam ALU_XOR   = 3'b101;
localparam ALU_SLL   = 3'b110;
localparam ALU_SRL   = 3'b111;

// Define the higher-level ALU operation codes from the main Control Unit
// These must match the `define`s used in your `control_unit.v`
// (Assuming you're using `ALU_OP_R_TYPE`, `ALU_OP_ADD_SUB` etc. from my last example)
localparam ALU_OP_R_TYPE   = 2'b10; // Corresponds to `ALU_OP_R_TYPE`
localparam ALU_OP_ADD_SUB  = 2'b00; // Corresponds to `ALU_OP_ADD_SUB`
localparam ALU_OP_BRANCH   = 2'b01; // Let's introduce a specific ALU_OP for branches for clarity
                                    // You'll need to update your main Control Unit to use this for branches
localparam ALU_OP_PASS_B   = 2'b11; // Can be used to simply pass operand2 to result, e.g., for LUI (if ALU is involved)


    always @(*) begin
        // Default assignment for alu_select to prevent latches
        alu_select = ALU_ADD; // A common safe default

        case (alu_op)
            ALU_OP_R_TYPE: begin // R-type instructions (ADD, SUB, SLL, SLT, AND, OR, XOR, SRL, SRA)
                // Decode R-type operations using funct3 and funct7
                // Use a combined value {funct7, funct3} or nested cases
                case ({funct7, funct3})
                    // ADD (ADD is funct7=0000000, funct3=000)
                    {7'b0000000, 3'b000}: alu_select = ALU_ADD;
                    // SUB (SUB is funct7=0100000, funct3=000)
                    {7'b0100000, 3'b000}: alu_select = ALU_SUB;
                    // SLL (SLL is funct7=0000000, funct3=001)
                    {7'b0000000, 3'b001}: alu_select = ALU_SLL;
                    // SLT (SLT is funct7=0000000, funct3=010)
                    {7'b0000000, 3'b010}: alu_select = ALU_SLT; // Signed less than
                    // SLTU (SLTU is funct7=0000000, funct3=011) - if you implement unsigned SLT
                    // {7'b0000000, 3'b011}: alu_select = ALU_SLTU; // Needs ALU support

                    // XOR (XOR is funct7=0000000, funct3=100)
                    {7'b0000000, 3'b100}: alu_select = ALU_XOR;
                    // SRL (SRL is funct7=0000000, funct3=101)
                    {7'b0000000, 3'b101}: alu_select = ALU_SRL;
                    // SRA (SRA is funct7=0100000, funct3=101) - if you implement arithmetic right shift
                    // {7'b0100000, 3'b101}: alu_select = ALU_SRA; // Needs ALU support

                    // OR (OR is funct7=0000000, funct3=110)
                    {7'b0000000, 3'b110}: alu_select = ALU_OR;
                    // AND (AND is funct7=0000000, funct3=111)
                    {7'b0000000, 3'b111}: alu_select = ALU_AND;

                    default: begin 
                        alu_select = ALU_ADD; // Default for unhandled R-type funct/funct7

                        $display("Default from ALU control Unit");
                    end

                endcase
            end

            ALU_OP_ADD_SUB: begin // For Load/Store address calculation, ADDI, JALR address
                // These typically just need an ADD operation in the ALU
                // ADDI is `funct3=000`. LW/SW/JALR address calculation also use ADD.
                alu_select = ALU_ADD;
                // If you had I-type instructions like XORI, ORI, ANDI, SLTI, SLTUI
                // which use `alu_op` as `ALU_OP_ADD_SUB` but need different ALU ops based on funct3:
                case (funct3)
                    3'b000: alu_select = ALU_ADD;  // ADDI
                    3'b010: alu_select = ALU_SLT;  // SLTI (Signed Less Than Immediate)
                    // 3'b011: alu_select = ALU_SLTU; // SLTIU (Unsigned Less Than Immediate) - Needs ALU support
                    3'b100: alu_select = ALU_XOR;  // XORI
                    3'b110: alu_select = ALU_OR;   // ORI
                    3'b111: alu_select = ALU_AND;  // ANDI
                    // Other I-type ops (SLLI, SRLI, SRAI) might also be handled here,
                    // but they share funct3 with R-type shifts and might use funct7 for distinction
                    // or be handled with a different `alu_op` from the control unit.
                    default: begin alu_select = ALU_ADD; // Default for other I-type funct3
                        $display("Default from ALU control Unit");
                    end
                endcase
            end

            ALU_OP_BRANCH: begin // For Branch instructions (BEQ, BNE, BLT, BGE, etc.)
                // Branches usually perform subtraction (to set zero flag for BEQ/BNE)
                // or comparison (for BLT/BGE)
                case (funct3)
                    3'b000: alu_select = ALU_SUB; // BEQ, BNE (result == 0 for BEQ, !=0 for BNE)
                    3'b010: alu_select = ALU_SLT; // BLT (Signed Less Than)
                    // 3'b011: alu_select = ALU_SLTU; // BLTU (Unsigned Less Than) - Needs ALU support
                    // 3'b100: alu_select = ALU_GE; // BGE (Greater or Equal) - needs ALU support (or invert SLT)
                    // 3'b101: alu_select = ALU_BGEU; // BGEU (Unsigned Greater or Equal) - Needs ALU support
                    default: alu_select = ALU_SUB; // Default for other branch types
                endcase
            end
            // Add other ALU_OP types from your main Control Unit if they need specific ALU operations
            // For example, if you have a special ALU_OP for LUI or AUIPC if the ALU is used to pass the immediate.
            // ALU_OP_PASS_B: begin
            //     alu_select = ALU_PASS_B; // Assuming your ALU has a pass-through operation
            // end

            default: alu_select = ALU_ADD; // Default for unhandled high-level alu_op
        endcase
    end

endmodule */


module alu_control_unit (
    input [1:0] alu_op,   // High-level ALU operation from main Control Unit
    input [2:0] funct3,   // funct3 field from instruction (bits 14:12)
    input [6:0] funct7,   // funct7 field from instruction (bits 31:25)
    output reg [2:0] alu_select // Final 3-bit control for the ALU module
);

localparam ALU_SLT   = 3'b000;
localparam ALU_ADD   = 3'b001;
localparam ALU_SUB   = 3'b010;
localparam ALU_AND   = 3'b011;
localparam ALU_OR    = 3'b100;
localparam ALU_XOR   = 3'b101;
localparam ALU_SLL   = 3'b110;
localparam ALU_SRL   = 3'b111;

    always @(*) begin
        if(alu_op == 2'b00) begin
            case({funct3, funct7})

                {3'b010, 7'b0000000}: begin
                    alu_select = ALU_SLT;
                    $display("SLT - alu_CU");
                end

                {3'b000, 7'b0000000}: begin
                    alu_select = ALU_ADD;
                    $display("ADD - alu_CU");
                end

                {3'b000, 7'b0100000}: begin
                    alu_select = ALU_SUB;
                    $display("SUB - alu_CU");
                end

                {3'b111, 7'b0000000}: begin
                    alu_select = ALU_AND;
                    $display("AND - alu_CU");
                end

                {3'b110, 7'b0000000}: begin
                    alu_select = ALU_OR;
                    $display("OR - alu_CU");
                end

                {3'b100, 7'b0000000}: begin
                    alu_select = ALU_XOR;
                    $display("XOR - alu_CU");
                end

                {3'b001, 7'b0000000}: begin
                    alu_select = ALU_SLL;
                    $display("SLL - alu_CU");
                end

                {3'b101, 7'b0000000}: begin
                    alu_select = ALU_SRL;
                    $display("SRL - alu_CU");
                end

                default: begin
                    alu_select = ALU_ADD;
                    $display("Unkown case - alu_CU");
                end

            endcase
        end else if(alu_op == 2'b01) begin
            alu_select = ALU_ADD;
            $display("Calculated offset for Load - alu_CU");
        end else if(alu_op == 2'b10) begin
            $display("Branch - alu_CU");
        end else begin
            $display("Unknown Task - alu_CU");
        end
    end

endmodule