module PC (input reset,
           input clk,
           input[31:0] next_pc,
           output reg [31:0] current_pc,
           output is_halted);
    
    // Initialize the PC value to zero 
    
    always @(posedge clk) begin
        if (reset) current_pc <= 0;
        else current_pc <= next_pc;
    end

endmodule

module nextPC (input[31:0] current_pc,
               output reg [31:0] next_pc);

    always @(current_pc) begin
        next_pc = current_pc + 4;
    end
    
endmodule