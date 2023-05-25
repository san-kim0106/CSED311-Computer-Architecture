module PC (input reset,
           input clk,
           input[31:0] next_pc,
           input pc_write,
           output reg [31:0] current_pc);
    
    always @(posedge clk) begin
        if (reset) current_pc <= 0; //! CHANGE TO NON-BLOCKING
        else if (pc_write) begin
            current_pc <= next_pc; //! CHANGE TO NON-BLOCKING
        end
        // $display("\ncurrent_pc: %d | next_pc: %d | pc_write: %d", current_pc, next_pc, pc_write); //! DUBUGGING
    end

endmodule