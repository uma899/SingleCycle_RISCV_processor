module alu_control_unit (
    input [1:0] alu_op,   // High-level ALU operation from main Control Unit
    input [2:0] funct3,   // funct3 field from instruction (bits 14:12)
    input [6:0] funct7,   // funct7 field from instruction (bits 31:25)
    output reg [3:0] alu_select // Final 3-bit control for the ALU module
);

localparam ALU_SLT   = 4'b0000;
localparam ALU_ADD   = 4'b0001;
localparam ALU_SUB   = 4'b0010;
localparam ALU_AND   = 4'b0011;
localparam ALU_OR    = 4'b0100;
localparam ALU_XOR   = 4'b0101;
localparam ALU_SLL   = 4'b0110;
localparam ALU_SRL   = 4'b0111;

localparam ALU_EQ    = 4'b1000;

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
            $display("Calculating offset for Load/Store - alu_CU");
        end else if(alu_op == 2'b10) begin            
            alu_select = ALU_EQ;
            $display("Branch - alu_CU");
        end else begin
            $display("Unknown Task - alu_CU");
        end
    end

endmodule