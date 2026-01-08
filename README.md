# SingleCycle_RISCV_processor
This aims to act like a real world computer processor with fewer instruction set.

Instructions followed from pg. 185 at [RISV_Instruction_Set](https://lists.riscv.org/g/tech-unprivileged/attachment/535/0/unpriv-isa-asciidoc.pdf#page=194)

All basic instructions like R TYPE, load, store and branch instructions.

## Test cases
Few tests were ran to check this processor's functionality.

| S. No. | TestCase | Used instructions |
|:-----------|:------------:|------------:|
| 1     | Sum of 10 whole numbers       | Load, add, branch, jump, store      |

Complete instructions used and outputs can be found at [Simulation Logs](https://uma899.github.io/SingleCycle_RISCV_processor/) - Test cases are yet to be added

## Further development
Still ADDI, LUI type instructions need to be implemented. Looking forward to make this pipelined and add few more modules like branch predictors, cache etc..
