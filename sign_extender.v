/*
    Uses: 
        1. Immediate Values in Instructions
        2. Branch and Jump Targets (Relative Addressing)
        3. Function Call Conventions (Stack Pointers, Parameters) etc..
*/

module sign_extender (
    input [11:0] _12_bit_immediate_in,
    output [31:0] _32_bit_sign_extended_out
);
    assign _32_bit_sign_extended_out = {{20{_12_bit_immediate_in[11]}}, _12_bit_immediate_in};

endmodule