`include "opcodes.v"
`include "ALUop.v"

`define STATE0 4'b0000
`define STATE1 4'b0001
`define STATE2 4'b0010
`define STATE3 4'b0011
`define STATE4 4'b0100
`define STATE5 4'b0101
`define STATE6 4'b0110
`define STATE7 4'b0111
`define STATE8 4'b1000
`define STATE9 4'b1001
`define STATE10 4'b1010

module NEXT_STATE_ADDER(input [3:0] current_state,
                        input reset,
                        output reg [3:0] next_state);
    
    always @(current_state) begin
        if (reset) begin
            next_state <= 0;
        end else begin
            next_state = current_state + 1;
        end
    end
endmodule

module ROM1(input [6:0] opcode,
            output reg [3:0] rom1_out,
            output reg is_ecall);
    
    always @(opcode) begin
        // $display("ROM1 opcode: %d", opcode); //! DEBUGGING
        is_ecall = 0; 
        case (opcode)
            `ARITHMETIC:     rom1_out = 4'b0110; // STATE6
            `ARITHMETIC_IMM: rom1_out = 4'b1010; // STATE10
            `BRANCH:         rom1_out = 4'b1000; // STATE8
            `LOAD:           rom1_out = 4'b0010; // STATE2
            `STORE:          rom1_out = 4'b0010; // STATE2
            `ECALL:          is_ecall = 1;       // HALT
            default:         rom1_out = 4'b0000; // STATE0
        endcase 
    end
endmodule

module ROM2(input [6:0] opcode,
            output reg [3:0] rom2_out);

    always @(opcode) begin
        // $display("ROM2 opcode: %d", opcode); //! DEBUGGING
        case (opcode)
            `LOAD:           rom2_out = 4'b0011; // STATE3
            `STORE:          rom2_out = 4'b0101; // STATE5
            `ARITHMETIC_IMM: rom2_out = 4'b0111; // STATE7
            default:         rom2_out = 4'b0000; // STATE0
        endcase
    end
endmodule

module NEXT_STATE_MUX(input reset,
                      input [3:0] adder_out,
                      input [3:0] rom1_out,
                      input [3:0] rom2_out,
                      input [1:0] addr_clt,
                      output reg [3:0] next_state);
    
    always @(adder_out, rom1_out, rom2_out, addr_clt) begin
        if (reset) begin
            // $display("reset: 1 | adder_out: %d | rom1_out: %d | rom2_out: %d | addr_clt: %d", adder_out, rom1_out, rom2_out, addr_clt); //! DEBUGGING
            next_state = 4'b0000;
        end else begin
            // $display("adder_out: %d | rom1_out: %d | rom2_out: %d | addr_clt: %d", adder_out, rom1_out, rom2_out, addr_clt); //! DEBUGGING
            case (addr_clt)
                2'b00:   next_state = 4'b0000;
                2'b01:   next_state = rom1_out;
                2'b10:   next_state = rom2_out;
                2'b11:   next_state = adder_out;
                default: next_state = 4'b0000;
            endcase
        end
    end
endmodule

module STATE_REGISTER(input clk,
                      input reset,
                      input [3:0] next_state,
                      output reg [3:0] current_state);

    always @(posedge clk) begin
        if (reset) begin
            current_state <= 4'b1111;
        end else begin
            current_state <= next_state;
        end
        // $display("current_state: %d", current_state); //! DEBUGGING
    end
endmodule

