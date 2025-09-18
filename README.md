# SingleCycle_RISCV_processor
This aims to act like a real world computer processor with fewer instruction set.

Instructions followed from pg. 185 at [RISV_Instruction_Set](https://lists.riscv.org/g/tech-unprivileged/attachment/535/0/unpriv-isa-asciidoc.pdf)

All basic instructions like R TYPE, load, store and branch instructions.

<div style="background-color: blue;">
00000000000000000000000000000000         // No instruction at start
000000000100_00000_010_00010_0000011     // lw x2, 1(x0)    - count
000000001100_00000_010_00100_0000011     // lw x4, 3(x0)    - amount added = 1
000000001000_00000_010_00011_0000011     // lw x3, 2(x0)    - initial sum = 0
000000010000_00000_010_00101_0000011     // lw x5, 4(x0)    - initial count = 1
0000000_00101_00011_000_00011_0110011    // add x3, x3, x5
0000000_00100_00101_000_00101_0110011    // add x5, x5, x4
0_000000_00101_00010_000_1000_0_1100011  // beq x5, x2, 4
1_0000001100_0_00000000_00111_1101111    // jal x7, -12
0000000_00011_00000_010_00000_0100011    // sw x3, 0(x0)
</div>