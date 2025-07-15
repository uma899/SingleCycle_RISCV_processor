module pc_unit (
    input clk, reset,
    input branch, jump, 
    input zero_flag,    
    input [31:0] branch_offset_shifted, 
    input [25:0] jump_target_imm_26,    // currently ignored

    output [31:0] current_pc_out // Output to Instruction Memory address
);

    wire [31:0] pc_current_value; 
    wire [31:0] pc_next_value;    

    wire [31:0] pc_plus_4;

    programCounter PC_Register (
        .clk        (clk),
        .reset      (reset),
        .PC_next_in (pc_next_value),      // Feed the calculated next_pc into the PC register
        .PC_out     (pc_current_value)    // This is the PC value used for calculations this cycle
    );

    // Output the current PC value to the Instruction Memory
    assign current_pc_out = pc_current_value;

    assign pc_plus_4 = pc_current_value + 32'd4;


    // 4. Calculate Jump Target Address (Commented out as per request)
    //assign jump_target_address = {pc_current_value[31:28], jump_target_imm_26, 2'b00};

    //assign pc_next_value = (jump) ? jump_target_address : pc_plus_4;       // Temporary..

    wire branch_target_address = branch_offset_shifted + pc_current_value + 32'd4;

    always @(*) begin
        $display("--------Current PC: %d", current_pc_out);
        $display("--------branch_target_address: %b, branch_offset_shifted: %b---------", branch_target_address, branch_offset_shifted);
    end

    assign pc_next_value = (branch) ? branch_target_address : pc_plus_4;

    // 3. Calculate Branch Target Address (Commented out as per request)
    // assign branch_target_address = pc_plus_4 + branch_offset_shifted;



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