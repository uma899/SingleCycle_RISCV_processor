module processor (
    input clk, reset
);

    wire [31:0] current_PC; 
    wire [31:0] current_instr;
    //wire [31:0] next_instr;


    /* These have no work for now.. */
    wire branch, jump;
    wire zero_flag;
    wire [31:0] branch_offset_shifted;
    wire [25:0] jump_target_imm_26;
    /* These have no work for now.. */


    pc_unit PCmain(
        clk, reset, 
        branch, jump, zero_flag, 
        branch_offset_shifted, 
        jump_target_imm_26,
        current_PC
    );

    instruction_memory instr (
        current_PC,
        current_instr
    );




    wire reg_dst;   // To distingush between Load type from others. 0 => load, 1 => others
    wire [1:0] alu_op;

    wire mem_read_en;
    wire mem_write_en;
    wire mem_to_reg;

    wire alu_src;

    wire reg_write_en;
    
    control_unit CU (
        current_instr [6:0],
        reg_dst,
        jump,
        branch,
        mem_read_en, mem_to_reg,
        alu_op,
        mem_write_en,
        alu_src,
        reg_write_en
    );

   

    wire [31:0] alu_out;   
    wire [31:0] read_data1_from_rf;
    wire [31:0] read_data2_from_rf;

    wire [4:0] rs2_vs_immediate;

    register_file regFile (
        clk, reset,
        current_instr [19:15],      // Always rs1 (i.e., it has to read data/address)
        current_instr [24:20],      // Should be rs2 for R, S.. and 
        current_instr [11:7],       // Write destn
        alu_out,
        reg_write_en,
        read_data1_from_rf,
        read_data2_from_rf
    );




    wire [31:0] operand2;
    assign operand2 = (alu_src) ? {20'd0, current_instr[31:20]} : read_data2_from_rf;


    wire [2:0]alu_select;
    wire zero;

    alu_control_unit ALU_CU(
        alu_op,   
        current_instr [14:12],   
        current_instr [31:25],   
        alu_select
    );

    ALU main_alu(
        read_data1_from_rf, 
        operand2,
        alu_select,
        alu_out,
        zero
    );    




    data_memory MEMaccess(
        clk, reset,
        alu_out,            // Calculated offSet address
        read_data2_from_rf,                   
        mem_read_en, mem_write_en,
        read_data_out
    );


endmodule