module ALU_MUX(input [31:0] rs2_out,
               input [31:0] imm_gen_out,
               input alu_src,
               output reg [31:0] alu_in2);
    
    always @(*) begin
        if (alu_src) alu_in2 = imm_gen_out;
        else alu_in2 = rs2_out;
    end

endmodule

module ALU_Write_MUX(input [31:0] next_pc,
                     input [31:0] dout,
                     input pc_to_reg,
                     output reg [31:0] rd_din);
    
    always @(next_pc, dout, pc_to_reg) begin
        if (pc_to_reg) rd_din = next_pc;
        else rd_din = dout;
    end

endmodule

module PC_MUX(input [31:0] plus_four_pc,
              input [31:0] jump_pc,
              input [31:0] alu_out,
              input is_jal,
              input is_jalr,
              input branch,
              input bcond,
              output reg [31:0] next_pc);
    
    wire cond1;
    wire cond2;

    assign cond1 = (branch & bcond) | is_jal;
    assign cond2 = is_jalr;

    always @(*) begin
        if (!cond1 && !cond2) next_pc = plus_four_pc;
        else if (!cond1 && cond2) begin
            // $display("next_pc = alu_out (%d)", alu_out); //! FOR DEBUGGING
            next_pc = alu_out;
        end
<<<<<<< HEAD
        else if (cond1 && !cond2) begin
        // $display("check jump_pc");
        next_pc = jump_pc;
        end
=======
        else if (cond1 && !cond2) next_pc = jump_pc;
>>>>>>> 8d624cd1ac5eb7437f38dcdef4afa3f13b2bafec

    end

endmodule

module Memory_MUX(input [31:0] mem_out,
                  input [31:0] alu_out,
                  input mem_to_reg,
                  output reg [31:0] dout);
    
    always @(*) begin
        if (mem_to_reg) dout = mem_out;
        else dout = alu_out;
    end

endmodule