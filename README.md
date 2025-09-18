# SingleCycle_RISCV_processor
This aims to act like a real world computer processor with fewer instruction set.

Instructions followed from pg. 185 at [RISV_Instruction_Set](https://lists.riscv.org/g/tech-unprivileged/attachment/535/0/unpriv-isa-asciidoc.pdf)

All basic instructions like R TYPE, load, store and branch instructions.


> 00000000000000000000000000000000         // No instruction at start
> 000000000100_00000_010_00010_0000011     // lw x2, 1(x0)    - count
> 000000001100_00000_010_00100_0000011     // lw x4, 3(x0)    - amount added = 1
> 000000001000_00000_010_00011_0000011     // lw x3, 2(x0)    - initial sum = 0
> 000000010000_00000_010_00101_0000011     // lw x5, 4(x0)    - initial count = 1
> 0000000_00101_00011_000_00011_0110011    // add x3, x3, x5
> 0000000_00100_00101_000_00101_0110011    // add x5, x5, x4
> 0_000000_00101_00010_000_1000_0_1100011  // beq x5, x2, 4
> 1_0000001100_0_00000000_00111_1101111    // jal x7, -12
> 0000000_00011_00000_010_00000_0100011    // sw x3, 0(x0)

# Running simulation...
# Instruction Memory loaded from instructions.mem
# Program Memory loaded from program.mem
# ----------------------------------------
# Starting RISC-V Single-Cycle Processor Testbench
# Time  | PC        | Curr.Instruction | Next.Instruction| Regs[x2]| ALU_Out   | Mem_Out
# ------+-----------+-------------+---------+---------+-----------+---------
# PC reset!
# Error: Instruction memory address 0xxxxxxxxx out of bounds at time                    0
# Unknown Task - alu_CU
# J type - from CU
# Unkown case - alu_CU
# ADD worked, result:          x
# Curr instr out: 0x00000000
# ADD - alu_CU
# Unknown Opcode - Control Unit
# ADD worked, result:          0
# Current PC: 0x         0
# Initial Register status
# Address     |   Value
# 00000000   |          0
# 00000001   |          x
# 00000002   |          x
# 00000003   |          x
# 00000004   |          x
# 00000005   |          x
# 00000006   |          x
# 00000007   |          x
# Initial Mem status
# Address     |   Value
# 00000000   |          1
# 00000001   |         10
# 00000002   |          0
# 00000003   |          1
# 00000004   |          1
# 00000005   | 3735928559
# -------------------CLK Change-----------------
# Curr instr out: 0x00402103
# SLT - alu_CU
# L type - from CU
# Calculating offset for Load/Store - alu_CU
# ADD worked, result:          4
# Current PC: 0x         4
# Reg File wrote 10 at, 2
# -------------------CLK Change-----------------
# Curr instr out: 0x00c02203
# ADD worked, result:         12
# Current PC: 0x         8
# Reg File wrote 1 at, 4
# -------------------CLK Change-----------------
# Curr instr out: 0x00802183
# ADD worked, result:          8
# Current PC: 0x        12
# Reg File wrote 0 at, 3
# -------------------CLK Change-----------------
# Curr instr out: 0x01002283
# ADD worked, result:         16
# Current PC: 0x        16
# Reg File wrote 1 at, 5
# -------------------CLK Change-----------------
# Curr instr out: 0x005181b3
# ADD worked, result:          5
# Calculating offset for Load/Store - alu_CU
# R type - from CU
# ADD - alu_CU
# ADD worked, result:          1
# Current PC: 0x        20
# Reg File wrote 1 at, 3
# -------------------CLK Change-----------------
# Curr instr out: 0x004282b3
# ADD worked, result:          2
# Current PC: 0x        24
# Reg File wrote 2 at, 5
# -------------------CLK Change-----------------
# Curr instr out: 0x00510863
# B type - from CU
# ADD worked, result:          3
# Branch - alu_CU
# ADD worked, result:         12
# Equal worked:          1, compared         10          2
# Current PC: 0x        28
# -------------------CLK Change-----------------
# Curr instr out: 0x818003ef
# Branch - alu_CU
# J type - from CU
# Unkown case - alu_CU
# Equal worked:          X, compared          0          x
# ADD worked, result:          x
# Current PC: 0x        32
# Reg File wrote 36 at, 7
# -------------------CLK Change-----------------
# Curr instr out: 0x005181b3
# ADD - alu_CU
# R type - from CU
# ADD worked, result:          3
# Current PC: 0x        20
# Reg File wrote 3 at, 3
# -------------------CLK Change-----------------
# Curr instr out: 0x004282b3
# ADD worked, result:          5
# ADD worked, result:          3
# Current PC: 0x        24
# Reg File wrote 3 at, 5
# -------------------CLK Change-----------------
# Curr instr out: 0x00510863
# B type - from CU
# ADD worked, result:          4
# Branch - alu_CU
# ADD worked, result:         13
# Equal worked:          1, compared         10          3
# Current PC: 0x        28
# -------------------CLK Change-----------------
# Curr instr out: 0x818003ef
# Branch - alu_CU
# J type - from CU
# Unkown case - alu_CU
# Equal worked:          X, compared          0          x
# ADD worked, result:          x
# Current PC: 0x        32
# Reg File wrote 36 at, 7
# -------------------CLK Change-----------------
# Curr instr out: 0x005181b3
# ADD - alu_CU
# R type - from CU
# ADD worked, result:          6
# Current PC: 0x        20
# Reg File wrote 6 at, 3
# -------------------CLK Change-----------------
# Curr instr out: 0x004282b3
# ADD worked, result:          9
# ADD worked, result:          4
# Current PC: 0x        24
# Reg File wrote 4 at, 5
# -------------------CLK Change-----------------
# Curr instr out: 0x00510863
# B type - from CU
# ADD worked, result:          5
# Branch - alu_CU
# ADD worked, result:         14
# Equal worked:          1, compared         10          4
# Current PC: 0x        28
# -------------------CLK Change-----------------
# Curr instr out: 0x818003ef
# Branch - alu_CU
# J type - from CU
# Unkown case - alu_CU
# Equal worked:          X, compared          0          x
# ADD worked, result:          x
# Current PC: 0x        32
# Reg File wrote 36 at, 7
# -------------------CLK Change-----------------
# Curr instr out: 0x005181b3
# ADD - alu_CU
# R type - from CU
# ADD worked, result:         10
# Current PC: 0x        20
# Reg File wrote 10 at, 3
# -------------------CLK Change-----------------
# Curr instr out: 0x004282b3
# ADD worked, result:         14
# ADD worked, result:          5
# Current PC: 0x        24
# Reg File wrote 5 at, 5
# -------------------CLK Change-----------------
# Curr instr out: 0x00510863
# B type - from CU
# ADD worked, result:          6
# Branch - alu_CU
# ADD worked, result:         15
# Equal worked:          1, compared         10          5
# Current PC: 0x        28
# -------------------CLK Change-----------------
# Curr instr out: 0x818003ef
# Branch - alu_CU
# J type - from CU
# Unkown case - alu_CU
# Equal worked:          X, compared          0          x
# ADD worked, result:          x
# Current PC: 0x        32
# Reg File wrote 36 at, 7
# -------------------CLK Change-----------------
# Curr instr out: 0x005181b3
# ADD - alu_CU
# R type - from CU
# ADD worked, result:         15
# Current PC: 0x        20
# Reg File wrote 15 at, 3
# -------------------CLK Change-----------------
# Curr instr out: 0x004282b3
# ADD worked, result:         20
# ADD worked, result:          6
# Current PC: 0x        24
# Reg File wrote 6 at, 5
# -------------------CLK Change-----------------
# Curr instr out: 0x00510863
# B type - from CU
# ADD worked, result:          7
# Branch - alu_CU
# ADD worked, result:         16
# Equal worked:          1, compared         10          6
# Current PC: 0x        28
# -------------------CLK Change-----------------
# Curr instr out: 0x818003ef
# Branch - alu_CU
# J type - from CU
# Unkown case - alu_CU
# Equal worked:          X, compared          0          x
# ADD worked, result:          x
# Current PC: 0x        32
# Reg File wrote 36 at, 7
# -------------------CLK Change-----------------
# Curr instr out: 0x005181b3
# ADD - alu_CU
# R type - from CU
# ADD worked, result:         21
# Current PC: 0x        20
# Reg File wrote 21 at, 3
# -------------------CLK Change-----------------
# Curr instr out: 0x004282b3
# ADD worked, result:         27
# ADD worked, result:          7
# Current PC: 0x        24
# Reg File wrote 7 at, 5
# -------------------CLK Change-----------------
# Curr instr out: 0x00510863
# B type - from CU
# ADD worked, result:          8
# Branch - alu_CU
# ADD worked, result:         17
# Equal worked:          1, compared         10          7
# Current PC: 0x        28
# -------------------CLK Change-----------------
# Curr instr out: 0x818003ef
# Branch - alu_CU
# J type - from CU
# Unkown case - alu_CU
# Equal worked:          X, compared          0          x
# ADD worked, result:          x
# Current PC: 0x        32
# Reg File wrote 36 at, 7
# -------------------CLK Change-----------------
# Curr instr out: 0x005181b3
# ADD - alu_CU
# R type - from CU
# ADD worked, result:         28
# Current PC: 0x        20
# Reg File wrote 28 at, 3
# -------------------CLK Change-----------------
# Curr instr out: 0x004282b3
# ADD worked, result:         35
# ADD worked, result:          8
# Current PC: 0x        24
# Reg File wrote 8 at, 5
# -------------------CLK Change-----------------
# Curr instr out: 0x00510863
# B type - from CU
# ADD worked, result:          9
# Branch - alu_CU
# ADD worked, result:         18
# Equal worked:          1, compared         10          8
# Current PC: 0x        28
# -------------------CLK Change-----------------
# Curr instr out: 0x818003ef
# Branch - alu_CU
# J type - from CU
# Unkown case - alu_CU
# Equal worked:          X, compared          0          x
# ADD worked, result:          x
# Current PC: 0x        32
# Reg File wrote 36 at, 7
# -------------------CLK Change-----------------
# Curr instr out: 0x005181b3
# ADD - alu_CU
# R type - from CU
# ADD worked, result:         36
# Current PC: 0x        20
# Reg File wrote 36 at, 3
# -------------------CLK Change-----------------
# Curr instr out: 0x004282b3
# ADD worked, result:         44
# ADD worked, result:          9
# Current PC: 0x        24
# Reg File wrote 9 at, 5
# -------------------CLK Change-----------------
# Curr instr out: 0x00510863
# B type - from CU
# ADD worked, result:         10
# Branch - alu_CU
# ADD worked, result:         19
# Equal worked:          1, compared         10          9
# Current PC: 0x        28
# -------------------CLK Change-----------------
# Curr instr out: 0x818003ef
# Branch - alu_CU
# J type - from CU
# Unkown case - alu_CU
# Equal worked:          X, compared          0          x
# ADD worked, result:          x
# Current PC: 0x        32
# Reg File wrote 36 at, 7
# -------------------CLK Change-----------------
# Curr instr out: 0x005181b3
# ADD - alu_CU
# R type - from CU
# ADD worked, result:         45
# Current PC: 0x        20
# Reg File wrote 45 at, 3
# -------------------CLK Change-----------------
# Curr instr out: 0x004282b3
# ADD worked, result:         54
# ADD worked, result:         10
# Current PC: 0x        24
# Reg File wrote 10 at, 5
# -------------------CLK Change-----------------
# Curr instr out: 0x00510863
# B type - from CU
# ADD worked, result:         11
# Branch - alu_CU
# ADD worked, result:         20
# Equal worked:          0, compared         10         10
# Current PC: 0x        28
# Branch Taken
# -------------------CLK Change-----------------
# Curr instr out: 0x00302023
# Branch - alu_CU
# S type - from CU
# Calculating offset for Load/Store - alu_CU
# Equal worked:          0, compared          0          0
# ADD worked, result:          0
# Current PC: 0x        36
# Mem wrote         45 into          0 mem block
# -------------------CLK Change-----------------
# Curr instr out: 0xxxxxxxxx
# ADD worked, result:          x
# Calculating offset for Load/Store - alu_CU
# Unknown Opcode - Control Unit
# ADD worked, result:          x
# Unkown case - alu_CU
# Current PC: 0x        40
# -------------------CLK Change-----------------
# Curr instr out: 0xxxxxxxxx
# Current PC: 0x        44
# -------------------CLK Change-----------------
# Curr instr out: 0xxxxxxxxx
# Current PC: 0x        48
# -------------------CLK Change-----------------
# Curr instr out: 0xxxxxxxxx
# Current PC: 0x        52
# -------------------CLK Change-----------------
# Curr instr out: 0xxxxxxxxx
# Current PC: 0x        56
# -------------------CLK Change-----------------
# Curr instr out: 0xxxxxxxxx
# Current PC: 0x        60
# Initial Register status
# Address     |   Value
# 00000000   |          0
# 00000001   |          x
# 00000002   |         10
# 00000003   |         45
# 00000004   |          1
# 00000005   |         10
# 00000006   |          x
# 00000007   |         36
# Final Mem status
# Address     |   Value
# 00000000   |         45
# 00000001   |         10
# 00000002   |          0
# 00000003   |          1
# 00000004   |          1
# 00000005   | 3735928559
# -------------------CLK Change-----------------
# Curr instr out: 0xxxxxxxxx
# Current PC: 0x        64
# -------------------CLK Change-----------------
# Curr instr out: 0xxxxxxxxx
# Stopping transcript logging.
</div>