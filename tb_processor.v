<<<<<<< HEAD
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
        #10 clk = ~clk; // Clock period of 10ns (5ns high, 5ns low)
        $display("-------------------CLK Change-----------------");
    end

    // Initial Stimulus
    initial begin
        clk = 0;   // Initialize clock
        reset = 0; // Assert reset
		
		#2
		reset = 1;

        #2
        reset = 0;

        // Run simulation for a certain duration
        #200; // Simulate for 200ns (20 clock cycles)
        $finish; // End simulation
    end

    // Monitor signals (for debugging and verification)
    initial begin
        // Dump waves for GTKWave
        $dumpfile("processor.vcd");
        $dumpvars(0, processor_tb); // Dump all signals in the testbench

        // Display key information
        $display("----------------------------------------");
        $display("Starting RISC-V Single-Cycle Processor Testbench");
        $display("Time  | PC        | Curr.Instruction | Next.Instruction| Regs[x2]| ALU_Out   | Mem_Out");
        $display("------+-----------+-------------+---------+---------+-----------+---------");

        // Monitor at regular intervals or on clock edges
        // Note: Using $monitor is good for simple prints, but can be verbose.
        // For detailed analysis, use GTKWave with the VCD file.
        $monitor("%0t | 0x%d | 0x%h | 0x%d | 0x%b | 0x%b ",
                 $time, dut.current_PC, dut.current_instr,
                 dut.alu_out, dut.alu_select, // Assuming x1, x2 are indices 1, 2
                 dut.reg_write_en);
        
        //$monitor("%0t | 0x%d", $time, dut.current_PC)

    end

=======
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
        #10 clk = ~clk; // Clock period of 10ns (5ns high, 5ns low)
        $display("-------------------CLK Change-----------------");
    end

    // Initial Stimulus
    initial begin
        clk = 0;   // Initialize clock
        reset = 0; // Assert reset
		
		#2
		reset = 1;

        #2
        reset = 0;

        // Run simulation for a certain duration
        #200; // Simulate for 200ns (20 clock cycles)
        $finish; // End simulation
    end

    // Monitor signals (for debugging and verification)
    initial begin
        // Dump waves for GTKWave
        $dumpfile("processor.vcd");
        $dumpvars(0, processor_tb); // Dump all signals in the testbench

        // Display key information
        $display("----------------------------------------");
        $display("Starting RISC-V Single-Cycle Processor Testbench");
        $display("Time  | PC        | Curr.Instruction | Next.Instruction| Regs[x2]| ALU_Out   | Mem_Out");
        $display("------+-----------+-------------+---------+---------+-----------+---------");

        // Monitor at regular intervals or on clock edges
        // Note: Using $monitor is good for simple prints, but can be verbose.
        // For detailed analysis, use GTKWave with the VCD file.
        $monitor("%0t | 0x%d | 0x%h | 0x%d | 0x%b | 0x%b ",
                 $time, dut.current_PC, dut.current_instr,
                 dut.alu_out, dut.alu_select, // Assuming x1, x2 are indices 1, 2
                 dut.reg_write_en);
        
        //$monitor("%0t | 0x%d", $time, dut.current_PC)

    end

>>>>>>> 628c9153ad1970f300b5de88177c32d846f1347a
endmodule