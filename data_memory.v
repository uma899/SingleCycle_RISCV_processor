module data_memory (
    input clk, reset,
    input [31:0] addr,
    input [31:0] write_data_in,
    input mem_read_en, mem_write_en,
    //output reg [31:0] read_data_out
    output [31:0] read_data_out
);
    // Declare memory array
    // You declared 0:1024*1024, which is 1M words.
    // This is 4MB (1M words * 4 bytes/word).
    // The address range check (1024*256) is inconsistent with this declaration.
    // Let's assume you want 1M words, so the array is correctly declared for that.
    
    //reg [31:0] mem [0:(1024*1024)-1]; // Corrected: 0 to (1M - 1) for 1M words

    reg [31:0] mem [0:28];


    initial begin
        $readmemh("program.mem", mem);
        $display("Program Memory loaded from program.mem");            
    end

    always @(posedge clk) begin
        if (reset == 1) begin
            $display("Mem might be resettd :/ ");
        end
        else if (mem_write_en) begin
            // Add a boundary check for writes as well
            if (addr[31:2] < 28) begin // Check against the declared size (1M words)
                mem[addr[31:2]] <= write_data_in;

                $display("Mem wrote %d into %d + 1 mem block", write_data_in, addr[31:2]);

            end else begin
                $display("Error: Data Memory Write Address 0x%h out of bounds at time %t", addr, $time);
            end
        end 
        /* else begin
            $display("Unknown - mem");
        end     */
    end

/*     always @(*) begin
        if (mem_read_en) begin
            if (addr[31:2] < 28) begin
                    read_data_out = mem[addr[31:2]];
                    $display("Mem read at address: %d, value at this location: %d, value out: %d", addr[31:2], mem[addr[31:2]], read_data_out);
                end else begin
                read_data_out = 32'hdeadbeef; 
                $display("Error: Data Memory Read Address 0x%h out of bounds (max address 0x%h) at time %t", addr, (1024*1024*4)-1, $time); // Max byte address
            end
        end else read_data_out = 32'd0;
    end */

    assign read_data_out = (mem_read_en) ? mem[addr[31:2]] : 32'd0;

endmodule