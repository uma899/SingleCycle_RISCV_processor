module register_file (
    input clk, reset,
    input [4:0] read_reg1_addr,
    input [4:0] read_reg2_addr,
    input [4:0] write_reg_addr,
    input [31:0] write_data,
    input reg_write_en,
    output reg [31:0] read_data1,
    output reg [31:0] read_data2 
);

    reg [31:0] temp_reg [0:31];
    always @(posedge clk, reset) begin
        if (reset) begin
			temp_reg[0] = 32'b0;  // Others are uninitialised

            /* Dummy data initialised */
            // temp_reg[3] = 32'd4;
            // temp_reg[4] = 32'd12;
            // temp_reg[11] = 32'd24;
            // temp_reg[12] = 32'd8;

            // $display("Reg File reset!");
            
        end else if (reg_write_en && !reset) begin
            if (write_reg_addr != 5'b0) begin
                temp_reg[write_reg_addr] <= write_data;

                $display("Reg File wrote %0d at, %0d", write_data, write_reg_addr);
            end
        end

        //else $display("Unknown - Reg file");
    end

    // 3. Asynchronous/Combinational Read Logic
    // Reads should happen instantaneously (combinational) whenever the read addresses change.
    // They do NOT depend on the clock edge.
    // R0 (read_reg1_addr == 0 or read_reg2_addr == 0) should always output 0.
    always @(*) begin // Sensitive to any change in read_reg1_addr or read_reg2_addr
        if (read_reg1_addr == 5'b0) begin
            read_data1 = 32'b0; // R0 always reads as 0
        end else begin
            read_data1 = temp_reg[read_reg1_addr];

            //$display("x%d read1 - Reg File ", read_reg1_addr);
        end

        if (read_reg2_addr == 5'b0) begin
            read_data2 = 32'b0; // R0 always reads as 0
        end else begin
            read_data2 = temp_reg[read_reg2_addr];

            //$display("x%d read2 - Reg File ", read_reg2_addr);
        end
    end

endmodule