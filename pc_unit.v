/*
// pc_unit.v
module pc_unit (
    input clk, reset,
    input branch, jump,
    input zero_flag,        // From ALU
    input [31:0] branch_offset_shifted, // This is (Sign_Extended_Immediate << 2)
    input [25:0] jump_target_imm_26, // 26-bit immediate from J-type instruction (e.g., from instruction[25:0])
                                    // Make sure this is correctly handled (shifted, concatenated)

    output [31:0] current_pc_out // Output to Instruction Memory address
);

    // Internal wires for PC register's current value and its next value
    wire [31:0] pc_current_value; // The actual current value of the PC register
    wire [31:0] pc_next_value;    // The calculated next value for the PC register

    // Internal wires for intermediate calculations
    wire [31:0] pc_plus_4;
    wire [31:0] branch_target_address;
    wire [31:0] jump_target_address;
    wire        branch_taken; // Condition for actual branch (branch && zero_flag for BEQ)

    // 1. Instantiate the Program Counter Register itself
    // The PC_out of your programCounter module *is* the current PC value.
    programCounter PC_Register (
        .clk        (clk),
        .reset      (reset),
        .PC_next_in (pc_next_value), // Feed the calculated next_pc into the PC register
        .PC_out     (pc_current_value) // This is the PC value used for calculations this cycle
    );

    // Output the current PC value to the Instruction Memory
    assign current_pc_out = pc_current_value;    

    // 2. Calculate PC + 4
    // Using a direct assign is simpler than a separate adder module for this if it's just PC+4
    assign pc_plus_4 = pc_current_value + 32'd4;

    // 3. Calculate Branch Target Address
    // Branch target = (PC_current_value + 4) + (Sign_Extended_Immediate << 2)
    // You need to pass the SIGN_EXTENDED_IMMEDIATE, and this unit will shift it.
    // Or, pass `branch_offset_shifted` as you have:
    assign branch_target_address = pc_plus_4 + branch_offset_shifted;

    

    // 4. Calculate Jump Target Address (for J-type instructions like JAL)
    // Jump target = {PC_current_value[31:28], jump_target_imm_26, 2'b00}
    assign jump_target_address = {pc_current_value[31:28], jump_target_imm_26, 2'b00};


    // 5. Determine Branch Taken Condition
    // For BEQ, branch is taken if `branch` signal is high AND `zero_flag` is high.
    // For BNE, branch is taken if `branch` signal is high AND `zero_flag` is low.
    // Your main Control Unit's `branch` signal usually indicates *any* branch instruction.
    // The `alu_control_unit` would have instructed the ALU to perform a subtraction for BEQ/BNE.
    // Let's assume `branch` means a BEQ for simplicity for now, so it depends on `zero_flag`.
    // If you support BNE, BLT etc., this logic would be more complex (e.g., from ALU result directly).
    assign branch_taken = branch && zero_flag; // Simple BEQ logic

    // 6. Muxes to select the next PC value
    // Prioritize Jump > Branch > PC+4
    // Using nested ternary operators (or MUX instances)
    assign pc_next_value = pc_plus_4; 
    //jump ? jump_target_address :
    //                       (branch_taken ? branch_target_address :
    //                        pc_plus_4);

endmodule */


module pc_unit (
    input clk, reset,
    input branch, jump, // These are currently ignored as per your request
    input zero_flag,    // From ALU - currently ignored
    input [31:0] branch_offset_shifted, // currently ignored
    input [25:0] jump_target_imm_26,    // currently ignored

    output [31:0] current_pc_out // Output to Instruction Memory address
);

    // Internal wires for PC register's current value and its next value
    wire [31:0] pc_current_value; // The actual current value of the PC register
    wire [31:0] pc_next_value;    // The calculated next value for the PC register

    // Internal wires for intermediate calculations
    wire [31:0] pc_plus_4;
    // wire [31:0] branch_target_address; // Not needed if ignoring branch
    // wire [31:0] jump_target_address;   // Not needed if ignoring jump
    // wire        branch_taken;          // Not needed if ignoring branch

    // 1. Instantiate the Program Counter Register itself
    programCounter PC_Register (
        .clk        (clk),
        .reset      (reset),
        .PC_next_in (pc_next_value),      // Feed the calculated next_pc into the PC register
        .PC_out     (pc_current_value)    // This is the PC value used for calculations this cycle
    );

    // Output the current PC value to the Instruction Memory
    assign current_pc_out = pc_current_value;

    // 2. Calculate PC + 4
    assign pc_plus_4 = pc_current_value + 32'd4;
    assign pc_next_value = pc_plus_4;       // Temporary..

    // 3. Calculate Branch Target Address (Commented out as per request)
    // assign branch_target_address = pc_plus_4 + branch_offset_shifted;

    // 4. Calculate Jump Target Address (Commented out as per request)
    // assign jump_target_address = {pc_current_value[31:28], jump_target_imm_26, 2'b00};

    // 5. Determine Branch Taken Condition (Commented out as per request)
    // assign branch_taken = branch && zero_flag;

    // 6. Muxes to select the next PC value
    // Only sequential PC+4 for now.
    // Ensure this is the *only* assignment to pc_next_value for now.
    //assign pc_next_value = pc_plus_4; 
    /*jump ? jump_target_address :
        (branch_taken ? branch_target_address :
         pc_plus_4);*/ // This whole ternary operator block should be removed or commented out for now.

endmodule