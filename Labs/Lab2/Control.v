`include "opcodes.v"
`incldue "ALUop.v"


module ControlUnit (input [6:0] opcode,
                    output is_jal,
                    output is_jalr,
                    output branch,
                    output mem_read,
                    output mem_to_reg,
                    output mem_write,
                    output alu_src,
                    output write_enable,
                    output pc_to_reg,
                    output is_ecall);

    // Combinational logic for control signals
    always @(*) begin
        // Initialize the outputs to LOW
        is_jal = 0;
        is_jalr = 0;
        branch = 0;
        mem_read = 0;
        mem_to_reg = 0;
        mem_write = 0;
        alu_src = 0;
        write_enable = 0;
        pc_to_reg = 0;
        is_ecall = 0;

        if (0) begin
            // TODO: is_jal
            is_jal = 1;

        end else if (0) begin
            // TODO: is_jalr
            is_jalr = 1;

        end else if (0) begin
            // TODO: branch
            branch = 1;

        end else if (0) begin
            // TODO: mem_read
            mem_read = 1;

        end else if (0) begin
            // TODO: mem_to_reg
            mem_to_reg = 1;

        end else if (0) begin
            // TODO: mem_write
            mem_write = 1;

        end else if (0) begin
            // TODO: alu_src
            alu_src = 1;

        end else if (opcode != `STORE && opcode != `BRANCH) begin
            // TODO: write_enable
            write_enable = 1;

        end else if (0) begin
            // TODO: pc_to_reg
            pc_to_reg = 1;

        end else if (0) begin
            // TODO: is_ecal
            is_ecall = 1;
        end
    end
endmodule

module ALUControlUnit (input [6:0] opcode,
                       input [2:0] funct3,
                       input [6:0] funct7,
                       output [3:0] alu_op);
    /*
    alu_op types
        - Branch Equal
        - Branch Not Equal
        - Less than
        - Greater than or equal
        - Addition
        - Subtraction
        - Logical Left Shift
        - Logical Right Shift
        - XOR
        - OR
        - AND
    */
    
    // Combinational Logic
    always @(*) begin
        if (0) begin
            // TODO: Branch Equal

        end else if (0) begin
            // TODO: Branch Not Equal

        end else if (0) begin
            // TODO: Less than

        end else if (0) begin
            // TODO: Greater than or equal

        end else if (opcode == `ARITHMETIC && funct3 == `FUNCT3_ADD && funct7 == `FUNCT7_OTHERS) begin
            // TODO: Addition
            alu_op = `FUNC_ADD;

        end else if (0) begin
            // TODO: Subtraction

        end else if (0) begin
            // TODO: Logical Left Shift

        end else if (0) begin
            // TODO: Logical Right Shift

        end else if (0) begin
            // TODO: XOR

        end else if (0) begin
            // TODO: OR

        end else if (0) begin
            // TODO: AND
        end
    end
    

endmodule