`include "opcodes.v"
`include "ALUop.v"


module ControlUnit (input [6:0] opcode,
                    output reg is_jal,
                    output reg is_jalr,
                    output reg branch,
                    output reg mem_read,
                    output reg mem_to_reg,
                    output reg mem_write,
                    output reg alu_src,
                    output reg write_enable,
                    output reg pc_to_reg,
                    output reg is_ecall);

    // Combinational logic for control signals
    always @(*) begin

        // TODO: is_jal
        if (0) is_jal = 1;
        else is_jal = 0;

        // TODO: is_jalr
        if (0) is_jalr = 1;
        else is_jalr = 0;

        // TODO: branch
        if (0) branch = 1;
        else branch = 0;
        
        // TODO: mem_read
        if (opcode == `LOAD) mem_read = 1;
        else mem_read = 0;

        // TODO: mem_to_reg
        if (opcode == `LOAD) mem_to_reg = 1;
        else mem_to_reg = 0;
        
        // TODO: mem_write
        if (0) mem_write = 1;
        else mem_write = 0;
        
        // alu_src
        if (opcode == `ARITHMETIC_IMM || opcode == `LOAD) alu_src = 1;
        else alu_src = 0;
        
        // write_enable
        if (opcode != `STORE && opcode != `BRANCH) write_enable = 1;
        else write_enable = 0;
        
        // TODO: pc_to_reg
        if (0) pc_to_reg = 1;
        else pc_to_reg = 0;
        
         // is_ecal
        if (opcode == `ECALL) is_ecall = 1;
        else is_ecall = 0;

    end
endmodule

module ALUControlUnit (input [6:0] opcode,
                       input [2:0] funct3,
                       input [6:0] funct7,
                       output reg [3:0] alu_op);
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
        // $display("opcode: %d", opcode); //! FOR DEBUGGIN
        if (0) begin
            // TODO: Branch Equal

        end else if (0) begin
            // TODO: Branch Not Equal

        end else if (0) begin
            // TODO: Less than

        end else if (0) begin
            // TODO: Greater than or equal

        end else if (((opcode == `ARITHMETIC || opcode == `ARITHMETIC_IMM) && funct3 == `FUNCT3_ADD) ||
                      (opcode == `LOAD && funct3 == `FUNCT3_LW)) begin
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