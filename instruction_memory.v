<<<<<<< HEAD
module instruction_memory (
    input  wire [31:0] addr,     
    output reg  [31:0] instr_out 
);

    reg [31:0] mem [0:7]; // 1024 words, 32 bits each (4KB instruction memory)

    // The file "instructions.mem" should contain hexadecimal MIPS instructions, one per line.
    initial begin
        $readmemh("instructions.mem", mem);
        $display("Instruction Memory loaded from instructions.mem");            
    end


    /* 
    There are 1024 bytes and the addresses go like 0x00000000 (points to first 32 bits or index 0), 
     0x00000004(next 32 bits), ... , 0x00000ffc(last 32 bits i.e last word or index 1023). 

        Note that 0x00000001 is not a valid address! 
        PC Output: The Program Counter (PC_out) gives you a byte address.
            If PC points to the first instruction, it will output 0x0000_0000.
            If PC points to the second instruction, it will output 0x0000_0004.
            If PC points to the last instruction (at 4KB - 4 bytes), it will output 0x0000_0FFC.
    */

    always @(*) begin
        if (addr[31:2] < 10) begin // Check if the word address is within memory bounds

            instr_out = mem[addr[31:2]]; // Use bits 31 down to 2 as the word address
            $display("Curr instr out: 0x%h", instr_out);
        end else begin
            instr_out = 32'hdeadbeef; // Or some other error indicator for out-of-bounds access
            $display("Error: Instruction memory address 0x%h out of bounds at time %t", addr, $time);
        end
    end

=======
module instruction_memory (
    input  wire [31:0] addr,     
    output reg  [31:0] instr_out 
);

    reg [31:0] mem [0:7]; // 1024 words, 32 bits each (4KB instruction memory)

    // The file "instructions.mem" should contain hexadecimal MIPS instructions, one per line.
    initial begin
        $readmemb("instructions.mem", mem);
        $display("Instruction Memory loaded from instructions.mem");            
    end


    /* 
    There are 1024 bytes and the addresses go like 0x00000000 (points to first 32 bits or index 0), 
     0x00000004(next 32 bits), ... , 0x00000ffc(last 32 bits i.e last word or index 1023). 

        Note that 0x00000001 is not a valid address! 
        PC Output: The Program Counter (PC_out) gives you a byte address.
            If PC points to the first instruction, it will output 0x0000_0000.
            If PC points to the second instruction, it will output 0x0000_0004.
            If PC points to the last instruction (at 4KB - 4 bytes), it will output 0x0000_0FFC.
    */

    always @(*) begin
        if (addr[31:2] < 10) begin // Check if the word address is within memory bounds

            instr_out = mem[addr[31:2]]; // Use bits 31 down to 2 as the word address
            $display("Curr instr out: 0x%h", instr_out);
        end else begin
            instr_out = 32'hdeadbeef; // Or some other error indicator for out-of-bounds access
            $display("Error: Instruction memory address 0x%h out of bounds at time %t", addr, $time);
        end
    end

>>>>>>> 628c9153ad1970f300b5de88177c32d846f1347a
endmodule