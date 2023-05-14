`include "opcodes.v"

module HAZARD_DETECTION (input [31:0] current_inst,

                         input [4:0] dist1_rd,
                         input dist1_reg_write,
                         input dist1_is_load,

                         input [4:0] dist2_rd,
                         input dist2_reg_write,

                         output reg stall
                         );
    /*
    opcode: current_inst[6:0]
       rs1: current_inst[19:15]
       rs2: current_inst[24:20]

    use_rs1: ECALL, ARITHEMATIC, ARITHEMATIC_IMM, LOAD, STORE
    use_rs2:        ARITHEMATIC,                  LOAD, STORE
    */
    
    always @(*) begin
        stall = 0; 

        // Check Hazard for ecall
        if (current_inst[6:0] == `ECALL) begin
            if (dist1_rd == 17 && dist1_reg_write) begin
                stall = 1;
            end else if (dist2_rd == 17 && dist2_reg_write) begin
                stall = 1;
            end else begin
                stall = 0;
            end
        end

        // Check Hazard for rs1
        if (current_inst[6:0] == `ARITHMETIC || current_inst[6:0] == `ARITHMETIC_IMM || current_inst[6:0] == `LOAD || current_inst[6:0] == `STORE || current_inst[6:0] == `BRANCH || current_inst[6:0] == `JALR) begin
            if (current_inst[19:15] == dist1_rd && dist1_rd != 0 && dist1_is_load) begin
                stall = 1;
            end else begin
                stall = 0;
            end
        end

        // Check Hazard for rs2
        if ((current_inst[6:0] == `ARITHMETIC || current_inst[6:0] == `STORE || current_inst[6:0] == `BRANCH) && stall == 0) begin
            if (current_inst[24:20] == dist1_rd && dist1_rd != 0 && dist1_is_load) begin
                stall = 1;
            end else begin
                stall = 0;
            end
        end
    end

endmodule