module CONTROL_SIGNALS(input [3:0] current_state,
                      output reg pc_write_cond,
                      output reg pc_write,
                      output reg iord,
                      output reg mem_read,
                      output reg mem_write,
                      output reg ir_write,
                      output reg mem_to_reg,
                      output reg reg_write,
                      output reg alu_src_a,
                      output reg [1:0] alu_src_b,
                      output reg [1:0] alu_op,
                      output reg pc_source,
                      output reg [1:0] addr_clt);
    
    always @(current_state) begin
        $display("Control Unit current_state: %d", current_state); //! DEBUGGING
        case (current_state)
            `STATE0: begin
                pc_write_cond = 0;
                pc_write = 1;
                iord = 0;
                mem_read = 1;
                mem_write = 0;
                ir_write = 1;
                mem_to_reg = 0; // DON'T CARE
                reg_write = 0;
                alu_src_a = 0; // DON'T CARE
                alu_src_b = 2'b00; // DON'T CARE
                alu_op = 2'b00; // DON'T CARE
                pc_source = 0; // DON'T CARE
            end
            `STATE1: begin
                pc_write_cond = 0;
                pc_write = 0;
                iord = 0;
                mem_read = 0;
                mem_write = 0;
                ir_write = 0;
                mem_to_reg = 0;
                reg_write = 0;
                alu_src_a = 0; // DON'T CARE
                alu_src_b = 2'b00; // DON'T CARE
                alu_op = 2'b00; // DON'T CARE
                pc_source = 0; // DON'T CARE
            end
            `STATE2: begin 
                pc_write_cond = 0;
                pc_write = 0;
                iord = 0;
                mem_read = 0;
                mem_write = 0;
                ir_write = 0;
                mem_to_reg = 0;
                reg_write = 0;
                alu_src_a = 1;
                alu_src_b = 2'b10;
                alu_op = 2'b00;
                pc_source = 0; // DON'T CARE
            end
            `STATE3: begin
                pc_write_cond = 0;
                pc_write = 0;
                iord = 1;
                mem_read = 1;
                mem_write = 0;
                ir_write = 0;
                mem_to_reg = 0;
                reg_write = 0;
                alu_src_a = 0; // DON'T CARE
                alu_src_b = 2'b00; // DON'T CARE
                alu_op = 2'b00; // DON'T CARE
                pc_source = 0; // DON'T CARE
            end
            `STATE4: begin
                pc_write_cond = 0;
                pc_write = 0;
                iord = 0;
                mem_read = 0;
                mem_write = 0;
                ir_write = 0;
                mem_to_reg = 1;
                reg_write = 1;
                alu_src_a = 0;
                alu_src_b = 2'b01;
                alu_op = 2'b00;
                pc_source = 0;
            end
            `STATE5: begin
                pc_write_cond = 0;
                pc_write = 0;
                iord = 1;
                mem_read = 0;
                mem_write = 1;
                ir_write = 0;
                mem_to_reg = 0;
                reg_write = 0;
                alu_src_a = 0;
                alu_src_b = 2'b01;
                alu_op = 2'b00;
                pc_source = 0;
            end
            `STATE6: begin
                pc_write_cond = 0;
                pc_write = 0;
                iord = 0;
                mem_read = 0;
                mem_write = 0;
                ir_write = 0;
                mem_to_reg = 0;
                reg_write = 0;
                alu_src_a = 1;
                alu_src_b = 2'b00;
                alu_op = 2'b00; //TODO ADD
                pc_source = 0; // DON'T CARE
            end
            `STATE7: begin
                pc_write_cond = 0;
                pc_write = 0;
                iord = 0;
                mem_read = 0;
                mem_write = 0;
                ir_write = 0;
                mem_to_reg = 0;
                reg_write = 1;
                alu_src_a = 0;
                alu_src_b = 2'b01;
                alu_op = 2'b00; //TODO ADD
                pc_source = 0;
            end
            `STATE8: begin end
            `STATE9: begin end
            `STATE10: begin
                pc_write_cond = 0;
                pc_write = 0;
                iord = 0;
                mem_read = 0;
                mem_write = 0;
                ir_write = 0;
                mem_to_reg = 0;
                reg_write = 0;
                alu_src_a = 1;
                alu_src_b = 2'b10;
                alu_op = 2'b00; //TODO ADD
                pc_source = 0; // DON'T CARE

            end
            default: begin end

        endcase

        if (current_state == `STATE4 || current_state == `STATE5 || current_state == `STATE7 || current_state == `STATE8 || current_state == `STATE9) begin
            addr_clt = 2'b00; // GOTO STATE0
        end else if (current_state == `STATE1) begin
            addr_clt = 2'b01; // ROM1
        end else if (current_state == `STATE2 || current_state == `STATE10) begin
            addr_clt = 2'b10; // ROM2
        end else if (current_state == `STATE0 || current_state == `STATE3 || current_state == `STATE6) begin
            addr_clt = 2'b11; // STATE N + 1
        end

    end
endmodule

module ALUControlUnit (input [1:0] alu_op,
                       input [2:0] funct3,
                       input [6:0] funct7,
                       output reg [3:0] _alu_op);
    
    /* 
    alu_op
        00 : Addition operation for Addr. calcualtion
        01 : R/I type and Bxx
    */

    always @(*) begin
        if (alu_op == 2'b00) begin
            _alu_op = `FUNC_ADD;
        end
    end
    

endmodule