module PC (input reset,
           input clk,
           input[31:0] next_pc,
           output reg [31:0] current_pc);
    
    // Initialize the PC value to zero
    
    always @(posedge clk) begin
        if (reset) current_pc <= 0;
        else current_pc <= next_pc;
    end

endmodule

module Plus_Four_PC (input[31:0] current_pc,
               output reg [31:0] plus_four_pc);

    always @(current_pc) begin
        plus_four_pc = current_pc + 4;
    end
    
endmodule

module jumpPC (input [31:0] current_pc,
               input [31:0] imm_gen_out,
               output reg [31:0] jump_pc);

    always @(current_pc, imm_gen_out) begin
        jump_pc = current_pc + imm_gen_out;
    end

endmodule