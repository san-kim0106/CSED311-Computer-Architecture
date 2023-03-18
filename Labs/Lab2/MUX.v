module ALU_MUX(input [31:0] rs2_out,
               input [31:0] imm_gen_out,
               input alu_src,
               output reg [31:0] alu_in2);
    
    always @(*) begin
        if (alu_src) alu_in2 = imm_gen_out;
        else alu_in2 = rs2_out;
    end

endmodule