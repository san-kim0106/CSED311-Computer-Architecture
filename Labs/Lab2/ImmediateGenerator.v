`include "opcodes.v"

module ImmediateGenerator (input[31:0] inst,
                           output reg [31:0] imm_gen_out);

    wire [6:0] opcode;
    assign opcode = inst[6:0];

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
            // I-type
            imm_gen_out = { {20{inst[31]}}, inst[31:20] };

        end else if (opcode == `STORE) begin
            // S-type
               imm_gen_out = { {20{inst[31]}} , inst[31:25] , inst[11:7] };
            // $display("S-type sign-extension: %d", imm_gen_out); //! FOR DEBUGGING

        end else if (opcode == `BRANCH) begin
            // TODO
            // $display("Check Branch");
            imm_gen_out = { {19{inst[31]}}, inst[31], inst[6], inst[30:25], inst[11:8], 1'b0 };

        end else if (opcode == `JAL) begin
            // UJ-Type
            imm_gen_out = { {11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0 };

        end else if (opcode == `ECALL) begin
            // TODO
        end
    end


endmodule