`include "opcodes.v"
`include "ALUop.v"

module ControlUnit (input [6:0] opcode,
                    input stall,
                    input bubble,
                    input is_halted,
                    input [1:0] pc_src,
                    output reg is_jal,
                    output reg is_jalr,
                    output reg is_input_valid,
                    output reg branch,
                    output reg mem_read,
                    output reg mem_to_reg,
                    output reg mem_write,
                    output reg alu_src,
                    output reg write_enable,
                    output reg is_ecall);

    // Combinational logic for control signals
    always @(*) begin

        // is_jal
        if (opcode == `JAL) is_jal = 1;
        else is_jal = 0;

        // is_jalr
        if (opcode == `JALR) is_jalr = 1;
        else is_jalr = 0;

        // branch
        if (opcode == `BRANCH) branch = 1;
        else branch = 0;
        
        // mem_read
        if (opcode == `LOAD) mem_read = 1;
        else mem_read = 0;

        // mem_to_reg
        if (opcode == `LOAD) mem_to_reg = 1;
        else mem_to_reg = 0;
        
        // mem_write
        if (opcode == `STORE) mem_write = 1;
        else mem_write = 0;

        if (opcode == `STORE || opcode == `LOAD) is_input_valid = 1;
        else is_input_valid = 0;
        
        // alu_src
        if (opcode == `ARITHMETIC_IMM || opcode == `LOAD || opcode == `STORE || opcode == `JALR) alu_src = 1;
        else alu_src = 0;

        //! DEDUBGGING PURPOSES
        // if (opcode == `ARITHMETIC) $display("ARITHMETIC"); //! FOR DEBUGGING
        // if (opcode == `ARITHMETIC_IMM) $display("ARITHMETIC_IMM"); //! FOR DEBUGGING
        // if (opcode == `LOAD) $display("LOAD"); //! FOR DEBUGGING
        // if (opcode == `STORE) $display("STORE"); //! FOR DEBUGGING
        // if (opcode == `JAL) $display("JAL\n"); //! FOR DEBUGGING
        // if (opcode == `JALR) $display("JALR\n"); //! FOR DEBUGGING
        // if (opcode == `BRANCH) $display("BRANCH\n"); //! FOR DEBUGGIN
        //! ----------------------------------
        
        // write_enable
        if (opcode != `STORE && opcode != `BRANCH && opcode != `ECALL && opcode != 32'b0) write_enable = 1;
        else write_enable = 0;
        
         // is_ecal
        if (opcode == `ECALL) is_ecall = 1;
        else is_ecall = 0;

        if (stall || pc_src || bubble || is_halted) begin
            mem_read = 0;
            write_enable = 0;
            mem_write = 0;
            is_jal = 0;
            is_jalr = 0;
            branch = 0;

        end

    end
endmodule

module ALUControlUnit (input [6:0] opcode,
                       input [2:0] funct3,
                       input [6:0] funct7,
                       output reg [3:0] alu_op);

    // Combinational Logic
    always @(*) begin
        // $display("opcode: %d", opcode); //! FOR DEBUGGING
        if (opcode == `BRANCH && funct3 == `FUNCT3_BEQ) begin
           alu_op = `FUNC_BEQ; // BEQ

        end else if (opcode == `BRANCH && funct3 == `FUNCT3_BNE) begin
            alu_op = `FUNC_BNE; // BNE

        end else if (opcode == `BRANCH && funct3 == `FUNCT3_BLT) begin
            alu_op = `FUNC_BLT; // BLT

        end else if (opcode == `BRANCH && funct3 == `FUNCT3_BGE) begin
            alu_op = `FUNC_BGE; // BGE

        end else if (((opcode == `ARITHMETIC || opcode == `ARITHMETIC_IMM) && funct3 == `FUNCT3_ADD && funct7 != `FUNCT7_SUB) ||
                      (opcode == `LOAD && funct3 == `FUNCT3_LW) ||
                      (opcode == `STORE)) begin
            alu_op = `FUNC_ADD; // Addition
        
        end else if (opcode == `JALR) begin
            alu_op = `FUNC_JALR; // JALR

        end else if ((opcode == `ARITHMETIC) && funct3 == `FUNCT3_SUB && funct7 == `FUNCT7_SUB) begin
            alu_op = `FUNC_SUB; // Subtraction

        end else if ((opcode == `ARITHMETIC || opcode == `ARITHMETIC_IMM) && funct3 == `FUNCT3_SRL && funct7 == `FUNCT7_SUB) begin
            alu_op = `FUNC_ARS; // Arithematic Right Shift

        end else if ((opcode == `ARITHMETIC || opcode == `ARITHMETIC_IMM) && funct3 == `FUNCT3_SLL) begin
            alu_op = `FUNC_LLS; // Logical Left Shift

        end else if ((opcode == `ARITHMETIC || opcode == `ARITHMETIC_IMM) && funct3 == `FUNCT3_SRL) begin
            alu_op = `FUNC_LRS; // Logical Right Shift

        end else if ((opcode == `ARITHMETIC || opcode == `ARITHMETIC_IMM) && funct3 == `FUNCT3_XOR) begin
            alu_op = `FUNC_XOR; // XOR

        end else if ((opcode == `ARITHMETIC || opcode == `ARITHMETIC_IMM) && funct3 == `FUNCT3_OR) begin
            alu_op = `FUNC_OR; // OR

        end else if ((opcode == `ARITHMETIC || opcode == `ARITHMETIC_IMM) && funct3 == `FUNCT3_AND) begin
            alu_op = `FUNC_AND; // AND
        end
    end

endmodule

module HATLED(input is_ecall,
              input [31:0] rs1_dout,
              input stall,
              output reg is_halted);

    always @(is_ecall, rs1_dout, stall) begin
        if (stall) begin
            is_halted = 0;
        end else if (is_ecall && (rs1_dout == 10)) begin
            is_halted = 1;
        end else begin
            is_halted = 0;
        end
    end
endmodule

module PC_SRC(input bcond,
              input is_jal,
              input is_jalr,
              output reg [1:0] pc_src);
    
    always @(*) begin

        if (!bcond && !is_jal && !is_jalr) begin
            pc_src = 2'b00;
        end else if (bcond || is_jal) begin
            pc_src = 2'b01;
        end else if (is_jalr) begin
            pc_src = 2'b10;
        end

    end

endmodule