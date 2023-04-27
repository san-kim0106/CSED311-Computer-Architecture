module PC(input reset,
          input clk,
          input [31:0] next_pc,
          output reg [31:0] current_pc);
    
    always @(posedge clk) begin
        if (reset) begin
            current_pc <= 32'b0;
        end else begin
            current_pc <= next_pc;
        end
    end
endmodule

module PC_ADDER(input [31:0] current_pc,
                input stall,
                output reg [31:0] next_pc);
    
    always @(*) begin
        if (stall) begin
            next_pc = current_pc; // Don't increment PC when stall condition
        end else begin
            next_pc = current_pc + 4;
        end
    end

endmodule