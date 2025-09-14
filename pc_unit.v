module pc_unit (
    input clk, reset,
    input branch, jump, 
    input zero_flag,    
    input [11:0] branch_offset_12, 
    input [19:0] jump_target_imm_20,

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
    assign branch_target_address = (branch_offset_12[11]) ? pc_current_value - {21'd0, branch_offset_12[10:0]} : pc_current_value + {20'd0, branch_offset_12};
    //assign branch_target_address = pc_current_value + 32'd4; //{20'd0, 12'd4};
    assign jump_target_address = (jump_target_imm_20[19]) ? pc_current_value - {13'd0, jump_target_imm_20[18:0]} : pc_current_value + {12'd0, jump_target_imm_20}  + 32'd4;

    assign pc_next_value = (jump)   ? jump_target_address :
                           (branch && zero_flag) ? branch_target_address : pc_plus_4;
    always @(posedge clk) begin
        if(branch && zero_flag) begin
            $display("Branch Taken");
        end
    end
endmodule