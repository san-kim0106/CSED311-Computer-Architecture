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
    always @(opcode) begin

        // TODO: is_jal
        if (opcode == `JAL) begin
            is_jal = 1;
        end
        else is_jal = 0;

        // TODO: is_jalr
        if (opcode == `JALR) is_jalr = 1;
        else is_jalr = 0;

        // TODO: branch
        if (opcode == `BRANCH) branch = 1;
        else branch = 0;
        
        // TODO: mem_read
        if (opcode == `LOAD) mem_read = 1;
        else mem_read = 0;

        // TODO: mem_to_reg
        if (opcode == `LOAD) mem_to_reg = 1;
        else mem_to_reg = 0;
        
        // TODO: mem_write
        if (opcode == `STORE) mem_write = 1;
        else mem_write = 0;
        
        // alu_src
        if (opcode == `ARITHMETIC_IMM || opcode == `LOAD || opcode == `STORE) alu_src = 1;
        else alu_src = 0;

        //! DEDUBGGING PURPOSES
        // if (opcode == `ARITHMETIC) $display("ARITHMETIC"); //! FOR DEBUGGING
        // if (opcode == `ARITHMETIC_IMM) $display("ARITHMETIC_IMM"); //! FOR DEBUGGING
        // if (opcode == `LOAD) $display("LOAD"); //! FOR DEBUGGING
        // if (opcode == `STORE) $display("STORE"); //! FOR DEBUGGING
        // if (opcode == `JAL) $display("JAL"); //! FOR DEBUGGING
        // if (opcode == `JALR) $display("JALR"); //! FOR DEBUGGING
        //! ----------------------------------
        
        // write_enable
        if (opcode != `STORE && opcode != `BRANCH) write_enable = 1;
        else write_enable = 0;
        
        // TODO: pc_to_reg
        if (opcode == `JAL || opcode == `JALR) pc_to_reg = 1;
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
        // $display("opcode: %d", opcode); //! FOR DEBUGGING
        if ((opcode == `BRANCH) && funct3 == `FUNCT3_BEQ) begin
            // TODO: Branch Equal
            alu_op = `FUNC_BEQ;

        end else if (0) begin
            // TODO: Branch Not Equal

        end else if (0) begin
            // TODO: Less than

        end else if (0) begin
            // TODO: Greater than or equal

        end else if (((opcode == `ARITHMETIC || opcode == `ARITHMETIC_IMM) && funct3 == `FUNCT3_ADD) ||
                      (opcode == `LOAD && funct3 == `FUNCT3_LW) ||
                      (opcode == `STORE)) begin
            // Addition
            alu_op = `FUNC_ADD;
        
        end else if (opcode == `JALR) begin
            alu_op = `FUNC_JALR;

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