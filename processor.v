<<<<<<< HEAD
module processor (
    input clk, reset
);

    wire [31:0] current_PC; 
    wire [31:0] current_instr;
    //wire [31:0] next_instr;



    wire [31:0] alu_out;   

    /* These have no work for now.. */
    wire branch, jump;
    wire zero_flag;
    
    wire [25:0] jump_target_imm_20;
    /* These have no work for now.. */

    wire [31:0] branch_offset_shifted;

    
    assign branch_offset_shifted = (alu_out == 32'b0) ? {32'd0} : {18'b0, current_instr[12],current_instr[7], current_instr[30:25], current_instr[11:8], 2'b00};

/*
imm[20] (the sign bit): 0

imm[19:12] (8 bits): 00000010

imm[11] (1 bit): 1

imm[10:1] (10 bits): 0100000000

*/

    assign jump_target_imm_20 = {current_instr[31], current_instr[19:12], current_instr[20], current_instr[30:21]};

    pc_unit PCmain(
        clk, reset, 
        branch, jump, zero_flag, 
        branch_offset_shifted, 
        jump_target_imm_20,
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

    wire [31:0] read_data1_from_rf;
    wire [31:0] read_data2_from_rf;

    wire [4:0] rs2_vs_immediate;


    wire [31:0] write_data;
    assign write_data = (jump) ? current_PC + 32'd4 : alu_out;

    register_file regFile (
        clk, reset,
        current_instr [19:15],      // Always rs1 (i.e., it has to read data/address)
        current_instr [24:20],      // Should be rs2 for R, S.. and 
        current_instr [11:7],       // Write destn
        write_data,
        reg_write_en,
        read_data1_from_rf,
        read_data2_from_rf
    );




    wire [31:0] operand2;
    assign operand2 = (alu_src) ? {20'd0, current_instr[31:20]} : read_data2_from_rf;


    wire [3:0]alu_select;
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


=======
module processor (
    input clk, reset
);

    wire [31:0] current_PC; 
    wire [31:0] current_instr;
    //wire [31:0] next_instr;



wire [31:0] alu_out;   




    /* These have no work for now.. */
    wire branch, jump;
    wire zero_flag;
    
    wire [25:0] jump_target_imm_26;
    /* These have no work for now.. */

    wire [31:0] branch_offset_shifted;

    
    assign branch_offset_shifted = (alu_out == 32'b0) ? {32'd0} : {18'b0, current_instr[12],current_instr[7], current_instr[30:25], current_instr[11:8], 2'b00};

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


    wire [3:0]alu_select;
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


>>>>>>> 628c9153ad1970f300b5de88177c32d846f1347a
endmodule