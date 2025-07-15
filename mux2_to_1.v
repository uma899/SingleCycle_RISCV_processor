module mux2_to_1 (
    input [31:0] in1, in2,
    input sel,
    output [31:0] selected_in
);
    assign selected_in = (sel == 1'b0) ? in1 : in2;
endmodule

// This is a helper used at many areas