module PC_MUX(input [31:0] pc_plus_four, // plus four adder
              input [31:0] pc_branch, // JAL/Branch adder
              input [31:0] pc_jalr, // alu_out
              input [1:0] pc_src,
              output reg [31:0] next_pc);
    
    always @(*) begin
        if (pc_src == 0) begin
            next_pc = pc_plus_four;
        end else if (pc_src == 1) begin
            next_pc = pc_branch;
        end else if (pc_src == 2) begin
            next_pc = pc_jalr;
        end
    end

endmodule

module ALU_SRC_MUX (input [31:0] rs2_data,
                    input [31:0] imm_gen_out,
                    input alu_src,
                    output reg [31:0] alu_in2);
    
    always @(*) begin
        if (alu_src) begin
            alu_in2 = imm_gen_out;
        end else begin
            alu_in2 = rs2_data;
        end
    end

endmodule

module ALU_INPUT_MUX(input [31:0] no_forwarding,
                     input [31:0] dist1_forwarding,
                     input [31:0] dist2_forwarding,
                     input [1:0] selector,
                     output reg [31:0] alu_in);
    
    always @(*) begin
        if (selector == 2'b00) begin
            alu_in = no_forwarding;
        end else if (selector == 2'b01) begin
            alu_in = dist1_forwarding;
        end else if (selector == 2'b10) begin
            alu_in = dist2_forwarding;
        end
    end

endmodule

module WB_MUX (input [31:0] reg_src1,
               input [31:0] reg_src2,
               input [31:0] plus_four_pc,
               input mem_to_reg,
               input is_jal,
               input is_jalr,
               output reg [31:0] rd_din);
    
    always @(*) begin
        if (is_jal || is_jalr) begin
            rd_din = plus_four_pc;
        end else if (mem_to_reg) begin
            rd_din = reg_src1;
        end else begin
            rd_din = reg_src2;
        end
    end

endmodule

module HALTED_MUX (input [4:0] rs1,
                   input is_ecall,
                   output reg [4:0] rs1_in);
    
    always @(*) begin
        if (is_ecall) begin
            rs1_in = 17;
        end else begin
            rs1_in = rs1;
        end
    end

endmodule

module STALL_MUX (input cltr,
                  input stall,
                  output reg cltr_out);

    always @(*) begin
        if (stall) begin
            cltr_out = 0;
        end else begin
            cltr_out = cltr;
        end
    end

endmodule