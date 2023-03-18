`include "opcodes.v"

module ImmediateGenerator (input[31:0] inst,
                           output reg [31:0] imm_gen_out);

    wire [6:0] opcode;
    assign opcode = inst[6:0]; //* Double check syntax

    always @(*) begin
        if (opcode == `ARITHMETIC) begin
            // TODO
        end else if (opcode == `ARITHMETIC_IMM) begin
            // I-type
            imm_gen_out = { {20{inst[31]}}, inst[31:20] };
        end else if (opcode == `LOAD) begin
            // I-type
            imm_gen_out = { {20{inst[31]}}, inst[31:20] };
        end else if (opcode == `JALR) begin
            // TODO
        end else if (opcode == `STORE) begin
            // TODO
        end else if (opcode == `BRANCH) begin
            // TODO
        end else if (opcode == `JAL) begin
            // TODO
        end else if (opcode == `ECALL) begin
            // TODO
        end
    end


endmodule