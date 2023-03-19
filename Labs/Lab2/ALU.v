`include "ALUop.v"

module ALU (input[3:0] alu_op,
            input[31:0] in_1,
            input[31:0] in_2,
            output reg [31:0] alu_out,
            output reg bcond);

    //TODO: implement bcond
	always @(*) begin
		case (alu_op)
			`FUNC_ADD: alu_out = in_1 + in_2;

			`FUNC_JALR: alu_out = (in_1 + in_2) & 32'hfffffffe;

			`FUNC_SUB: alu_out = in_1 - in_2;

			`FUNC_ID: alu_out = in_1;
            
			`FUNC_NOT: alu_out = ~in_1;

			`FUNC_AND: alu_out = in_1 & in_2;

			`FUNC_OR: alu_out = in_1 | in_2;

			`FUNC_NAND: alu_out = ~(in_1 & in_2);

			`FUNC_NOR: alu_out = ~(in_1 | in_2);

			`FUNC_XOR: alu_out = in_1 ^ in_2;
            
			`FUNC_XNOR: alu_out = ~(in_1 ^ in_2);

			`FUNC_LLS: alu_out = in_1 << in_2[4:0];

			`FUNC_LRS: alu_out = in_1 >> in_2[4:0];

			`FUNC_ALS: alu_out = in_1 <<< in_2[4:0];

			`FUNC_ARS: alu_out = $signed(in_1) >>> in_2[4:0];

			`FUNC_TCP: alu_out = ~in_1 + 1;

			default: alu_out = 0;
		endcase
		// $display("alu_op: %d | in_1: %d | in_2: %d | alu result: %d", alu_op, in_1, in_2, alu_out); //! FOR DEBUGGING

	end

endmodule