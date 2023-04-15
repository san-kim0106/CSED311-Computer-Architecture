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

module NEXT_STATE_ADDER(input [3:0] current_state,
                        output reg [3:0] next_state);
    
    always @(*) begin
        next_state = current_state + 1;
    end
endmodule

module ROM1(input [6:0] opcode,
            output reg [3:0] rom1_out);
    
    always @(opcode) begin
        case (opcode)
            `ARITHMETIC: rom1_out = 4'b0110;
            `BRANCH:     rom1_out = 4'b1000;
            `LOAD:       rom1_out = 4'b0010;
            `STORE:      rom1_out = 4'b0010;
            default:     rom1_out = 4'b0000;
        endcase 
    end
endmodule

module ROM2(input [6:0] opcode,
            output reg [3:0] rom2_out);

    always @(opcode) begin
        case (opcode)
            `LOAD:   rom2_out = 4'b0011;
            `STORE:  rom2_out = 4'b0101;
            default: rom2_out = 4'b0000;
        endcase
    end
endmodule

module NEXT_STATE_MUX(input [3:0] adder_out,
                      input [3:0] rom1_out,
                      input [3:0] rom2_out,
                      input [1:0] addr_clt,
                      output reg [3:0] next_state);
    
    always @(*) begin
        case (addr_clt)
            2'b00:   next_state = 4'b0000;
            2'b01:   next_state = rom1_out;
            2'b10:   next_state = rom2_out;
            2'b11:   next_state = adder_out;
            default: next_state = 4'b0000;
        endcase
    end
endmodule

module STATE_REGISTER(input clk,
                     input [3:0] next_state,
                     output reg [3:0] current_state);

    always @(posedge clk) begin
        current_state <= next_state;
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
            `STATE2: begin end
            `STATE3: begin end
            `STATE4: begin end
            `STATE5: begin end
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
            default: begin end

        endcase

        if (current_state == 4 || current_state == 5 || current_state == 7 || current_state == 8 || current_state == 9) begin
            addr_clt = 2'b00;
        end else if (current_state == 1) begin
            addr_clt = 2'b01;
        end else if (current_state == 2) begin
            addr_clt = 2'b10;
        end else if (current_state == 0 || current_state == 3 || current_state == 6) begin
            addr_clt = 2'b11;
        end

    end
endmodule

module ALUControlUnit (input [1:0] alu_op,
                       input [2:0] funct3,
                       input [6:0] funct7,
                       output reg [3:0] _alu_op);
    
    always @(*) begin
        if (alu_op == 2'b00) begin
            _alu_op = `FUNC_ADD;
        end
    end
    

endmodule