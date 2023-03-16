`include "opcodes.v"


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

        if (part_of_inst... ) begin
            // TODO: is_jal
            is_jal = 1;
        end else if (part_of_inst... ) begin
            // TODO: is_jalr
            is_jalr = 1;
        end else if (part_of_inst... ) begin
            // TODO: branch
            branch = 1;
        end else if (part_of_inst... ) begin
            // TODO: mem_read
            mem_read = 1;
        end else if (part_of_inst... ) begin
            // TODO: mem_to_reg
            mem_to_reg = 1;
        end else if (part_of_inst... ) begin
            // TODO: mem_write
            mem_write = 1;
        end else if (part_of_inst... ) begin
            // TODO: alu_src
            alu_src = 1;
        end else if (part_of_inst... ) begin
            // TODO: write_enable
            write_enable = 1;
        end else if (part_of_inst... ) begin
            // TODO: pc_to_reg
            pc_to_reg = 1;
        end else if (part_of_inst... ) begin
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
        if (...) begin
            // TODO: Branch Equal
        end else if (...) begin
            // TODO: Branch Not Equal
        end else if (...) begin
            // TODO: Less than
        end else if (...) begin
            // TODO: Greater than or equal
        end else if (...) begin
            // TODO: Addition
        end else if (...) begin
            // TODO: Subtraction
        end else if (...) begin
            // TODO: Logical Left Shift
        end else if (...) begin
            // TODO: Logical Right Shift
        end else if (...) begin
            // TODO: XOR
        end else if (...) begin
            // TODO: OR
        end else if (...) begin
            // TODO: AND
        end
    
    end
    

endmodule