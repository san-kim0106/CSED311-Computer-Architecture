module MEM_MUX(input[31:0] current_pc,
               input[31:0] d_addr,
               input iord,
               
               output reg [31:0] addr);
    
    always @(*) begin
        if (iord) begin
            addr = d_addr;
        end
        else begin
            addr = current_pc;
        end
    end

endmodule

module REG_MUX(input [31:0] alu_out,
               input [31:0] dout,
               input mem_to_reg,
               
               output reg [31:0] reg_write_data);

    always @(*) begin
        if (mem_to_reg) begin
            reg_write_data = dout;
        end 
        else begin
            reg_write_data = alu_out;
        end
    end

endmodule

module ALU_SRC_A_MUX(input [31:0] current_pc,
                     input [31:0] rs1_out,

                     input ALUSrcA,

                     output reg [31:0] alu_in1);

    always @(*) begin
        if (ALUSrcA) begin
            alu_in1 = rs1_out;
        end
        else begin
            alu_in1 = current_pc;
        end
        // $display("ALU_SRC_A_MUX current_pc: %d | rs1_out: %d | ALUSrcA: %d", current_pc, rs1_out, ALUSrcA); //! DEBUGGING
    end

endmodule

module ALU_SRC_B_MUX(input [31:0] rs2_out,
                     input [31:0] imm_gen_out,

                     input ALUSrcB0,
                     input ALUSrcB1,

                     output reg [31:0] alu_in2);
                     
    always @(*) begin
        if (!ALUSrcB1 && !ALUSrcB0) begin
            alu_in2 = rs2_out;
        end
        else if (!ALUSrcB1 && ALUSrcB0) begin
            alu_in2 = 4;
        end
        else if (ALUSrcB1 && !ALUSrcB0) begin
            alu_in2 = imm_gen_out;
        end else begin
            alu_in2 = 0; // Used at RESET state
        end
    end

endmodule

module PC_MUX(input [31:0] alu_out,
              input [31:0] alu_out_reg,
              
              input bcond,
              input pc_source,
              
              output reg [31:0] next_pc);

    always @(*) begin
        if (!pc_source && !bcond) begin
            // $display("BRANCH NOT TAKEN"); //! DEBUGGING
            next_pc = alu_out_reg;
        end else begin
            // $display("BRACNH TAKEN"); //! DEBUGGING
            next_pc = alu_out;
        end
        // $display("PC MUX next_pc: %d", next_pc); //! DEBUGGING
    end

endmodule