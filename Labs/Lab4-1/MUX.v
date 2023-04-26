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

module WB_MUX (input [31:0] reg_src1,
               input [31:0] reg_src2,
               input mem_to_reg,
               output reg [31:0] rd_din);
    
    always @(*) begin
        if (mem_to_reg) begin
            rd_din = reg_src1;
        end else begin
            rd_din = reg_src2;
        end
    end

endmodule