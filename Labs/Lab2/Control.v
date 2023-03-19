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

    //! Double check if this is allowed
    initial begin
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
    end

    // Combinational logic for control signals
    always @(*) begin

        if (0) begin
            // TODO: is_jal
            is_jal = 1;
        end

        if (0) begin
            // TODO: is_jalr
            is_jalr = 1;

        end
        
        if (0) begin
            // TODO: branch
            branch = 1;

        end
        
        if (0) begin
            // TODO: mem_read
            mem_read = 1;

        end
        
        if (0) begin
            // TODO: mem_to_reg
            mem_to_reg = 1;

        end
        
        if (0) begin
            // TODO: mem_write
            mem_write = 1;

        end
        
        if (opcode == `ARITHMETIC_IMM) begin
            // TODO: alu_src
            alu_src = 1;

        end
        
        if (opcode != `STORE && opcode != `BRANCH) begin
            // TODO: write_enable
            write_enable = 1;

        end
        
        if (0) begin
            // TODO: pc_to_reg
            pc_to_reg = 1;

        end
        
        if (opcode == `ECALL) begin
            // TODO: is_ecal
            is_ecall = 1;
        end
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

        end else if ((opcode == `ARITHMETIC || opcode == `ARITHMETIC_IMM) && funct3 == `FUNCT3_ADD && funct7 == `FUNCT7_OTHERS) begin
            // TODO: Addition
            alu_op = `FUNC_ADD;

        end else if ((opcode == `ARITHMETIC) && funct3 == `FUNCT3_SUB && funct7 == `FUNCT7_SUB) begin
            // TODO: Subtraction
            alu_op = `FUNC_SUB;

        end else if ((opcode == `ARITHMETIC || opcode == `ARITHMETIC_IMM) && funct3 == `FUNCT3_SRL && funct7 == `FUNCT7_SUB) begin
            // TODO: Arithemetic RIght Shift
            alu_op = `FUNC_ARS;

        end else if ((opcode == `ARITHMETIC || opcode == `ARITHMETIC_IMM) && funct3 == `FUNCT3_SLL && funct7 == `FUNCT7_OTHERS) begin
            // TODO: Logical Left Shift
            alu_op = `FUNC_LLS;

        end else if ((opcode == `ARITHMETIC || opcode == `ARITHMETIC_IMM) && funct3 == `FUNCT3_SRL && funct7 == `FUNCT7_OTHERS) begin
            // TODO: Logical Right Shift
            alu_op = `FUNC_LRS;

        end else if ((opcode == `ARITHMETIC || opcode == `ARITHMETIC_IMM) && funct3 == `FUNCT3_XOR && funct7 == `FUNCT7_OTHERS) begin
            // TODO: XOR
            alu_op = `FUNC_XOR;

        end else if ((opcode == `ARITHMETIC || opcode == `ARITHMETIC_IMM) && funct3 == `FUNCT3_OR && funct7 == `FUNCT7_OTHERS) begin
            // TODO: OR
            alu_op = `FUNC_OR;

        end else if ((opcode == `ARITHMETIC || opcode == `ARITHMETIC_IMM) && funct3 == `FUNCT3_AND && funct7 == `FUNCT7_OTHERS) begin
            // TODO: AND
            alu_op = `FUNC_AND;
        end
    end
    

endmodule