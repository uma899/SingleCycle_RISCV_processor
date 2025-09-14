// processor_tb.v
`timescale 1ns / 1ps

module processor_tb;

    // Clock and Reset Signals
    reg clk;
    reg reset;

    // Instantiate the top-level processor module
    processor dut (
        .clk(clk),
        .reset(reset)
    );

    // Clock Generation
    always begin
        #10 clk = ~clk; // Clock period of 20ns
    end

    always @(posedge clk) begin
        $display("-------------------CLK Change-----------------");
    end

    // Initial Stimulus
    initial begin
        clk = 0;   // Initialize clock
        reset = 0; // Assert reset
		
		#15
		reset = 1;

        #10
        reset = 0;

        #200; // Simulate for 200ns (10 clock cycles)
        $finish; // End simulation
    end

    initial begin
        // $dumpfile("processor.vcd");
        // $dumpvars(0, processor_tb); // Dump all signals in the testbench

        $display("----------------------------------------");
        $display("Starting RISC-V Single-Cycle Processor Testbench");
        $display("Time  | PC        | Curr.Instruction | Next.Instruction| Regs[x2]| ALU_Out   | Mem_Out");
        $display("------+-----------+-------------+---------+---------+-----------+---------");

        $monitor("%0t | 0x%d | 0x%h | 0x%d | 0x%b | 0x%b ",
                 $time, dut.current_PC, dut.current_instr,
                 dut.alu_out, dut.alu_select,
                 dut.reg_write_en);
        
        $monitor("Current PC: 0x%d", dut.current_PC);

    end

endmodule