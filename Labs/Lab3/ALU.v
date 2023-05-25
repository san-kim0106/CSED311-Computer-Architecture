`include "ALUop.v"

module ALU (input[3:0] alu_op,
            input[31:0] in_1,
            input[31:0] in_2,
            output reg [31:0] alu_out);

	always @(in_1, in_2) begin
		// $display("ALU UNIT in_1: %d | in_2: %d | alu_op: %d", in_1, in_2, alu_op); //! DEBUGGING
		case (alu_op)
			`FUNC_ADD: begin
				alu_out = in_1 + in_2; 
			end

			`FUNC_SUB: begin
				alu_out = in_1 - in_2; 
			end

			`FUNC_JALR: begin
				alu_out = (in_1 + in_2) & 32'hfffffffe; 
			end
            
			`FUNC_NOT: begin 
				alu_out = ~in_1; 
			end
 
			`FUNC_AND: begin
				alu_out = in_1 & in_2; 
			end

			`FUNC_OR: begin
				alu_out = in_1 | in_2; 
			end

			`FUNC_XOR: begin
				alu_out = in_1 ^ in_2; 
			end

			`FUNC_LLS: begin
				alu_out = in_1 << in_2[4:0];
			end

			`FUNC_LRS: begin
				alu_out = in_1 >> in_2[4:0];
			end

			`FUNC_ARS: begin
				alu_out = $signed(in_1) >>> in_2[4:0]; 
			end

			`FUNC_BEQ: begin
				alu_out = in_1 + in_2;
			end

			`FUNC_BNE: begin
				alu_out = in_1 + in_2;
			end

			`FUNC_BLT: begin
				alu_out = in_1 + in_2;
			end

			`FUNC_BGE: begin
				alu_out = in_1 + in_2;
			end

			default: begin
				alu_out = 0;
			end
		endcase

		// $display("alu_op: %d | in_1: %d | in_2: %d | alu result: %d", alu_op, in_1, in_2, alu_out); //! FOR DEBUGGING

	end

endmodule

module BRANCH_DIRECTION(input [3:0] _alu_op,
						input [31:0] in_1,
						input [31:0] in_2,
						output reg bcond);

	always @(*) begin
		if (_alu_op == `FUNC_BEQ) begin
			if (in_1 == in_2) bcond = 1;
			else bcond = 0;

			// $display("BEQ bcond: %d", bcond); //! DEBUGGING

		end else if (_alu_op == `FUNC_BNE) begin
			if (in_1 != in_2) bcond = 1;
			else bcond = 0;

		end else if (_alu_op == `FUNC_BLT) begin
			if ($signed(in_1) < $signed(in_2)) bcond = 1;
			else bcond = 0;

		end else if (_alu_op == `FUNC_BGE) begin
			if ($signed(in_1) >= $signed(in_2)) bcond = 1;
			else bcond = 0;

		end else begin
			bcond = 0;
		end
	end


endmodule