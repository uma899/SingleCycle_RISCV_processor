module processor (
    input clk, reset
);

    wire [31:0] current_PC; 
    wire [31:0] current_instr;

    wire [31:0] alu_out;   

    wire branch, jump;
    wire [19:0] jump_target_imm_20;
    wire [11:0] branch_offset_12;

    wire zero;  // 1 if zero = 0

    assign jump_target_imm_20 = {current_instr[31], current_instr[19:12], current_instr[20], current_instr[30:21]};
    assign branch_offset_12 = {current_instr[31], current_instr[7], current_instr[30:25], current_instr[11:8]};
    //assign branch_offset_12 = 12'd4;

// refer pg. 185 in pdf
    pc_unit PCmain(
        .clk(clk), .reset(reset), 
        .branch(branch), .jump(jump), .zero_flag(zero), 
        .branch_offset_12(branch_offset_12), 
        .jump_target_imm_20(jump_target_imm_20),
        .current_pc_out(current_PC)
    );

    instruction_memory instr (
        current_PC,
        current_instr
    );




    //wire reg_dst;   // To distingush between Load type from others. 0 => load, 1 => others
    wire [1:0] alu_op;

    wire mem_read_en;
    wire mem_write_en;
    wire mem_to_reg;

    wire alu_src;

    wire reg_write_en;
    
    control_unit CU (
        current_instr [6:0],
        //reg_dst,
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


    wire [31:0] read_data_out;

    wire [31:0] write_data;
    wire [31:0] temp_write_data;
    assign temp_write_data = (jump) ? current_PC + 32'd4 : (mem_to_reg) ? read_data_out : 32'd0;
    //wire check_jump_memtoreg = jump + mem_to_reg;
    assign write_data = (jump | mem_to_reg) ? temp_write_data : alu_out;

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

    wire [31:0] immediate_value;
    assign immediate_value = (mem_to_reg) ? {{20{current_instr[31]}}, current_instr[31:20]}:
                                            {{20{current_instr[31]}}, current_instr[31:25], current_instr[11:7]};
    assign operand2 = (alu_src) ? immediate_value : read_data2_from_rf;


    wire [3:0]alu_select;
    

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

//    wire [31:0] mem_write_data_in;
//    assign mem_write_data_in = (mem_to_reg) ? alu_out : read_data2_from_rf;
    data_memory MEMaccess(
        clk, reset,
        alu_out,            // Calculated offSet address
        read_data2_from_rf,
        mem_read_en, mem_write_en,
        read_data_out
    );


endmodule