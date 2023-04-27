`include "opcodes.v"

module HAZARD_DETECTION (input [31:0] current_inst,

                         input [4:0] EX_rd,
                         input EX_reg_write,

                         input [4:0] MEM_rd,
                         input MEM_reg_write,

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
        // Check Hazard for rs1
        if (current_inst[6:0] == `ECALL || current_inst[6:0] == `ARITHMETIC || current_inst[6:0] == `ARITHMETIC_IMM || current_inst[6:0] == `LOAD || current_inst[6:0] == `STORE) begin
            if (current_inst[19:15] == EX_rd && EX_reg_write) begin
                stall = 1;
            end else if (current_inst[19:15] == MEM_rd && MEM_reg_write) begin
                stall = 1;

            end else begin
                stall = 0;
            end
        end

        // Check Hazard for rs2
        if (current_inst[6:0] == `ARITHMETIC || current_inst[6:0] == `LOAD || current_inst[6:0] == `STORE) begin
            if (current_inst[24:20] == EX_rd && EX_reg_write) begin
                stall = 1;
            end else if (current_inst[24:20] == MEM_rd && MEM_reg_write) begin
                stall = 1;

            end else begin
                stall = 0;
            end
        end
    end

endmodule