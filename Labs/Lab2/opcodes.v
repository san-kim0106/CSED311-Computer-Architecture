// The constants below are from riscv spec
// Please do not change the values

// OPCODE
// R-type instruction opcodes
`define ARITHMETIC      7'b0110011

// I-type instruction opcodes
`define ARITHMETIC_IMM  7'b0010011
`define LOAD            7'b0000011
`define JALR            7'b1100111

// S-type instruction opcodes
`define STORE           7'b0100011

// B-type instruction opcodes
`define BRANCH          7'b1100011

// U-type instruction opcodes
//`define LUI             7'b0110111
//`define AUIPC           7'b0010111

// J-type instruction opcodes
`define JAL             7'b1101111

`define ECALL           7'b1110011

// FUNCT3
`define FUNCT3_BEQ      3'b000 // Branch if Equal
`define FUNCT3_BNE      3'b001 // Branch if Not Equal
`define FUNCT3_BLT      3'b100 // Branch if registers rs1 is less than rs2, using signed comparison.
`define FUNCT3_BGE      3'b101 // Branch if registers rs1 is greater than or equal to rs2, using signed comparison.

`define FUNCT3_LW       3'b010 // Load Word
`define FUNCT3_SW       3'b010 // Store

`define FUNCT3_ADD      3'b000 // Add
`define FUNCT3_SUB      3'b000 // Subtract
`define FUNCT3_SLL      3'b001 // Logical Left Shift
`define FUNCT3_XOR      3'b100 // Logical XOR
`define FUNCT3_OR       3'b110 // Logical OR
`define FUNCT3_AND      3'b111 // Logical AND
`define FUNCT3_SRL      3'b101 // Logical Right Shift

// FUNCT7
`define FUNCT7_SUB      7'b0100000
`define FUNCT7_OTHERS   7'b0000000
