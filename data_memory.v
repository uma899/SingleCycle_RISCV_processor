module data_memory (
    input clk, reset,
    input [31:0] addr,
    input [31:0] write_data_in,
    input mem_read_en, mem_write_en,
    output reg [31:0] read_data_out
);
    // Declare memory array
    // You declared 0:1024*1024, which is 1M words.
    // This is 4MB (1M words * 4 bytes/word).
    // The address range check (1024*256) is inconsistent with this declaration.
    // Let's assume you want 1M words, so the array is correctly declared for that.
    
    //reg [31:0] mem [0:(1024*1024)-1]; // Corrected: 0 to (1M - 1) for 1M words

    reg [31:0] mem [0:15];

    // Optional: Initialize memory content for simulation
   /* initial begin
        integer i;
        for (i = 0; i < (1024*1024); i = i + 1) begin
            mem[i] = 32'hdeadbeef; // Initialize with a known value for debugging
        end
        // If you want to load from a file:
        // $readmemh("data.mem", mem);
    end*/

    initial begin
        $readmemb("program.mem", mem);
        $display("Program Memory loaded from program.mem");            
    end

    // Synchronous Write Logic
    always @(posedge clk) begin
        if (reset == 1) begin
            //$readmemb("program.mem", mem);
            //$display("Program Memory loaded from program.mem");            

            $display("Mem might be resettd :/ ");
        end
        else if (mem_write_en) begin
            // Add a boundary check for writes as well
            if (addr[31:2] < 16) begin // Check against the declared size (1M words)
                mem[addr[31:2]] <= write_data_in;

                $display("Mem write into address: %d", addr[31:2]);

            end else begin
                $display("Error: Data Memory Write Address 0x%h out of bounds at time %t", addr, $time);
            end
        end
    end

    // Combinational Read Logic
    always @(*) begin
        // Check bounds first, then check read enable
        if (mem_read_en) begin
            if (addr[31:2] < 16) begin // Check against the declared size (1M words)
                    read_data_out = mem[addr[31:2]];
                    $display("Mem read at address: %d, value at this location: ", addr[31:2], mem[addr[31:2]]);
                end else begin
                // Out-of-bounds access for read
                read_data_out = 32'hdeadbeef; // Indicates an error or invalid read
                $display("Error: Data Memory Read Address 0x%h out of bounds (max address 0x%h) at time %t", addr, (1024*1024*4)-1, $time); // Max byte address
            end
        end else begin
                // If not reading, output should be 'X' or 0, not garbage or previous value.
                // A common practice is to output 0 when not reading, or to only
                // update read_data_out when mem_read_en is high.
                // If you want it to retain its last value when mem_read_en is low,
                // you would need to declare read_data_out as a wire and use tri-state
                // buffers, but that's more complex than typical for single-cycle memory model.
                // For a simpler model, setting to 0 or 'x' when not explicitly reading is fine.
                read_data_out = 32'b0; // Or 32'hx for unknown/don't care
        end
    end

endmodule