`include "ALUop.v"

module ALU (input[3:0] alu_op,
            input[31:0] in_1,
            input[31:0] in_2,
            output reg [31:0] out,
            output reg bcond);

    //TODO: implement bcond
	always @(*) begin
		case (alu_op)
			`FUNC_ADD: out = in_1 + in_2;

			`FUNC_SUB: out = in_1 - in_2;

			`FUNC_ID: out = in_1;
            
			`FUNC_NOT: out = ~in_1;

			`FUNC_AND: out = in_1 & in_2;

			`FUNC_OR: out = in_1 | in_2;

			`FUNC_NAND: out = ~(in_1 & in_2);

			`FUNC_NOR: out = ~(in_1 | in_2);

			`FUNC_XOR: out = in_1 ^ in_2;
            
			`FUNC_XNOR: out = ~(in_1 ^ in_2);

			`FUNC_LLS: out = in_1 << 1;

			`FUNC_LRS: out = in_1 >> 1;

			`FUNC_ALS: out = in_1 <<< 1;

			`FUNC_ARS: out = $signed(in_1) >>> 1;

			`FUNC_TCP: out = ~in_1 + 1;

			`FUNC_ZERO: out = 0;

			default: out = 0;
		endcase
		// $display("alu_op: %d | in_1: %d | in_2: %d | alu result: %d", alu_op, in_1, in_2, out); //! FOR DEBUGGING

	end

endmodule