module programCounter (
    input clk, reset,
    input [31:0] PC_next_in,
    output reg [31:0] PC_out
);

// Initializing
/* initial begin
        PC_out = 32'b0; // This initial block is commented out, which is good for sync reset
    end */


    always @(posedge clk, reset) begin // This is an asynchronous reset (positive edge of reset)
        if(reset) begin
            PC_out <= 32'b0; // Blocking assignment for reset is common, though non-blocking is safer practice
                            // for *all* assignments in sequential blocks for consistency
            $display("PC reset!");
        end
        else begin // This 'else' implies synchronous behavior for clock
            PC_out <= PC_next_in; // Non-blocking assignment - CORRECT for sequential logic
            $display("PC increased to 0x%h at time %t", PC_next_in, $time); // Better display message
        end
    end

endmodule