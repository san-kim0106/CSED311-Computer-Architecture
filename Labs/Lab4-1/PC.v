module PC(input reset,
          input clk,
          input stall,
          input [31:0] next_pc,
          output reg [31:0] current_pc);

    reg [31:0] current_pc_reg;
    
    always @(posedge clk) begin
        if (reset) begin
            current_pc <= 32'b0;
            current_pc_reg <= 32'b0;
        end else if (stall) begin
            current_pc <= current_pc_reg; // Don't increment PC if stall condition
        end else begin
            current_pc <= next_pc;
            current_pc_reg <= next_pc;
        end
    end
endmodule

module PC_ADDER(input [31:0] current_pc,
                output reg [31:0] next_pc);
    
    always @(current_pc) begin
        next_pc = current_pc + 4;
    end

endmodule