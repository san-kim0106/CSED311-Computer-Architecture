`include "opcodes.v"

module FORWARDING_UNIT(input [6:0] opcode,
                       input [4:0] rs1,
                       input [4:0] rs2,

                       input [4:0] dist1_rd,
                       input dist1_reg_write,

                       input [4:0] dist2_rd,
                       input dist2_reg_write,

                       output reg [1:0] forward_a,
                       output reg [1:0] forward_b);
    
    /*
    forward_x
        00: No forwarding
        01: Distance 1 forwarding
        10: Distance 2 forwarding
        11: Not used
    */

    always @(*) begin

        // Forwarding logic for rs1
        if (opcode == `ARITHMETIC || opcode == `ARITHMETIC_IMM || opcode == `LOAD || opcode == `STORE) begin
            if (rs1 == dist1_rd && dist1_rd != 0 && dist1_reg_write) begin
                forward_a = 2'b01; // distance 1 forwarding
            end else if (rs1 == dist2_rd && dist2_rd != 0 && dist2_reg_write) begin
                forward_a = 2'b10; // distance 2 forwarding
            end else begin
                forward_a = 2'b00; // no forwarding
            end
        end else begin
            forward_a = 2'b00; // Default: no forwarding
        end
            

        // Forwarding logic for rs2
        if (opcode == `ARITHMETIC || opcode == `LOAD || opcode == `STORE) begin
            if (rs2 == dist1_rd && dist1_rd != 0 && dist1_reg_write) begin
                forward_b = 2'b01; // distance 1 forwarding
            end else if (rs2 == dist2_rd && dist2_rd != 0 && dist2_reg_write) begin
                forward_b = 2'b10; // distance 2 forwarding
            end else begin
                forward_b = 2'b00; // no forwarding
            end
        end else begin
            forward_b = 2'b00; // Default: no forwarding
        end

    end
    


endmodule