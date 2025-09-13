module pc_unit (
    input clk, reset,
    input branch, jump, 
    input zero_flag,    
    input [31:0] branch_offset_shifted, 
    input [25:0] jump_target_imm_20,    // currently ignored

    output [31:0] current_pc_out // Output to Instruction Memory address
);

    wire [31:0] pc_current_value; 
    wire [31:0] pc_next_value;

    programCounter PC_Register (
        .clk        (clk),
        .reset      (reset),
        .PC_next_in (pc_next_value),      // Feed the calculated next_pc into the PC register
        .PC_out     (pc_current_value)    // This is the PC value used for calculations this cycle
    );

    assign current_pc_out = pc_current_value;

    wire [31:0] jump_target_address, branch_target_address;
    wire [31:0] pc_plus_4;

    assign pc_plus_4 = pc_current_value + 32'd4;
    assign branch_target_address = branch_offset_shifted + pc_current_value;
    assign jump_target_address = {12'd0, jump_target_imm_20} + pc_current_value + 32'd4;

    assign pc_next_value = (jump)   ? jump_target_address :
                           (branch) ? branch_target_address :
                                      pc_plus_4;

endmodule